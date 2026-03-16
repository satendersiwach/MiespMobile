import 'dart:convert';

PendingItemModel pendingItemModelFromJson(String str) =>
    PendingItemModel.fromJson(json.decode(str));

String pendingItemModelToJson(PendingItemModel data) =>
    json.encode(data.toJson());

class PendingItemModel {
  int? pageNum;
  int? totalCount;
  int? pageSize;
  int? totalPages;
  List<Datum>? data;

  PendingItemModel({
    this.pageNum,
    this.totalCount,
    this.pageSize,
    this.totalPages,
    this.data,
  });

  factory PendingItemModel.fromJson(Map<String, dynamic> json) =>
      PendingItemModel(
        pageNum: int.tryParse(json["PageNum"]?.toString() ?? '0') ?? 0,
        totalCount: int.tryParse(json["TotalCount"]?.toString() ?? '0') ?? 0,
        pageSize: int.tryParse(json["PageSize"]?.toString() ?? '0') ?? 0,
        totalPages: int.tryParse(json["TotalPages"]?.toString() ?? '0') ?? 0,
        data: json["Data"] == null
            ? []
            : List<Datum>.from(json["Data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "PageNum": pageNum,
        "TotalCount": totalCount,
        "PageSize": pageSize,
        "TotalPages": totalPages,
        "Data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  String? itemCode;
  String? itemName;
  String? whsName;
  int? itmsGrpCod;
  String? batchNum;

  Datum({
    this.itemCode,
    this.itemName,
    this.whsName,
    this.itmsGrpCod,
    this.batchNum,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        itemCode: json["ItemCode"],
        itemName: json["ItemName"],
        whsName: json["WhsName"],
        itmsGrpCod: int.tryParse(json["ItmsGrpCod"].toString()) ?? 0,
        batchNum: json["BatchNum"],
      );

  Map<String, dynamic> toJson() => {
        "ItemCode": itemCode,
        "ItemName": itemName,
        "WhsName": whsName,
        "ItmsGrpCod": itmsGrpCod,
        "BatchNum": batchNum,
      };
}
