

class AssignPickListModel {
  int docEntry;
  String user;
  String code;

  AssignPickListModel({
    required this.docEntry,
    required this.user,
    required this.code,
  });

  factory AssignPickListModel.fromJson(Map<String, dynamic> json) =>
      AssignPickListModel(
        docEntry: int.tryParse(json["DocEntry"]?.toString() ?? '') ?? 0,
        user: json["User"]?.toString() ?? '',
        code: json["Code"]?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
    "DocEntry": docEntry,
    "User": user,
    "Code": code,
  };
}