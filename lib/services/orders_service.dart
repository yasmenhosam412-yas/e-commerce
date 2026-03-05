import 'package:boo/core/models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrdersService {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<List<OrderModel>> getOrders() async {
    final result = await firebaseFirestore
        .collection("dashboard")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("orders")
        .get();

    if (result.docs.isNotEmpty) {
      return result.docs.map((e) => OrderModel.fromMap(e.data())).toList();
    } else {
      return [];
    }
  }
}
