import 'dart:convert';

List<PickListModel> pickListModelFromJson(String str) =>
    List<PickListModel>.from(
        json.decode(str).map((x) => PickListModel.fromJson(x)));

String pickListModelToJson(List<PickListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PickListModel {
  int pickListId;
  int soId;
  int totalItems;
  String user;
  String assignDate;
  String status;
  String code;

  PickListModel({
    required this.pickListId,
    required this.soId,
    required this.totalItems,
    required this.user,
    required this.assignDate,
    required this.status,
    required this.code,
  });

  factory PickListModel.fromJson(Map<String, dynamic> json) => PickListModel(
        pickListId: int.tryParse(json["PickListId"]?.toString() ?? '') ?? 0,
        soId: int.tryParse(json["SOId"]?.toString() ?? '') ?? 0,
        totalItems: int.tryParse(json["TotalItems"]?.toString() ?? '') ?? 0,
        user: json["User"]?.toString() ?? '',
        assignDate: json["AssignDate"]?.toString() ?? '',
        status: json["Status"]?.toString() ?? '',
        code: json["Code"]?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        "PickListId": pickListId,
        "SOId": soId,
        "TotalItems": totalItems,
        "User": user,
        "AssignDate": assignDate,
        "Status": status,
        "Code": code,
      };
}
