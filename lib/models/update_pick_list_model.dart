// import 'dart:convert';
//
// List<UpdatePickListModel> pickListModelFromJson(String str) =>
//     List<UpdatePickListModel>.from(
//         json.decode(str).map((x) => UpdatePickListModel.fromJson(x)));
//
// String pickListModelToJson(List<UpdatePickListModel> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UpdatePickListModel {
  int pickListId;
  int soId;
  String user;

  String mode;

  UpdatePickListModel({
    required this.pickListId,
    required this.soId,
    required this.user,
    required this.mode,
  });

  factory UpdatePickListModel.fromJson(Map<String, dynamic> json) =>
      UpdatePickListModel(
        pickListId: int.tryParse(json["PickListId"]?.toString() ?? '') ?? 0,
        soId: int.tryParse(json["SOId"]?.toString() ?? '') ?? 0,
        user: json["User"]?.toString() ?? '',
        mode: json["Mode"]?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        "PickListId": pickListId,
        "SOId": soId,
        "User": user,
        "Mode": mode,
      };
}
