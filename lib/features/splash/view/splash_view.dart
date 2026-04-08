import 'dart:async';
import 'dart:io';

import 'package:elmotamizon/app/app_prefs.dart';
import 'package:elmotamizon/app/imports.dart';
import 'package:elmotamizon/app/app_functions.dart';
import 'package:elmotamizon/common/resources/color_manager.dart';
import 'package:elmotamizon/common/resources/language_manager.dart';
import 'package:elmotamizon/constants/assets.dart';
import 'package:elmotamizon/features/bottom_nav_bar/view/bottom_nav_bar_view.dart';
import 'package:elmotamizon/features/on_boarding/view/on_boarding_view.dart';
import 'package:elmotamizon/local_notification_and_token.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_prevent_screenshot/disablescreenshot.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:screen_capture_event/screen_capture_event.dart';
import 'package:screen_protector/screen_protector.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final ScreenCaptureEvent screenListener = ScreenCaptureEvent();
  late Timer _timer;

  _checkScreenRecord() async {
    screenListener.addScreenRecordListener((recorded) {
      if (recorded) {
        exit(0);
      }
    });
    screenListener.watch();
  }

  _isRecordingCheck() async {
    bool isRecording = await ScreenProtector.isRecording();
    if (isRecording) {
      exit(0);
    }
  }

  _startDelay() {
    _timer = Timer(const Duration(seconds: 3), _goNext);
  }

  _goNext() async {
    if (_appPreferences.isOnBoardingScreenViewed()) {
      AppFunctions.navigateToAndFinish(context, const BottomNavBarView());
    } else {
      AppFunctions.navigateToAndFinish(context, const OnBoardingView());
    }
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) async {
    debugPrint('message ==================> ${message.data.toString()}');
  }

  @override
  void didChangeDependencies() {
    _appPreferences.getLocale().then((locale) {
      print("locale ==========> $locale");
      if(mounted) context.setLocale(locale);
    });
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    language = instance<AppPreferences>().getAppLanguage();
    globalMethods.registerNotification(context);
    setupInteractedMessage();
    _startDelay();
    // FlutterPreventScreenshot.instance.screenshotOff();
    _checkScreenRecord();
    _isRecordingCheck();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      try {
        FirebaseMessaging.instance.subscribeToTopic('elmotamizon');
      } catch (e) {
        AppFunctions.showsToast(e.toString(), ColorManager.red, context);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Center(
          child: Image.asset(
            Assets.assetsImagesLogo,
            height: MediaQuery.sizeOf(context).height * .5,
          ),
        ),
      ),
    );
  }
}
