import 'package:boo/core/models/cart_model.dart';
import 'package:boo/core/models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class CheckoutService {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> createOrder(List<CartModel> cart, String total) async {
    if (cart.isEmpty) return;

    final storeId = cart.first.createStoreModel.id;
    final orderId = Uuid().v4();

    final order = OrderModel(
      orderId: orderId,
      storeId: storeId ?? "",
      totalPrice: total,
      products: cart,
      status: 'pending',
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

  Future<void> updateOrderStatus(String storeId, String orderId, String status) async {
    final data = {'status': status};

    await firebaseFirestore
        .collection("dashboard")
        .doc(storeId)
        .collection("orders")
        .doc(orderId)
        .update(data);

    await firebaseFirestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("orders")
        .doc(orderId)
        .update(data);
  }

  Future<void> cancelOrder(String storeId, String orderId) async {
    await updateOrderStatus(storeId, orderId, 'canceled');
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
  }}