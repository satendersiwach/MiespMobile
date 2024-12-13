import 'dart:convert';

List<PickListModel> pickListModelFromJson(String str) =>
    List<PickListModel>.from(
        json.decode(str).map((x) => PickListModel.fromJson(x)));

String pickListModelToJson(List<PickListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PickListModel {
  int pickListId;
  int absEntry;
  int docEntry;
  int soId;
  int totalItems;
  int releaseQty;
  String user;
  String assignDate;
  String status;
  String code;
  String whseCode;
  String batchNo;
  String description;

  /// for dev purpose only
  bool isSelected;

  PickListModel({
    required this.pickListId,
    required this.absEntry,
    required this.docEntry,
    required this.releaseQty,
    required this.soId,
    required this.totalItems,
    required this.user,
    required this.assignDate,
    required this.status,
    required this.code,
    required this.description,
    required this.whseCode,
    required this.batchNo,
    this.isSelected=false
  });

  factory PickListModel.fromJson(Map<String, dynamic> json) => PickListModel(
    docEntry: int.tryParse(json["DocEntry"]?.toString() ?? '') ?? 0,
    absEntry: int.tryParse(json["AbsEntry"]?.toString() ?? '') ?? 0,
        pickListId: int.tryParse(json["PickListId"]?.toString() ?? '') ?? 0,
        soId: int.tryParse(json["SOId"]?.toString() ?? '') ?? 0,
    releaseQty: int.tryParse(json["ReleaseQty"]?.toString() ?? '') ?? 0,
        totalItems: int.tryParse(json["TotalItems"]?.toString() ?? '') ?? 0,
        user: json["User"]?.toString() ?? '',
    description: json["Description"]?.toString() ?? '',
    whseCode: json["WhseCode"]?.toString() ?? '',
    batchNo: json["BatchNo"]?.toString() ?? '',
        assignDate: json["AssignDate"]?.toString() ?? '',
        status: json["Status"]?.toString() ?? '',
        code: json["Code"]?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        "PickListId": pickListId,
        "AbsEntry": absEntry,
        "DocEntry": docEntry,
        "ReleaseQty": releaseQty,
        "Description": description,
        "SOId": soId,
        "TotalItems": totalItems,
        "batchNo": batchNo,
        "WhseCode": whseCode,
        "User": user,
        "AssignDate": assignDate,
        "Status": status,
        "Code": code,
      };
}
