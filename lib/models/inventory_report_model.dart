import 'dart:convert';

InventoryReportModel inventoryReportModelFromJson(String str) =>
    InventoryReportModel.fromJson(json.decode(str));

String inventoryReportModelToJson(InventoryReportModel data) =>
    json.encode(data.toJson());

class InventoryReportModel {
  int? pageNum;
  int? pageSize;
  String? searchTerm;
  List<Datum>? data;

  InventoryReportModel({
    this.pageNum,
    this.pageSize,
    this.searchTerm,
    this.data,
  });

  factory InventoryReportModel.fromJson(Map<String, dynamic> json) =>
      InventoryReportModel(
        pageNum: int.tryParse(json["PageNum"]?.toString() ?? '0'),
        pageSize: int.tryParse(json["PageSize"]?.toString() ?? '0'),
        searchTerm: json["SearchTerm"]?.toString(),
        data: json["Data"] == null
            ? []
            : List<Datum>.from(json["Data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "PageNum": pageNum,
        "PageSize": pageSize,
        "SearchTerm": searchTerm,
        "Data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  String? itemCode;
  String? batchNum;
  int? quantity;
  int? sapQuantity;

  Datum({
    this.itemCode,
    this.batchNum,
    this.quantity,
    this.sapQuantity,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        itemCode: json["ItemCode"],
        batchNum: json["BatchNum"],
        quantity: int.tryParse(json["Quantity"].toStringAsFixed(0)),
        sapQuantity: int.tryParse(json["SapQuantity"].toStringAsFixed(0)),
      );

  Map<String, dynamic> toJson() => {
        "ItemCode": itemCode,
        "BatchNum": batchNum,
        "Quantity": quantity,
        "SapQuantity": sapQuantity,
      };
}

// enum ItemCode { FGOM00014, FGOM00015 }
//
// final itemCodeValues = EnumValues(
//     {"FGOM00014": ItemCode.FGOM00014, "FGOM00015": ItemCode.FGOM00015});
//
// class EnumValues<T> {
//   Map<String, T> map;
//   late Map<T, String> reverseMap;
//
//   EnumValues(this.map);
//
//   Map<T, String> get reverse {
//     reverseMap = map.map((k, v) => MapEntry(v, k));
//     return reverseMap;
//   }
// }
