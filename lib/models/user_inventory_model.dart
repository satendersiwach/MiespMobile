import 'dart:convert';

UserInventoryModel userInventoryModelFromJson(String str) =>
    UserInventoryModel.fromJson(json.decode(str));

String userInventoryModelToJson(UserInventoryModel data) =>
    json.encode(data.toJson());

class UserInventoryModel {
  String? name;
  int? quantity;
  String? isManEntry;
  String? user;
  DateTime? updateDate;
  String? whsCode;
  String? itemCode;
  String? itemName;
  String? whsName;
  String? code;
  String? remark;
  String? isLocked;

  UserInventoryModel({
    this.name,
    this.quantity,
    this.isManEntry,
    this.user,
    this.updateDate,
    this.whsCode,
    this.itemCode,
    this.itemName,
    this.whsName,
    this.code,
    this.remark,
    this.isLocked,
  });

  factory UserInventoryModel.fromJson(Map<String, dynamic> json) =>
      UserInventoryModel(
        name: json["Name"],
        quantity: json["Quantity"],
        isManEntry: json["IsManEntry"],
        user: json["User"],
        updateDate: json["UpdateDate"] == null
            ? null
            : DateTime.parse(json["UpdateDate"]),
        whsCode: json["WhsCode"],
        itemCode: json["ItemCode"],
        itemName: json["ItemName"],
        whsName: json["WhsName"],
        code: json["Code"],
        remark: json["Remark"],
        isLocked: json["IsLocked"],
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "Quantity": quantity,
        "IsManEntry": isManEntry,
        "User": user,
        "UpdateDate": updateDate?.toIso8601String(),
        "WhsCode": whsCode,
        "ItemCode": itemCode,
        "ItemName": itemName,
        "WhsName": whsName,
        "Code": code,
        "Remark": remark,
        "IsLocked": isLocked,
      };
}
