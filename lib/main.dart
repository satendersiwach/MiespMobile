import 'package:google_fonts/google_fonts.dart';
import 'package:scanner/local_storage/local_storage.dart';
import 'package:scanner/scanner_app.dart';
import 'package:scanner/theme/custom_theme.dart';
import 'package:scanner/translations/custom_locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;
  await init();

  runApp(GetMaterialApp(
    home: const ScannerApp(),
    debugShowCheckedModeBanner: false,
    theme: AppTheme.createLightTheme(),
    darkTheme: AppTheme.createLightTheme(),
    translations: CustomLocale(),
    supportedLocales: CustomLocale.locales,
    locale: Get.locale,
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate
    ],
  ));
}

Future<void> init() async {
  await CustomLocale.init();
  await LocalStorage.getInstance()?.initLocalStorage();
}
