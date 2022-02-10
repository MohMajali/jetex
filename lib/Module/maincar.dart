// To parse this JSON data, do
//
//     final mainCat = mainCatFromJson(jsonString);

import 'dart:convert';

List<MainCat> mainCatFromJson(String str) =>
    List<MainCat>.from(json.decode(str).map((x) => MainCat.fromJson(x)));

String mainCatToJson(List<MainCat> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MainCat {
  MainCat({
    this.categoryId,
    this.nameEn,
    this.nameAr,
  });

  final int categoryId;
  final String nameEn;
  final String nameAr;

  factory MainCat.fromJson(Map<String, dynamic> json) => MainCat(
        categoryId: json["category_id"],
        nameEn: json["name_en"],
        nameAr: json["name_ar"],
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "name_en": nameEn,
        "name_ar": nameAr,
      };
}
