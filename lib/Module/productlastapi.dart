// To parse this JSON data, do
//
//     final productsApi = productsApiFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<ProductsApi> productsApiFromJson(String str) => List<ProductsApi>.from(
    json.decode(str).map((x) => ProductsApi.fromJson(x)));

String productsApiToJson(List<ProductsApi> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductsApi {
  ProductsApi({
    @required this.id,
    @required this.nameEn,
    @required this.nameAr,
    @required this.descriptionEn,
    @required this.descriptionAr,
    @required this.price,
    @required this.image,
    @required this.discount,
    @required this.brandId,
    @required this.warranty,
    @required this.modelNumber,
  });

  final int id;
  final String nameEn;
  final String nameAr;
  final String descriptionEn;
  final String descriptionAr;
  final int price;
  final String image;
  final int discount;
  final dynamic brandId;
  final dynamic warranty;
  final dynamic modelNumber;

  factory ProductsApi.fromJson(Map<String, dynamic> json) => ProductsApi(
        id: json["id"],
        nameEn: json["name_en"],
        nameAr: json["name_ar"],
        descriptionEn: json["description_en"],
        descriptionAr: json["description_ar"],
        price: json["price"],
        image: json["image"],
        discount: json["discount"],
        brandId: json["brand_id"],
        warranty: json["warranty"],
        modelNumber: json["model_number"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name_en": nameEn,
        "name_ar": nameAr,
        "description_en": descriptionEn,
        "description_ar": descriptionAr,
        "price": price,
        "image": image,
        "discount": discount,
        "brand_id": brandId,
        "warranty": warranty,
        "model_number": modelNumber,
      };
}
