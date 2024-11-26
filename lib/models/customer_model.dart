import 'dart:convert';

import 'package:scanner/common/keys.dart';
import 'package:scanner/local_storage/local_storage.dart';

UserModel customerModelFromJson(String str) =>
    UserModel.fromJson(json.decode(str));

String customerModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  int? userId;
  String? userCode;
  String? isSupervisor;
  String? username;
  String? name;
  String? email;
  int? roleId;
  String? token;

  UserModel({
    this.userId,
    this.userCode,
    this.isSupervisor,
    this.username,
    this.email,
    this.name,
    this.roleId,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userId: int.tryParse(json["userId"].toString()),
        userCode: json["userCode"],
        username: json["Username"],
        name: json["Name"],
        isSupervisor: json["IsSupervisor"],
        email: json["email"] ?? '',
        roleId: int.tryParse(json["roleId"].toString()),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "userCode": userCode,
        "Name": name,
        "Username": username,
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
    return UserModel.fromJson(jsonDecode(customer));
  }
}
