// To parse this JSON data, do
//
//     final subCat = subCatFromJson(jsonString);

import 'dart:convert';

List<SubCat> subCatFromJson(String str) =>
    List<SubCat>.from(json.decode(str).map((x) => SubCat.fromJson(x)));

String subCatToJson(List<SubCat> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubCat {
  SubCat({
    this.subCategoryId,
    this.nameEn,
    this.nameAr,
  });

  final int subCategoryId;
  final String nameEn;
  final String nameAr;

  factory SubCat.fromJson(Map<String, dynamic> json) => SubCat(
        subCategoryId: json["sub_category_id"],
        nameEn: json["name_en"],
        nameAr: json["name_ar"],
      );

  Map<String, dynamic> toJson() => {
        "sub_category_id": subCategoryId,
        "name_en": nameEn,
        "name_ar": nameAr,
      };
}
