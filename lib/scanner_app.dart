import 'dart:async';

import 'package:scanner/common/keys.dart';
import 'package:scanner/local_storage/local_storage.dart';
import 'package:scanner/theme/custom_theme.dart';
import 'package:scanner/theme/elements_screen.dart';
import 'package:scanner/translations/custom_locale.dart';
import 'package:scanner/ui/dashboard.dart';
import 'package:scanner/ui/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    //todo:
    // FlutterNativeSplash.remove();
    if (!mounted) {
      return;
    }
    if (customer == null || customer == '') {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const LoginPage()));
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const Dashboard()));
      // CustomerModel customerModel =
      //     CustomerModel.fromJson(jsonDecode(customer));
      // if (customerModel.email.isNotEmpty) {
      //   ServiceManager.loginViaEmail(
      //       email: customerModel.email,
      //       onError: (String error) {
      //         errorSnackBar(error);
      //         Timer(const Duration(seconds: 1), () {
      //           logout();
      //         });
      //       },
      //       onSuccess: () {
      //         Navigator.of(context).push(
      //             MaterialPageRoute(builder: (context) => const Dashboard()));
      //       });
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return screenWithoutAppBar(body: const Center(child: FlutterLogo()));
  }
}
