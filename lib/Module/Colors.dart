// To parse this JSON data, do
//
//     final productColors = productColorsFromJson(jsonString);

import 'dart:convert';

List<ProductColors> productColorsFromJson(String str) => List<ProductColors>.from(json.decode(str).map((x) => ProductColors.fromJson(x)));

String productColorsToJson(List<ProductColors> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductColors {
    ProductColors({
        this.id,
        this.colorCode,
    });

    final int id;
    final String colorCode;

    factory ProductColors.fromJson(Map<String, dynamic> json) => ProductColors(
        id: json["id"],
        colorCode: json["color_code"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "color_code": colorCode,
    };
}
