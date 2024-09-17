class PickListModel {
  int id;
  int? soId;
  String itemCode;
  String? description;
  String? whseCode;
  String? batchNumber;
  String? pickedStatus;
  double? releaseQty;

  PickListModel({
    required this.id,
    required this.itemCode,
    this.description,
    this.soId,
    this.whseCode,
    this.batchNumber,
    this.releaseQty,
    this.pickedStatus,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PickListModel &&
              runtimeType == other.runtimeType &&
              itemCode == other.itemCode &&
              id == other.id;

  @override
  int get hashCode => itemCode.hashCode ^ id.hashCode;

  factory PickListModel.fromJson(Map json) => PickListModel(
        id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
        soId: int.tryParse(json['so_id']?.toString() ?? '0') ?? 0,
        releaseQty:
            double.tryParse(json['release_qty']?.toString() ?? '0') ?? 0,
        itemCode: json['item_code'] ?? '',
        description: json['description'],
        pickedStatus: json['picked_status'],
        whseCode: json['whse_code'],
        batchNumber: json['batch_number'],
      );

  Map<String, Object?> toJson() => {
        "id": id,
        "item_code": itemCode,
        "description": description,
        "so_id": soId,
        "whse_code": whseCode,
        "batch_number": batchNumber,
        "release_qty": releaseQty,
        "picked_status": pickedStatus,
      };
}
