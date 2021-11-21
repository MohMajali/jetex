// To parse this JSON data, do
//
//     final sub3Category = sub3CategoryFromJson(jsonString);

import 'dart:convert';

List<Sub3Category> sub3CategoryFromJson(String str) => List<Sub3Category>.from(
    json.decode(str).map((x) => Sub3Category.fromJson(x)));

String sub3CategoryToJson(List<Sub3Category> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Sub3Category {
  Sub3Category({
    this.id,
    this.nameEn,
    this.nameAr,
    this.storeSub2CategoriesId,
  });

  final int id;
  final String nameEn;
  final String nameAr;
  final int storeSub2CategoriesId;

  factory Sub3Category.fromJson(Map<String, dynamic> json) => Sub3Category(
        id: json["id"],
        nameEn: json["name_en"],
        nameAr: json["name_ar"],
        storeSub2CategoriesId: json["store_sub2_categories_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name_en": nameEn,
        "name_ar": nameAr,
        "store_sub2_categories_id": storeSub2CategoriesId,
      };
}
