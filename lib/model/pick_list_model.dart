List<PickListModel> pickLists = [
  PickListModel(
    totalItems: 1,
    id: 1,
    itemCode: "ITEM001",
    description: "Item 1 Description",
    soId: 1001,
    whseCode: "WH001",
    batchNumber: "BATCH001",
    releaseQty: 10.5,
    pickedStatus: "Picked",
  ),
  PickListModel(
    totalItems: 1,
    id: 2,
    itemCode: "ITEM002",
    description: "Item 2 Description",
    soId: 1002,
    whseCode: "WH002",
    batchNumber: "BATCH002",
    releaseQty: 8.0,
    pickedStatus: "Not Picked",
  ),
  PickListModel(
    totalItems: 1,
    id: 3,
    itemCode: "ITEM003",
    description: "Item 3 Description",
    soId: 1003,
    whseCode: "WH001",
    batchNumber: "BATCH003",
    releaseQty: 15.0,
    pickedStatus: "Picked",
  ),
  PickListModel(
    totalItems: 1,
    id: 4,
    itemCode: "ITEM004",
    description: "Item 4 Description",
    soId: 1004,
    whseCode: "WH003",
    batchNumber: "BATCH004",
    releaseQty: 6.5,
    pickedStatus: "Not Picked",
  ),
  PickListModel(
    totalItems: 1,
    id: 5,
    itemCode: "ITEM005",
    description: "Item 5 Description",
    soId: 1005,
    whseCode: "WH002",
    batchNumber: "BATCH005",
    releaseQty: 12.0,
    pickedStatus: "Picked",
  ),
  PickListModel(
    totalItems: 1,
    id: 6,
    itemCode: "ITEM006",
    description: "Item 6 Description",
    soId: 1006,
    whseCode: "WH001",
    batchNumber: "BATCH006",
    releaseQty: 7.0,
    pickedStatus: "Not Picked",
  ),
  PickListModel(
    totalItems: 1,
    id: 7,
    itemCode: "ITEM007",
    description: "Item 7 Description",
    soId: 1007,
    whseCode: "WH003",
    batchNumber: "BATCH007",
    releaseQty: 20.0,
    pickedStatus: "Picked",
  ),
  PickListModel(
    totalItems: 1,
    id: 8,
    itemCode: "ITEM008",
    description: "Item 8 Description",
    soId: 1008,
    whseCode: "WH002",
    batchNumber: "BATCH008",
    releaseQty: 5.5,
    pickedStatus: "Not Picked",
  ),
  PickListModel(
    totalItems: 1,
    id: 9,
    itemCode: "ITEM009",
    description: "Item 9 Description",
    soId: 1009,
    whseCode: "WH001",
    batchNumber: "BATCH009",
    releaseQty: 18.0,
    pickedStatus: "Picked",
  ),
  PickListModel(
    totalItems: 1,
    id: 10,
    itemCode: "ITEM010",
    description: "Item 10 Description",
    soId: 1010,
    whseCode: "WH003",
    batchNumber: "BATCH010",
    releaseQty: 9.0,
    pickedStatus: "Not Picked",
  ),
];

class PickListModel {
  int id;
  int totalItems;
  int? soId;
  String itemCode;
  String? description;
  String? assignedTo;
  String? whseCode;
  String? batchNumber;
  String? pickedStatus;
  double? releaseQty;
  DateTime? assignedDate;
  bool checked;

  PickListModel({
    required this.id,
    required this.totalItems,
    required this.itemCode,
    this.description,
    this.assignedTo,
    this.checked=false,
    this.soId,
    this.whseCode,
    this.batchNumber,
    this.releaseQty,
    this.pickedStatus,
    this.assignedDate,
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
        totalItems: int.tryParse(json['total_items']?.toString() ?? '0') ?? 0,
        assignedDate: DateTime.tryParse(json['assigned_date'].toString()),
        soId: int.tryParse(json['so_id']?.toString() ?? '0') ?? 0,
        releaseQty:
            double.tryParse(json['release_qty']?.toString() ?? '0') ?? 0,
        itemCode: json['item_code'] ?? '',
        assignedTo: json['assigned_to'] ?? '',
        description: json['description'],
        pickedStatus: json['picked_status'],
        whseCode: json['whse_code'],
        batchNumber: json['batch_number'],
      );

  Map<String, Object?> toJson() => {
        "id": id,
        "item_code": itemCode,
        "total_items": totalItems,
        "assigned_to": assignedTo,
        "description": description,
        "so_id": soId,
        "whse_code": whseCode,
        "batch_number": batchNumber,
        "release_qty": releaseQty,
        "picked_status": pickedStatus,
        "assigned_date": assignedDate?.toIso8601String(),
      };
}
