// To parse this JSON data, do
//
//     final reviewApi = reviewApiFromJson(jsonString);

import 'dart:convert';

List<ReviewApi> reviewApiFromJson(String str) =>
    List<ReviewApi>.from(json.decode(str).map((x) => ReviewApi.fromJson(x)));

String reviewApiToJson(List<ReviewApi> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReviewApi {
  ReviewApi({
    this.id,
    this.userId,
    this.storesId,
    this.rating,
    this.review,
    this.name,
    this.email,
    this.profilePhotoPath,
  });

  final int id;
  final int userId;
  final int storesId;
  final num rating;
  final String review;
  final String name;
  final String email;
  final String profilePhotoPath;

  factory ReviewApi.fromJson(Map<String, dynamic> json) => ReviewApi(
        id: json["id"],
        userId: json["user_id"],
        storesId: json["stores_id"],
        rating: json["rating"].toDouble(),
        review: json["review"],
        name: json["name"],
        email: json["email"],
        profilePhotoPath: json["profile_photo_path"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "stores_id": storesId,
        "rating": rating,
        "review": review,
        "name": name,
        "email": email,
        "profile_photo_path": profilePhotoPath,
      };
}
