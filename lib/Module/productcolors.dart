// To parse this JSON data, do
//
//     final productColors = productColorsFromJson(jsonString);

import 'dart:convert';

List<ProductColors> productColorsFromJson(String str) =>
    List<ProductColors>.from(
        json.decode(str).map((x) => ProductColors.fromJson(x)));

String productColorsToJson(List<ProductColors> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductColors {
  ProductColors({
    this.itemsId,
    this.colorId,
    this.colorCode,
  });

  final int itemsId;
  final int colorId;
  final String colorCode;

  factory ProductColors.fromJson(Map<String, dynamic> json) => ProductColors(
        itemsId: json["itemsID"],
        colorId: json["color_id"],
        colorCode: json["color_code"],
      );

  Map<String, dynamic> toJson() => {
        "itemsID": itemsId,
        "color_id": colorId,
        "color_code": colorCode,
      };
}
