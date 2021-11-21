// To parse this JSON data, do
//
//     final sub2Category = sub2CategoryFromJson(jsonString);

import 'dart:convert';

List<Sub2Category> sub2CategoryFromJson(String str) => List<Sub2Category>.from(
    json.decode(str).map((x) => Sub2Category.fromJson(x)));

String sub2CategoryToJson(List<Sub2Category> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Sub2Category {
  Sub2Category({
    this.id,
    this.nameEn,
    this.nameAr,
    this.storeSub1CategoriesId,
  });

  final int id;
  final String nameEn;
  final String nameAr;
  final int storeSub1CategoriesId;

  factory Sub2Category.fromJson(Map<String, dynamic> json) => Sub2Category(
        id: json["id"],
        nameEn: json["name_en"],
        nameAr: json["name_ar"],
        storeSub1CategoriesId: json["store_sub1_categories_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name_en": nameEn,
        "name_ar": nameAr,
        "store_sub1_categories_id": storeSub1CategoriesId,
      };
}
