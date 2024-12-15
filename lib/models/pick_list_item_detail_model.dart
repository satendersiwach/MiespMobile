// To parse this JSON data, do
//
//     final pickListItemDetailModel = pickListItemDetailModelFromJson(jsonString);

import 'dart:convert';

List<PickListItemDetailModel> pickListItemDetailModelFromJson(String str) =>
    List<PickListItemDetailModel>.from(
        json.decode(str).map((x) => PickListItemDetailModel.fromJson(x)));

String pickListItemDetailModelToJson(List<PickListItemDetailModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PickListItemDetailModel {
  int quantity;
  String itemCode;
  String itemName;
  String distNumber;
  int docEntry;
  int absEntry;
  int relQtty;
  String assignedUser;
  String whsCode;
  String picked;

  PickListItemDetailModel({
    required this.quantity,
    required this.itemCode,
    required this.itemName,
    required this.distNumber,
    required this.docEntry,
    required this.absEntry,
    required this.relQtty,
    required this.assignedUser,
    required this.whsCode,
    required this.picked,
  });

  factory PickListItemDetailModel.fromJson(Map<String, dynamic> json) =>
      PickListItemDetailModel(
        quantity: int.tryParse(json["Quantity"]?.toString() ?? '') ?? 0,
        itemCode: json["ItemCode"]?.toString() ?? '',
        itemName: json["ItemName"]?.toString() ?? '',
        distNumber: json["DistNumber"]?.toString() ?? '',
        docEntry: int.tryParse(json["DocEntry"]?.toString() ?? '') ?? 0,
        absEntry: int.tryParse(json["AbsEntry"]?.toString() ?? '') ?? 0,
        relQtty: int.tryParse(json["RelQtty"]?.toString() ?? '') ?? 0,
        assignedUser: json["AssignedUser"]?.toString() ?? '',
        whsCode: json["WhsCode"]?.toString() ?? '',
        picked: json["Picked"]?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        "Quantity": quantity,
        "ItemCode": itemCode,
        "ItemName": itemName,
        "DistNumber": distNumber,
        "DocEntry": docEntry,
        "AbsEntry": absEntry,
        "RelQtty": relQtty,
        "AssignedUser": assignedUser,
        "WhsCode": whsCode,
        "Picked": picked,
      };
}
