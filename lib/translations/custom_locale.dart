import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:scanner/common/keys.dart';
import 'package:scanner/local_storage/local_storage.dart';
import 'package:scanner/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CustomLocale extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          "app.name": "App Name",
        },
        'hi_IN': {
          "app.name": "App Name Hindi",
        }
      };
  static List<Locale> locales = [
    const Locale("hi", "IN"),
  ];
  static Locale defaultLocale = const Locale("en", "US");
  static Locale currentLocale = defaultLocale;
  static Map<String, dynamic> localizations = {};

  static Future<void> init() async {
    String platformLocale = Platform.localeName;

    String? appLocaleCode =
        LocalStorage.getInstance()?.localStorage?.getString(keyAppLocaleCode);

    // set appLocaleCode = platformLocale code when appLocaleCode is null
    appLocaleCode ??= platformLocale;
    log("defaultLocaleCode = $appLocaleCode");
    Locale locale = CustomLocale.toLocale(appLocaleCode); //Added

    Get.updateLocale(locale);
    AuthService.updateCurrentLangCode(appLocaleCode);

    localizations =
        await loadLocalization("assets/locale/${fromLocale(locale)}.json");
  }

  static String fromLocale(Locale locale) {
    return locale.languageCode +
        (locale.countryCode != null && locale.countryCode!.isNotEmpty
            ? "_${locale.countryCode!}"
            : "");
  }

  static Locale toLocale(String code) {
    for (Locale locale in locales) {
      if (code == fromLocale(locale)) return locale;
    }
    return defaultLocale;
  }

  static String text(String key) {
    return key.tr;
  }

  static Future<Map<String, dynamic>> loadLocalization(String path) async {
    try {
      String jsonString = await rootBundle.loadString(path);
      return json.decode(jsonString);
    } on Exception {
      return <String, dynamic>{};
    }
  }
}
