// To parse this JSON data, do
//
//     final features = featuresFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Features> featuresFromJson(String str) =>
    List<Features>.from(json.decode(str).map((x) => Features.fromJson(x)));

String featuresToJson(List<Features> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Features {
  Features({
    @required this.id,
    @required this.labelEn,
    @required this.labelAr,
    @required this.descriptionEn,
    @required this.descriptionAr,
    @required this.price,
  });

  final int id;
  final String labelEn;
  final String labelAr;
  final String descriptionEn;
  final String descriptionAr;
  final String price;

  factory Features.fromJson(Map<String, dynamic> json) => Features(
        id: json["id"],
        labelEn: json["label_en"],
        labelAr: json["label_ar"],
        descriptionEn: json["description_en"],
        descriptionAr: json["description_ar"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "label_en": labelEn,
        "label_ar": labelAr,
        "description_en": descriptionEn,
        "description_ar": descriptionAr,
        "price": price,
      };
}
