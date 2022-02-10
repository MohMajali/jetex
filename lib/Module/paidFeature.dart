// To parse this JSON data, do
//
//     final paidFeatures = paidFeaturesFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<PaidFeatures> paidFeaturesFromJson(String str) => List<PaidFeatures>.from(
    json.decode(str).map((x) => PaidFeatures.fromJson(x)));

String paidFeaturesToJson(List<PaidFeatures> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PaidFeatures {
  PaidFeatures({
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
  final num price;

  factory PaidFeatures.fromJson(Map<String, dynamic> json) => PaidFeatures(
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
