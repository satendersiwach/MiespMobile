import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner/common/keys.dart';
import 'package:scanner/local_storage/local_storage.dart';
import 'package:scanner/models/customer_model.dart';
import 'package:scanner/services/scanner_event_service.dart';
import 'package:scanner/theme/custom_theme.dart';
import 'package:scanner/theme/elements_screen.dart';
import 'package:scanner/translations/custom_locale.dart';
import 'package:scanner/ui/dashboard/super_admin_dashboard.dart';
import 'package:scanner/ui/dashboard/user_dashboard.dart';
import 'package:scanner/ui/login_screen.dart';

class ScannerApp extends StatefulWidget {
  static _ScannerAppState? _state;

  const ScannerApp({Key? key}) : super(key: key);

  static void buildTheme(BuildContext context, bool? flagDarkTheme) async {
    _state?.buildTheme(flagDarkTheme);
  }

  static void setLocale(Locale locale) async {
    _state?.setLocale(locale);
  }

  @override
  State<ScannerApp> createState() => _ScannerAppState();
}

class _ScannerAppState extends State<ScannerApp> {
  @override
  void initState() {
    super.initState();

    ScannerEventService().init();
    initLocalStorage();
  }

  buildTheme(bool? flagDarkTheme) {
    setState(() {
      AppTheme.load(flagDarkTheme: flagDarkTheme ?? false);
    });
  }

  setLocale(Locale locale) {
    Get.locale = locale;
  }

  Future<void> initLocalStorage() async {
    await LocalStorage.getInstance()?.initLocalStorage();
    _initLocale();
  }

  Future<void> _initLocale() async {
    await CustomLocale.init();
    navigate();
  }

  navigate() async {
    String? customer = LocalStorage.getString(key: keyObjUser);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) {
      return;
    }
    if (customer == null || customer == '') {
      Get.offAll(() => const LoginPage());
    } else {
      if (UserModel.isUser()) {
        Get.offAll(() => const UserDashboard());
      } else {
        Get.offAll(() => const SuperAdminDashboard());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return screenWithoutAppBar(
        body: Center(
            child: Image.asset(
      'assets/icons/logo.png',
              height: Get.height/5,
              width: Get.height/5,
    )));
  }
}
