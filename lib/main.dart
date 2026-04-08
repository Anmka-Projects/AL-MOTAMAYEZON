import 'dart:io';

import 'package:elmotamizon/app/imports.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:elmotamizon/app/app.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:screen_protector/screen_protector.dart';

import 'common/resources/language_manager.dart';

final _configurations =
    PurchasesConfiguration('appl_dIZNAvVmlkwrNNJGKvyPeSritBB');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenProtector.preventScreenshotOn();
  await Purchases.configure(_configurations);

  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyDrz0j1_DjDVaLbTCuYHR_NsDz41qD-UjM",
            appId: "1:171033213171:android:c29a1ff5aeb67c49b65f86",
            messagingSenderId: "171033213171",
            projectId: "al-motamizon",
            storageBucket: "al-motamizon.firebasestorage.app",
          ),
        )
      : await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyB6NKqSgugihhrEos2vjyWptnLtT4Bdr2w",
            appId: "1:171033213171:ios:8dcb39ab6d0d2b8cb65f86",
            messagingSenderId: "171033213171",
            projectId: "al-motamizon",
            storageBucket: "al-motamizon.firebasestorage.app",
            iosBundleId: "tech.brmja.elmotamizon",
          ),
        );

  await Future.wait([
    EasyLocalization.ensureInitialized(),
    initAppModule(),
  ]);

  runApp(
    EasyLocalization(
      supportedLocales: const [ENGLISH_LOCALE, ARABIC_LOCALE],
      path: ASSET_PASS_LANGUAGE,
      child: MyApp(),
    ),
  );
}
