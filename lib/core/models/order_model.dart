import 'package:boo/core/models/cart_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String orderId;
  final String storeId;
  final String totalPrice;
  final List<CartModel> products;
  final String status;
  final DateTime? createdAt;

  OrderModel({
    required this.orderId,
    required this.storeId,
    required this.totalPrice,
    required this.products,
    required this.status,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'storeId': storeId,
      'totalPrice': totalPrice,
      'products': products.map((p) => p.toMap()).toList(),
      'status': status,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map['orderId'] ?? '',
      storeId: map['storeId'] ?? '',
      totalPrice: map['totalPrice'] ?? '0',
      products: map['products'] != null
          ? List<CartModel>.from(
              (map['products'] as List).asMap().entries.map(
                (entry) => CartModel.fromMap(entry.value, entry.key.toString()),
              ),
            )
          : [],
      status: map['status'] ?? 'pending',
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
    );
  }
}
