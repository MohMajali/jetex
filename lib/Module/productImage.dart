// To parse this JSON data, do
//
//     final prodcutImage = prodcutImageFromJson(jsonString);

import 'dart:convert';

List<ProdcutImage> prodcutImageFromJson(String str) => List<ProdcutImage>.from(json.decode(str).map((x) => ProdcutImage.fromJson(x)));

String prodcutImageToJson(List<ProdcutImage> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProdcutImage {
    ProdcutImage({
        this.id,
        this.imgUrl,
    });

    final int id;
    final String imgUrl;

    factory ProdcutImage.fromJson(Map<String, dynamic> json) => ProdcutImage(
        id: json["id"],
        imgUrl: json["img_url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "img_url": imgUrl,
    };
}
