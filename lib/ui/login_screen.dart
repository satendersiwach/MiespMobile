import 'dart:convert';

import 'package:scanner/common/app_assets.dart';
import 'package:scanner/local_storage/local_storage.dart';
import 'package:scanner/theme/custom_colors.dart';
import 'package:scanner/theme/custom_font.dart';
import 'package:scanner/theme/custom_snack_bar.dart';
import 'package:scanner/theme/custom_text_widgets.dart';
import 'package:scanner/theme/get_text_field.dart';
import 'package:scanner/ui/components/check_keyboard_visibility.dart';
import 'package:scanner/ui/dashboard.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  double div = 1.35;

  final key = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  bool obscurePassword = true;
  bool isLoading = false;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();


  @override
  void initState() {
    super.initState();
  }

  String getHashedPassword() {
    var stringInBytes = utf8.encode(password.text);
    String value = sha256.convert(stringInBytes).toString();
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 60,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      // width: MediaQuery.of(context).size.width/3,
                      // height: MediaQuery.of(context).size.height/15,
                      color: appPrimary,
                      child: Image.asset(
                        logoPath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Center(
                  child: Container(
                    color: Colors.white,
                    child: const Text(
                      "Welcome!",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: CustomFont.customFont),
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  color: Colors.white,
                  child: const Text(
                    "Please enter username and password!",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: CustomFont.customFont),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 8),
                child: getTextField(
                  controller: username,
                  labelText: 'Username',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 8),
                child: getTextField(
                    labelText: 'Password',
                    controller: password,
                    maxLines: 1,
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                        icon: Icon(obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off)),
                    obscureText: obscurePassword),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getHeadingText(text: 'Click here to ', fontSize: 15),
                  TextButton(
                    child: getHeadingText(
                        text: 'Reset password',
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                        color: Colors.black),
                    onPressed: () {},
                  ),
                ],
              ),
              if (keyboardIsVisible(
                  context: context, scrollController: _scrollController)) ...[
                const SizedBox(
                  height: 30,
                ),
                _buttonContainer(),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: !keyboardIsVisible(
              context: context, scrollController: _scrollController)
          ? _buttonContainer()
          : null,
    );
  }

  Widget _buttonContainer() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 13,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          borderRadius: BorderRadius.circular(10.0),
          color: appPrimary,
          elevation: 0.0,
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : MaterialButton(
                  onPressed: () {
                    try {
                      _onLogin();
                    } catch (e) {
                      CustomSnackBar.errorSnackBar('Something went wrong');
                    }
                  },
                  minWidth: MediaQuery.of(context).size.width,
                  child: const Text(
                    "Log In",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
        ),
      ),
    );
  }

  _onLogin() {
    LocalStorage.setLoginData();
    Get.to(() => const Dashboard());
  }
}
