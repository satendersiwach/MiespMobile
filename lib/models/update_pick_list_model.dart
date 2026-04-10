class UpdatePickListModel {
  int pickListId;
  int soId;
  String user;
  String itemCode;
  String batchNumber;
  int pickQty;

  UpdatePickListModel({
    required this.pickListId,
    required this.soId,
    required this.user,
    required this.itemCode,
    required this.batchNumber,
    required this.pickQty,
  });

  factory UpdatePickListModel.fromJson(Map<String, dynamic> json) =>
      UpdatePickListModel(
        pickListId: int.tryParse(json["PickListId"]?.toString() ?? '') ?? 0,
        soId: int.tryParse(json["SOId"]?.toString() ?? '') ?? 0,
        user: json["User"]?.toString() ?? '',
        itemCode: json["ItemCode"]?.toString() ?? '',
        batchNumber: json["BatchNumber"]?.toString() ?? '',
        pickQty: int.tryParse(json["PickQty"]?.toString() ?? '') ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "PickListId": pickListId,
        "SOId": soId,
        "User": user,
        "ItemCode": itemCode,
        "BatchNumber": batchNumber,
        "PickQty": pickQty,
      };
}
