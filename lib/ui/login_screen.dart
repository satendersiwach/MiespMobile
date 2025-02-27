import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scanner/common/app_assets.dart';
import 'package:scanner/models/customer_model.dart';
import 'package:scanner/services/service_manager.dart';
import 'package:scanner/theme/custom_colors.dart';
import 'package:scanner/theme/custom_snack_bar.dart';
import 'package:scanner/theme/custom_text_widgets.dart';
import 'package:scanner/theme/get_text_field.dart';
import 'package:scanner/ui/components/check_keyboard_visibility.dart';
import 'package:scanner/ui/components/element_button.dart';
import 'package:scanner/ui/dashboard/super_admin_dashboard.dart';
import 'package:scanner/ui/dashboard/user_dashboard.dart';

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
  TextEditingController username = TextEditingController(text: 'supervisor');
  TextEditingController password = TextEditingController(text: '12345');

  // TextEditingController username = TextEditingController(text: 'HHT1');
  // TextEditingController password = TextEditingController(text: '12345');
  //
  //
  // TextEditingController username = TextEditingController();
  // TextEditingController password = TextEditingController();

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
      backgroundColor: appPrimary,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                        'assets/icons/no-bg-logo.png',
                        height: Get.height / 5,
                        fit: BoxFit.cover,
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
                height: 40,
              ),
              _welcomeContainer(),
              const SizedBox(
                height: 30,
              ),
              _loginTextContainer(),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 8),
                child: getTextField(
                  controller: username,
                  labelText: 'Username',
                  prefixIcon: Icon(
                    MdiIcons.accountOutline,
                    color: Colors.white,
                    size: 30,
                  ),
                  fillColor: appPrimary,
                  cursorColor: Colors.white,
                  textColor: Colors.white,
                  labelFontSize: 18,
                  contentPadding: const EdgeInsets.only(bottom: 12.0, left: 12),
                  labelColor: Colors.white,
                  height: null,
                  borderRadius: const BorderRadius.all(Radius.zero),
                  boxShadow: [],
                  disabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 8),
                child: getTextField(
                    labelText: 'Password',
                    controller: password,
                    fillColor: appPrimary,
                    cursorColor: Colors.white,
                    textColor: Colors.white,
                    height: null,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 16),
                      child: SvgPicture.asset(
                        lockIcon,
                        color: Colors.white,
                      ),
                    ),
                    labelFontSize: 18,
                    labelColor: Colors.white,
                    maxLines: 1,
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        )),
                    borderRadius: const BorderRadius.all(Radius.zero),
                    boxShadow: [],
                    disabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1),
                    ),
                    obscureText: obscurePassword),
              ),
              const SizedBox(
                height: 30,
              ),
              _buttonContainer(),
              if (keyboardIsVisible(
                  context: context, scrollController: _scrollController)) ...[
                SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom,
                ),
              ],
            ],
          ),
        ),
      ),
      // bottomNavigationBar: !keyboardIsVisible(
      //         context: context, scrollController: _scrollController)
      //     ? _buttonContainer()
      //     : null,
    );
  }

  Widget _welcomeContainer() {
    return Align(
        alignment: Alignment.center,
        child:
            getHeadingText(text: 'Welcome', color: Colors.white, fontSize: 30));
  }

  Widget _loginTextContainer() {
    return Align(
        alignment: Alignment.center,
        child: getSubHeadingText(
          text: 'LOGIN WITH USERNAME AND PASSWORD',
          color: Colors.white,
        ));
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
                : loadingButton(
                    isLoading: false,
                    btnText: 'Log In',
                    onPress: () {
                      try {
                        _onLogin();
                      } catch (e) {
                        CustomSnackBar.errorSnackBar('Something went wrong');
                      }
                    },
                    backColor: Colors.white,
                    textColor: appPrimary)),
      ),
    );
  }

  void onSuccess(UserModel customerModel) async {
    CustomSnackBar.successSnackBar('Login successful');
    UserModel.setLoginCustomer(customerModel: customerModel);
    setState(() {
      isLoading = false;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    if (UserModel.isUser()) {
      Get.offAll(() => const UserDashboard());
    } else {
      Get.offAll(() => const SuperAdminDashboard());
    }
  }

  onError(Map responseMap) {
    CustomSnackBar.errorSnackBar(
        responseMap['ValidationErrors'][0]['ErrorMessage']);
    setState(() {
      isLoading = false;
    });
  }

  _onLogin() async {
    if (await ServiceManager.isInternetAvailable()) {
      setState(() {
        isLoading = true;
      });
      try {
        ServiceManager.login(
            Username: username.text,
            Password: password.text,
            onSuccess: onSuccess,
            onError: onError);
      } catch (e) {
        CustomSnackBar.errorSnackBar(e.toString());
      }
    }
  }

// _onLogin() {
//   LocalStorage.setLoginData();
//   Get.to(() => const UserSelection());
// }
}
