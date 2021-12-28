// To parse this JSON data, do
//
//     final orderItem = orderItemFromJson(jsonString);

import 'dart:convert';

List<OrderItem> orderItemFromJson(String str) =>
    List<OrderItem>.from(json.decode(str).map((x) => OrderItem.fromJson(x)));

String orderItemToJson(List<OrderItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderItem {
  OrderItem({
    this.itemsId,
    this.orderItemOrderId,
    this.productId,
    this.storeId,
    this.createdAt,
    this.colorId,
    this.quantity,
    this.price,
    this.status,
    this.orderId,
    this.orderItemUserId,
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
  final int orderItemOrderId;
  final int productId;
  final int storeId;
  final String createdAt;
  final int colorId;
  final int quantity;
  final num price;
  final int status;
  final int orderId;
  final int orderItemUserId;
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

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        itemsId: json["itemsID"],
        orderItemOrderId: json["order_id"],
        productId: json["product_id"],
        storeId: json["store_id"],
        createdAt: json["created_at"],
        colorId: json["color_id"],
        quantity: json["quantity"],
        price: json["price"],
        status: json["status"],
        orderId: json["orderID"],
        orderItemUserId: json["user_id"],
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
        "order_id": orderItemOrderId,
        "product_id": productId,
        "store_id": storeId,
        "created_at": createdAt,
        "color_id": colorId,
        "quantity": quantity,
        "price": price,
        "status": status,
        "orderID": orderId,
        "user_id": orderItemUserId,
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
