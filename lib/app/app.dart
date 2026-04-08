import 'package:elmotamizon/common/resources/theme_manager.dart';
import 'package:elmotamizon/features/splash/view/splash_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:elmotamizon/app/app_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'imports.dart';

class MyApp extends StatefulWidget {
  const MyApp._internal();

  static const _instance = MyApp._internal();

  factory MyApp() => _instance;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(MediaQuery.sizeOf(context).width, MediaQuery.sizeOf(context).height),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            scaffoldMessengerKey: scaffoldMessengerKey,
            home: const SplashView(),
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            theme: ThemeManager.getTheme(),
          );
        });
  }
}

final navigatorKey = GlobalKey<NavigatorState>(debugLabel: 'navigatorKey ${DateTime.now().millisecondsSinceEpoch}');
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
