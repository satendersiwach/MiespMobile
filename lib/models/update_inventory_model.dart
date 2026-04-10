import 'dart:convert';

UpdateInventoryModel updateInventoryModelFromJson(String str) =>
    UpdateInventoryModel.fromJson(json.decode(str));

String updateInventoryModelToJson(UpdateInventoryModel data) =>
    json.encode(data.toJson());

class UpdateInventoryModel {
  String? code;
  String? remark;

  UpdateInventoryModel({
    this.code,
    this.remark,
  });

  factory UpdateInventoryModel.fromJson(Map<String, dynamic> json) =>
      UpdateInventoryModel(
        code: json["Code"],
        remark: json["Remark"],
      );

  Map<String, dynamic> toJson() => {
        "Code": code,
        "Remark": remark,
      };
}
