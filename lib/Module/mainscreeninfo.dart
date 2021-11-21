// To parse this JSON data, do
//
//     final maininfo = maininfoFromJson(jsonString);

import 'dart:convert';

List<Maininfo> maininfoFromJson(String str) =>
    List<Maininfo>.from(json.decode(str).map((x) => Maininfo.fromJson(x)));

String maininfoToJson(List<Maininfo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Maininfo {
  Maininfo({
    this.id,
    this.storeLogo,
    this.storeLocation,
    this.nameEn,
    this.nameAr,
    this.rate,
    this.password,
    this.storeType,
    this.storeEmail,
    this.userId,
    this.phoneNumber,
    this.active,
  });

  final int id;
  final String storeLogo;
  final String storeLocation;
  final String nameEn;
  final String nameAr;
  final double rate;
  final String password;
  final int storeType;
  final String storeEmail;
  final int userId;
  final int phoneNumber;
  final int active;

  factory Maininfo.fromJson(Map<String, dynamic> json) => Maininfo(
        id: json["id"],
        storeLogo: json["store_logo"],
        storeLocation: json["store_location"],
        nameEn: json["name_en"],
        nameAr: json["name_ar"],
        rate: json["rate"].toDouble(),
        password: json["password"],
        storeType: json["store_type"],
        storeEmail: json["store_email"],
        userId: json["user_id"],
        phoneNumber: json["phone_number"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "store_logo": storeLogo,
        "store_location": storeLocation,
        "name_en": nameEn,
        "name_ar": nameAr,
        "rate": rate,
        "password": password,
        "store_type": storeType,
        "store_email": storeEmail,
        "user_id": userId,
        "phone_number": phoneNumber,
        "active": active,
      };
}
