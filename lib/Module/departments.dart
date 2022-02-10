// To parse this JSON data, do
//
//     final departments = departmentsFromJson(jsonString);

import 'dart:convert';

List<Departments> departmentsFromJson(String str) => List<Departments>.from(
    json.decode(str).map((x) => Departments.fromJson(x)));

String departmentsToJson(List<Departments> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Departments {
  Departments({
    this.id,
    this.typeId,
    this.nameEn,
    this.nameAr,
    this.active,
    this.title,
  });

  final int id;
  final int typeId;
  final String nameEn;
  final String nameAr;
  final int active;
  final List<Title> title;

  factory Departments.fromJson(Map<String, dynamic> json) => Departments(
        id: json["id"],
        typeId: json["type_id"],
        nameEn: json["name_en"],
        nameAr: json["name_ar"],
        active: json["active"],
        title: List<Title>.from(json["title"].map((x) => Title.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type_id": typeId,
        "name_en": nameEn,
        "name_ar": nameAr,
        "active": active,
        "title": List<dynamic>.from(title.map((x) => x.toJson())),
      };
}

class Title {
  Title({
    this.id,
    this.departmentId,
    this.titleAr,
    this.titleEn,
    this.points,
  });

  final int id;
  final String departmentId;
  final String titleAr;
  final String titleEn;
  final List<Point> points;

  factory Title.fromJson(Map<String, dynamic> json) => Title(
        id: json["id"],
        departmentId: json["department_id"],
        titleAr: json["title_ar"],
        titleEn: json["title_en"],
        points: List<Point>.from(json["points"].map((x) => Point.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "department_id": departmentId,
        "title_ar": titleAr,
        "title_en": titleEn,
        "points": List<dynamic>.from(points.map((x) => x.toJson())),
      };
}

class Point {
  Point({
    this.id,
    this.titleId,
    this.nameEn,
    this.nameAr,
    this.pointValueEn,
    this.pointValueAr,
  });

  final int id;
  final int titleId;
  final String nameEn;
  final String nameAr;
  final String pointValueEn;
  final String pointValueAr;

  factory Point.fromJson(Map<String, dynamic> json) => Point(
        id: json["id"],
        titleId: json["title_id"],
        nameEn: json["name_en"],
        nameAr: json["name_ar"],
        pointValueEn: json["point_value_en"],
        pointValueAr: json["point_value_ar"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title_id": titleId,
        "name_en": nameEn,
        "name_ar": nameAr,
        "point_value_en": pointValueEn,
        "point_value_ar": pointValueAr,
      };
}
