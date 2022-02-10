// To parse this JSON data, do
//
//     final notifications = notificationsFromJson(jsonString);

import 'dart:convert';

List<Notifications> notificationsFromJson(String str) =>
    List<Notifications>.from(
        json.decode(str).map((x) => Notifications.fromJson(x)));

String notificationsToJson(List<Notifications> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Notifications {
  Notifications({
    this.id,
    this.subject,
    this.body,
    this.senderId,
    this.recieverId,
    this.name,
    this.profilePhotoPath,
  });

  final int id;
  final String subject;
  final String body;
  final int senderId;
  final int recieverId;
  final String name;
  final String profilePhotoPath;

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
        id: json["id"],
        subject: json["subject"],
        body: json["body"],
        senderId: json["sender_id"],
        recieverId: json["reciever_id"],
        name: json["name"],
        profilePhotoPath: json["profile_photo_path"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "subject": subject,
        "body": body,
        "sender_id": senderId,
        "reciever_id": recieverId,
        "name": name,
        "profile_photo_path": profilePhotoPath,
      };
}
