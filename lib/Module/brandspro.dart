// To parse this JSON data, do
//
//     final brandspro = brandsproFromJson(jsonString);

import 'dart:convert';

List<Brandspro> brandsproFromJson(String str) =>
    List<Brandspro>.from(json.decode(str).map((x) => Brandspro.fromJson(x)));

String brandsproToJson(List<Brandspro> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Brandspro {
  Brandspro({
    this.brandId,
    this.nameEn,
    this.nameAr,
  });

  final int brandId;
  final String nameEn;
  final String nameAr;

  factory Brandspro.fromJson(Map<String, dynamic> json) => Brandspro(
        brandId: json["brand_id"],
        nameEn: json["name_en"],
        nameAr: json["name_ar"],
      );

  Map<String, dynamic> toJson() => {
        "brand_id": brandId,
        "name_en": nameEn,
        "name_ar": nameAr,
      };
}
