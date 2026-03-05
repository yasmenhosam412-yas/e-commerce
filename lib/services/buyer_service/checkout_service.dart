import 'package:boo/core/models/cart_model.dart';
import 'package:boo/core/models/order_model.dart';
import 'package:boo/core/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../../core/models/coupon_code.dart';

class CheckoutService {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> createOrder(
    List<CartModel> cart,
    String total,
    bool withCoupon,
    UserModel userModel,
  ) async {
    if (cart.isEmpty) return;

    final storeId = cart.first.createStoreModel.id;
    final orderId = Uuid().v4();

    final order = OrderModel(
      orderId: orderId,
      storeId: storeId ?? "",
      totalPrice: total,
      products: cart,
      status: 'pending',
      withCoupon: withCoupon,
      userModel: userModel,
    );

    await firebaseFirestore
        .collection("dashboard")
        .doc(storeId)
        .collection("orders")
        .doc(orderId)
        .set(order.toMap());

    await firebaseFirestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('orders')
        .doc(orderId)
        .set(order.toMap());
  }

  Future<void> updateOrderStatus(
    String storeId,
    String orderId,
    String userId,
    String status,
  ) async {
    final data = {'status': status};

    await firebaseFirestore
        .collection("dashboard")
        .doc(storeId)
        .collection("orders")
        .doc(orderId)
        .update(data);

    await firebaseFirestore
        .collection("users")
        .doc(userId)
        .collection("orders")
        .doc(orderId)
        .update(data);
  }

  Future<void> cancelOrder(String storeId, String orderId) async {
    await updateOrderStatus(
      storeId,
      orderId,
      FirebaseAuth.instance.currentUser!.uid,
      'canceled',
    );
  }

  Future<List<OrderModel>> getUserOrdersOnce() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await firebaseFirestore
        .collection("users")
        .doc(uid)
        .collection("orders")
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => OrderModel.fromMap(doc.data())).toList();
  }

  Future<List<OrderModel>> getStoreOrdersOnce(String storeId) async {
    final snapshot = await firebaseFirestore
        .collection("dashboard")
        .doc(storeId)
        .collection("orders")
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => OrderModel.fromMap(doc.data())).toList();
  }

  Future<CouponCode?> applyCoupon(String code, String storeId) async {
    final query = await firebaseFirestore
        .collection('dashboard')
        .doc(storeId)
        .collection("coupons")
        .where("code", isEqualTo: code)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;

    final data = query.docs.first.data();

    final expiryDate = DateTime.parse(data["expiryDate"]);

    if (expiryDate.isBefore(DateTime.now())) {
      return null;
    }

    return CouponCode.fromMap(data);
  }
}
