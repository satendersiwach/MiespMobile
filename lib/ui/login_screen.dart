import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner/local_storage/local_storage.dart';
import 'package:scanner/theme/custom_colors.dart';
import 'package:scanner/theme/custom_snack_bar.dart';
import 'package:scanner/theme/get_text_field.dart';
import 'package:scanner/ui/components/check_keyboard_visibility.dart';
import 'package:scanner/ui/dashboard.dart';

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
                      child: const FlutterLogo(
                        size: 100,
                      ),
                      // child: Image.asset(
                      //   logoPath,
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 8),
                child: getTextField(
                  controller: username,
                  labelText: 'Username',
                  labelFontSize: 18,
                  labelColor: Colors.grey,
                  borderRadius: const BorderRadius.all(Radius.zero),
                  boxShadow: [],
                  disabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 8),
                child: getTextField(
                    labelText: 'Password',
                    controller: password,
                    labelFontSize: 18,
                    labelColor: Colors.grey,
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
                    borderRadius: const BorderRadius.all(Radius.zero),
                    boxShadow: [],
                    disabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                    obscureText: obscurePassword),
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
