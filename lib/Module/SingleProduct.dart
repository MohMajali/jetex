// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Product> productFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  Product({
    this.id,
    this.nameEn,
    this.nameAr,
    this.descriptionEn,
    this.descriptionAr,
    this.price,
    this.image,
    this.discount,
  });

  final int id;
  final String nameEn;
  final String nameAr;
  final String descriptionEn;
  final String descriptionAr;
  final int price;
  final String image;
  final double discount;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        nameEn: json["name_en"],
        nameAr: json["name_ar"],
        descriptionEn: json["description_en"],
        descriptionAr: json["description_ar"],
        price: json["price"],
        image: json["image"],
        discount: json["discount"].toDouble(),
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
      };
}
