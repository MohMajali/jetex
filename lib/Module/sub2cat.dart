// To parse this JSON data, do
//
//     final sub2Cat = sub2CatFromJson(jsonString);

import 'dart:convert';

List<Sub2Cat> sub2CatFromJson(String str) =>
    List<Sub2Cat>.from(json.decode(str).map((x) => Sub2Cat.fromJson(x)));

String sub2CatToJson(List<Sub2Cat> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Sub2Cat {
  Sub2Cat({
    this.sub2CategoryId,
    this.nameEn,
    this.nameAr,
  });

  final int sub2CategoryId;
  final String nameEn;
  final String nameAr;

  factory Sub2Cat.fromJson(Map<String, dynamic> json) => Sub2Cat(
        sub2CategoryId: json["sub2_category_id"],
        nameEn: json["name_en"],
        nameAr: json["name_ar"],
      );

  Map<String, dynamic> toJson() => {
        "sub2_category_id": sub2CategoryId,
        "name_en": nameEn,
        "name_ar": nameAr,
      };
}
