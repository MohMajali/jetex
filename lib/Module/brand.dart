// To parse this JSON data, do
//
//     final brands = brandsFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Brands> brandsFromJson(String str) =>
    List<Brands>.from(json.decode(str).map((x) => Brands.fromJson(x)));

String brandsToJson(List<Brands> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Brands {
  Brands({
    @required this.id,
    @required this.nameEn,
    @required this.nameAr,
  });

  final int id;
  final String nameEn;
  final String nameAr;

  factory Brands.fromJson(Map<String, dynamic> json) => Brands(
        id: json["id"],
        nameEn: json["name_en"],
        nameAr: json["name_ar"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name_en": nameEn,
        "name_ar": nameAr,
      };
}
