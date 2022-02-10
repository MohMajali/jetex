// To parse this JSON data, do
//
//     final sub3Cat = sub3CatFromJson(jsonString);

import 'dart:convert';

List<Sub3Cat> sub3CatFromJson(String str) =>
    List<Sub3Cat>.from(json.decode(str).map((x) => Sub3Cat.fromJson(x)));

String sub3CatToJson(List<Sub3Cat> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Sub3Cat {
  Sub3Cat({
    this.sub3CategoryId,
    this.nameEn,
    this.nameAr,
  });

  final int sub3CategoryId;
  final String nameEn;
  final String nameAr;

  factory Sub3Cat.fromJson(Map<String, dynamic> json) => Sub3Cat(
        sub3CategoryId: json["sub3_category_id"],
        nameEn: json["name_en"],
        nameAr: json["name_ar"],
      );

  Map<String, dynamic> toJson() => {
        "sub3_category_id": sub3CategoryId,
        "name_en": nameEn,
        "name_ar": nameAr,
      };
}
