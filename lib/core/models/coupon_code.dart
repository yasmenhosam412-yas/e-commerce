import 'package:cloud_firestore/cloud_firestore.dart';

class CouponCode {
  final String id;
  final String code;
  final DateTime createdAt;
  final DateTime expiryDate;
  final String type;
  final double value;

  CouponCode({
    required this.id,
    required this.code,
    required this.createdAt,
    required this.expiryDate,
    required this.type,
    required this.value,
  });

  factory CouponCode.fromMap(Map<String, dynamic> map) {
    return CouponCode(
      id: map['id'],
      code: map['code'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      expiryDate: DateTime.parse(map['expiryDate']),
      type: map['type'],
      value: double.parse(map['value']),
    );
  }
}