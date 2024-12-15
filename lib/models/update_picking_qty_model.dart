import 'dart:convert';

UpdatePickingModel updatePickingModelFromJson(String str) =>
    UpdatePickingModel.fromJson(json.decode(str));

String updatePickingModelToJson(UpdatePickingModel data) =>
    json.encode(data.toJson());

class UpdatePickingModel {
  int pickListId;
  int soId;
  String itemCode;
  String user;
  int pickQty;
  String batchNumber;

  UpdatePickingModel({
    required this.pickListId,
    required this.soId,
    required this.itemCode,
    required this.user,
    required this.pickQty,
    required this.batchNumber,
  });

  factory UpdatePickingModel.fromJson(Map<String, dynamic> json) =>
      UpdatePickingModel(
        pickListId: int.tryParse(json["PickListId"]?.toString() ?? '') ?? 0,
        soId: int.tryParse(json["SOId"]?.toString() ?? '') ?? 0,
        itemCode: json["ItemCode"]?.toString() ?? '',
        user: json["User"]?.toString() ?? '',
        pickQty: int.tryParse(json["PickQty"]?.toString() ?? '') ?? 0,
        batchNumber: json["BatchNumber"]?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        "PickListId": pickListId,
        "SOId": soId,
        "ItemCode": itemCode,
        "User": user,
        "PickQty": pickQty,
        "BatchNumber": batchNumber,
      };
}
