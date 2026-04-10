import 'dart:convert';

RemoveInventoryModel removeInventoryModelFromJson(String str) =>
    RemoveInventoryModel.fromJson(json.decode(str));

String removeInventoryModelToJson(RemoveInventoryModel data) =>
    json.encode(data.toJson());

class RemoveInventoryModel {
  String? code;

  RemoveInventoryModel({
    this.code,
  });

  factory RemoveInventoryModel.fromJson(Map<String, dynamic> json) =>
      RemoveInventoryModel(
        code: json["Code"],
      );

  Map<String, dynamic> toJson() => {
        "Code": code,
      };
}
