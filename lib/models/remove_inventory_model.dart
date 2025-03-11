import 'dart:convert';

RemoveInventoryModel removeInventoryModelFromJson(String str) =>
    RemoveInventoryModel.fromJson(json.decode(str));

String removeInventoryModelToJson(RemoveInventoryModel data) =>
    json.encode(data.toJson());

class RemoveInventoryModel {
  String? batchNumber;
  String? whsCode;
  String? itemCode;

  RemoveInventoryModel({
    this.batchNumber,
    this.whsCode,
    this.itemCode,
  });

  factory RemoveInventoryModel.fromJson(Map<String, dynamic> json) =>
      RemoveInventoryModel(
        batchNumber: json["BatchNumber"],
        whsCode: json["WhsCode"],
        itemCode: json["ItemCode"],
      );

  Map<String, dynamic> toJson() => {
        "BatchNumber": batchNumber,
        "WhsCode": whsCode,
        "ItemCode": itemCode,
      };
}
