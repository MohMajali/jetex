// To parse this JSON data, do
//
//     final types = typesFromJson(jsonString);

import 'dart:convert';

List<Types> typesFromJson(String str) =>
    List<Types>.from(json.decode(str).map((x) => Types.fromJson(x)));

String typesToJson(List<Types> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Types {
  Types({
    this.id,
    this.nameEn,
    this.nameAr,
  });

  final int id;
  final String nameEn;
  final String nameAr;

  factory Types.fromJson(Map<String, dynamic> json) => Types(
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
