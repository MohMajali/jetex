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
  });

  int id;
  int userId;
  int storesId;
  num rating;
  String review;
  String name;
  String email;

  factory ReviewApi.fromJson(Map<String, dynamic> json) => ReviewApi(
        id: json["id"],
        userId: json["user_id"],
        storesId: json["stores_id"],
        rating: json["rating"],
        review: json["review"],
        name: json["name"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "stores_id": storesId,
        "rating": rating,
        "review": review,
        "name": name,
        "email": email,
      };
}
