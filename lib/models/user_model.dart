import 'dart:convert';

import 'package:scanner/common/keys.dart';
import 'package:scanner/local_storage/local_storage.dart';

UserModel customerModelFromJson(String str) =>
    UserModel.fromJson(json.decode(str));

String customerModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  int? userId;
  String? userCode;
  bool isSupervisor;
  String? username;
  String? name;
  String? email;
  int? roleId;
  String? token;

  UserModel({
    this.userId,
    this.userCode,
    this.isSupervisor = false,
    this.username,
    this.email,
    this.name,
    this.roleId,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userId: int.tryParse(json["userId"].toString()),
        userCode: json["Code"],
        username: json["UserName"],
        name: json["Name"],
        isSupervisor: json["IsSupervisor"],
        email: json["email"] ?? '',
        roleId: int.tryParse(json["roleId"].toString()),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "Code": userCode,
        "Name": name,
        "UserName": username,
        "IsSupervisor": isSupervisor,
        "email": email,
        "roleId": roleId,
        "token": token,
      };

  static setLoginCustomer({required UserModel customerModel}) {
    LocalStorage.getInstance()
        ?.localStorage
        ?.setString(keyObjUser, jsonEncode(customerModel.toJson()));
    LocalStorage.getInstance()
        ?.localStorage
        ?.setString(keyLoginTime, DateTime.now().toIso8601String());
  }

  static UserModel getLoginCustomer() {
    String customer =
        LocalStorage.getInstance()?.localStorage?.getString(keyObjUser) ?? '';
    if (customer == '') {
      return UserModel();
    }
    return UserModel.fromJson(jsonDecode(customer));
  }

  static bool isUser() {
    String customer =
        LocalStorage.getInstance()?.localStorage?.getString(keyObjUser) ?? '';
    if (customer.isEmpty) {
      return true;
    }
    UserModel userModel = UserModel.fromJson(jsonDecode(customer));
    return !userModel.isSupervisor;
  }
}
