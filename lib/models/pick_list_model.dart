import 'dart:convert';

List<PickListModel> pickListModelFromJson(String str) =>
    List<PickListModel>.from(
        json.decode(str).map((x) => PickListModel.fromJson(x)));

String pickListModelToJson(List<PickListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PickListModel {
  int absEntry;


  int docEntry;
  int totalItems;
  int releaseQty;
  String uUser;
  DateTime? uAssignDate;
  String status;
  String code;
  String whseCode;
  String batchNo;
  String description;

  /// for dev purpose only
  bool isSelected;

  PickListModel({
    required this.absEntry,
    required this.releaseQty,
    required this.docEntry,
    required this.totalItems,
    required this.uUser,
    required this.uAssignDate,
    required this.status,
    required this.code,
    required this.description,
    required this.whseCode,
    required this.batchNo,
    this.isSelected=false
  });

  factory PickListModel.fromJson(Map<String, dynamic> json) => PickListModel(

        absEntry: int.tryParse(json["AbsEntry"]?.toString() ?? '') ?? 0,
        docEntry: int.tryParse(json["DocEntry"]?.toString() ?? '') ?? 0,
    releaseQty: int.tryParse(json["ReleaseQty"]?.toString() ?? '') ?? 0,
        totalItems: int.tryParse(json["TotalItems"]?.toString() ?? '') ?? 0,
        uUser: json["U_User"]?.toString() ?? '',
    description: json["Description"]?.toString() ?? '',
    whseCode: json["WhseCode"]?.toString() ?? '',
    batchNo: json["BatchNo"]?.toString() ?? '',
        uAssignDate: DateTime.tryParse(json["U_AssignDate"]?.toString() ?? ''),
        status: json["Status"]?.toString() ?? '',
        code: json["Code"]?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        "AbsEntry": absEntry,
        "ReleaseQty": releaseQty,
        "Description": description,
        "DocEntry": docEntry,
        "TotalItems": totalItems,
        "batchNo": batchNo,
        "WhseCode": whseCode,
        "U_User": uUser,
        "U_AssignDate": uAssignDate?.toIso8601String(),
        "Status": status,
        "Code": code,
      };
}
