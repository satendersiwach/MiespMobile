import 'dart:convert';

UpdateInventoryModel updateInventoryModelFromJson(String str) =>
    UpdateInventoryModel.fromJson(json.decode(str));

String updateInventoryModelToJson(UpdateInventoryModel data) =>
    json.encode(data.toJson());

class UpdateInventoryModel {
  String? batchNumber;
  String? whsCode;
  String? itemCode;
  int? quantity;
  String? user;
  String? isManEntry;
  String? remark;
  String? mode;

  UpdateInventoryModel({
    this.batchNumber,
    this.whsCode,
    this.itemCode,
    this.quantity,
    this.user,
    this.isManEntry,
    this.remark,
    this.mode,
  });

  factory UpdateInventoryModel.fromJson(Map<String, dynamic> json) =>
      UpdateInventoryModel(
        batchNumber: json["BatchNumber"],
        whsCode: json["WhsCode"],
        itemCode: json["ItemCode"],
        quantity: json["Quantity"],
        user: json["User"],
        isManEntry: json["IsManEntry"],
        remark: json["Remark"],
        mode: json["Mode"],
      );

  Map<String, dynamic> toJson() => {
        "BatchNumber": batchNumber,
        "WhsCode": whsCode,
        "ItemCode": itemCode,
        "Quantity": quantity,
        "User": user,
        "IsManEntry": isManEntry,
        "Remark": remark,
        "Mode": mode,
      };
}
