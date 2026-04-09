import 'dart:async';
import 'dart:io';
import 'package:elmotamizon/app/app_constants.dart';
import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/strings_manager.dart';
import 'package:elmotamizon/features/bottom_nav_bar/view/bottom_nav_bar_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class DigitalPaymentView extends StatefulWidget {
  final String url;
  final bool isBook;
  const DigitalPaymentView({
    super.key,
    required this.url,
    this.isBook = false,
  });

  @override
  DigitalPaymentViewState createState() => DigitalPaymentViewState();
}

class DigitalPaymentViewState extends State<DigitalPaymentView> {
  String? selectedUrl;
  double value = 0.0;

  PullToRefreshController? pullToRefreshController;
  late MyInAppBrowser browser;

  @override
  void initState() {
    super.initState();
    selectedUrl = widget.url;
    _initData();
  }

  void _initData() async {
    final String cleanedUrl = (selectedUrl ?? '').trim();
    final Uri? parsedUri = Uri.tryParse(cleanedUrl);
    final bool isValidUrl = parsedUri != null &&
        parsedUri.hasScheme &&
        (parsedUri.scheme == 'http' || parsedUri.scheme == 'https') &&
        (parsedUri.host.isNotEmpty);

    if (!isValidUrl) {
      if (!mounted) return;
      AppFunctions.showsToast(
          AppStrings.unKnownError.tr(), ColorManager.red, context);
      AppFunctions.navigateToAndFinish(context, const BottomNavBarView());
      return;
    }

    browser = MyInAppBrowser(context, widget.isBook);
    if (Platform.isAndroid) {
      await InAppWebViewController.setWebContentsDebuggingEnabled(true);
      bool swAvailable = await WebViewFeature.isFeatureSupported(
          WebViewFeature.SERVICE_WORKER_BASIC_USAGE);
      bool swInterceptAvailable = await WebViewFeature.isFeatureSupported(
          WebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);
      if (swAvailable && swInterceptAvailable) {
        ServiceWorkerController serviceWorkerController =
            ServiceWorkerController.instance();
        await serviceWorkerController
            .setServiceWorkerClient(ServiceWorkerClient(
          shouldInterceptRequest: (request) async {
            if (kDebugMode) {
              print(request);
            }
            return null;
          },
        ));
      }
    }
    await browser.openUrlRequest(
        urlRequest: URLRequest(url: WebUri(cleanedUrl)),
        settings: InAppBrowserClassSettings(
            webViewSettings: InAppWebViewSettings(
                useShouldOverrideUrlLoading: true, useOnLoadResource: true),
            browserSettings: InAppBrowserSettings(
                hideUrlBar: true, hideToolbarTop: Platform.isAndroid)));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (val) => _exitApp(context),
      child: const Scaffold(),
    );
  }

  Future<bool> _exitApp(BuildContext context) async {
    try {
      await browser.close();
    } catch (_) {}
    if (!mounted) return Future.value(true);
    AppFunctions.navigateToAndFinish(context, const BottomNavBarView());
    AppFunctions.showsToast(
        AppStrings.paymentCanceled.tr(), ColorManager.red, context);
    return Future.value(true);
  }
}

class MyInAppBrowser extends InAppBrowser {
  final bool isBook;
  final BuildContext context;

  MyInAppBrowser(
    this.context,
    this.isBook, {
    super.windowId,
    super.initialUserScripts,
  });

  bool _canRedirect = true;

  @override
  Future onBrowserCreated() async {
    if (kDebugMode) {
      print("\n\nBrowser Created!\n\n");
    }
  }

  @override
  Future onLoadStart(url) async {
    if (kDebugMode) {
      print("\n\nStarted: $url\n\n");
    }
    _pageRedirect(url.toString());
  }

  @override
  Future onLoadStop(url) async {
    pullToRefreshController?.endRefreshing();
    if (kDebugMode) {
      print("\n\nStopped: $url\n\n");
    }
    _pageRedirect(url.toString());
  }

  @override
  void onLoadError(url, code, message) {
    pullToRefreshController?.endRefreshing();
    if (kDebugMode) {
      print("Can't load [$url] Error: $message");
    }
  }

  @override
  void onProgressChanged(progress) {
    if (progress == 100) {
      pullToRefreshController?.endRefreshing();
    }
    if (kDebugMode) {
      print("Progress: $progress");
    }
  }

  @override
  void onExit() {
    if (_canRedirect) {
      AppFunctions.navigateToAndFinish(context, const BottomNavBarView());
      AppFunctions.showsToast(
          AppStrings.paymentFailed.tr(), ColorManager.red, context);
    }

    if (kDebugMode) {
      print("\n\nBrowser closed!\n\n");
    }
  }

  @override
  Future<NavigationActionPolicy> shouldOverrideUrlLoading(
      navigationAction) async {
    if (kDebugMode) {
      print("\n\nOverride ${navigationAction.request.url}\n\n");
    }
    return NavigationActionPolicy.ALLOW;
  }

  @override
  void onLoadResource(resource) {}

  @override
  void onConsoleMessage(consoleMessage) {
    if (kDebugMode) {
      print("""
    console output:
      message: ${consoleMessage.message}
      messageLevel: ${consoleMessage.messageLevel.toValue()}
   """);
    }
  }

  void _pageRedirect(String url) {
    if (_canRedirect) {
      final Uri? parsedUrl = Uri.tryParse(url);
      final Uri? appBase = Uri.tryParse(AppConstants.baseUrl);

      final bool isAppDomainRedirect = parsedUrl != null &&
          appBase != null &&
          parsedUrl.host == appBase.host;

      final Map<String, String> params = parsedUrl?.queryParameters ?? {};
      final String successParam = (params['success'] ?? '').toLowerCase();
      final String statusParam = (params['status'] ?? '').toLowerCase();
      final String paymentStatusParam =
          (params['payment_status'] ?? '').toLowerCase();

      final bool isSuccess = isAppDomainRedirect &&
          (successParam == 'true' ||
              successParam == '1' ||
              statusParam == 'success' ||
              statusParam == 'paid' ||
              paymentStatusParam == 'success' ||
              paymentStatusParam == 'paid');

      final bool isFailed = isAppDomainRedirect &&
          (successParam == 'false' ||
              successParam == '0' ||
              statusParam == 'failed' ||
              statusParam == 'failure' ||
              paymentStatusParam == 'failed' ||
              paymentStatusParam == 'failure');

      final bool isCancel = isAppDomainRedirect &&
          (successParam == 'cancel' ||
              successParam == 'cancelled' ||
              statusParam == 'cancel' ||
              statusParam == 'cancelled' ||
              paymentStatusParam == 'cancel' ||
              paymentStatusParam == 'cancelled');

      if (isSuccess || isFailed || isCancel) {
        _canRedirect = false;
        Future.delayed(const Duration(seconds: 1), () {
          if (isSuccess) {
            AppFunctions.navigateToAndFinish(
                context,
                BottomNavBarView(
                  pageIndex: isBook ? 3 : 0,
                ));

            AppFunctions.showsToast(AppStrings.paymentSuccess.tr(),
                ColorManager.successGreen, context);
          } else if (isFailed) {
            AppFunctions.navigateToAndFinish(context, const BottomNavBarView());

            AppFunctions.showsToast(
                AppStrings.paymentFailed.tr(), ColorManager.red, context);
          } else if (isCancel) {
            AppFunctions.navigateToAndFinish(context, const BottomNavBarView());

            AppFunctions.showsToast(
                AppStrings.paymentCanceled.tr(), ColorManager.red, context);
          }
          close();
        });
      }
    }
  }
}
