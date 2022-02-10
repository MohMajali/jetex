// To parse this JSON data, do
//
//     final statusShipped = statusShippedFromJson(jsonString);

import 'dart:convert';

List<StatuShipped> statusShippedFromJson(String str) => List<StatuShipped>.from(
    json.decode(str).map((x) => StatuShipped.fromJson(x)));

String statusShippedToJson(List<StatuShipped> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StatuShipped {
  StatuShipped({
    this.itemsId,
    this.statusShippedOrderId,
    this.productId,
    this.storeId,
    this.createdAt,
    this.colorId,
    this.quantity,
    this.price,
    this.status,
    this.orderId,
    this.statusShippedUserId,
    this.productPaidFeatureLabel,
    this.productPaidFeatureWeight,
    this.totalPrice,
    this.userId,
    this.name,
    this.phone,
    this.nameEn,
    this.nameAr,
    this.image,
    this.statusEn,
    this.statusAr,
  });

  final int itemsId;
  final int statusShippedOrderId;
  final int productId;
  final int storeId;
  final String createdAt;
  final int colorId;
  final int quantity;
  final num price;
  final int status;
  final int orderId;
  final int statusShippedUserId;
  final dynamic productPaidFeatureLabel;
  final dynamic productPaidFeatureWeight;
  final num totalPrice;
  final int userId;
  final String name;
  final dynamic phone;
  final String nameEn;
  final String nameAr;
  final String image;
  final String statusEn;
  final String statusAr;

  factory StatuShipped.fromJson(Map<String, dynamic> json) => StatuShipped(
        itemsId: json["itemsID"],
        statusShippedOrderId: json["order_id"],
        productId: json["product_id"],
        storeId: json["store_id"],
        createdAt: json["created_at"],
        colorId: json["color_id"],
        quantity: json["quantity"],
        price: json["price"],
        status: json["status"],
        orderId: json["orderID"],
        statusShippedUserId: json["user_id"],
        productPaidFeatureLabel: json["product_paid_feature_label"],
        productPaidFeatureWeight: json["product_paid_feature_weight"],
        totalPrice: json["total_price"],
        userId: json["userID"],
        name: json["name"],
        phone: json["phone"],
        nameEn: json["name_en"],
        nameAr: json["name_ar"],
        image: json["image"],
        statusEn: json["status_en"],
        statusAr: json["status_ar"],
      );

  Map<String, dynamic> toJson() => {
        "itemsID": itemsId,
        "order_id": statusShippedOrderId,
        "product_id": productId,
        "store_id": storeId,
        "created_at": createdAt,
        "color_id": colorId,
        "quantity": quantity,
        "price": price,
        "status": status,
        "orderID": orderId,
        "user_id": statusShippedUserId,
        "product_paid_feature_label": productPaidFeatureLabel,
        "product_paid_feature_weight": productPaidFeatureWeight,
        "total_price": totalPrice,
        "userID": userId,
        "name": name,
        "phone": phone,
        "name_en": nameEn,
        "name_ar": nameAr,
        "image": image,
        "status_en": statusEn,
        "status_ar": statusAr,
      };
}
