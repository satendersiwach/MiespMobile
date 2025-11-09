class GroupModel {
  final int groupCode;
  final String groupName;

  GroupModel({required this.groupCode, required this.groupName});

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      groupCode: int.tryParse(json['GroupCode'].toString()) ?? 0,
      groupName: json['GroupName']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'GroupCode': groupCode,
      'GroupName': groupName,
    };
  }

  @override
  String toString() => groupName; // helpful for debugging
}
