import 'package:boo/core/models/cart_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartService {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addItemToCart(CartModel cartModel) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    await firebaseFirestore
        .collection("carts")
        .doc(userId)
        .collection("items")
        .doc(cartModel.id)
        .set(cartModel.toMap(), SetOptions(merge: true));
  }

  Future<void> updateItemQuantity(String cartItemId, int quantity) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    await firebaseFirestore
        .collection("carts")
        .doc(userId)
        .collection("items")
        .doc(cartItemId)
        .update({'quantity': quantity});
  }

  Future<void> deleteItemFromCart(String cartItemId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    await firebaseFirestore
        .collection("carts")
        .doc(userId)
        .collection("items")
        .doc(cartItemId)
        .delete();
  }

  Future<List<CartModel>> getCart() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final snapshots = await firebaseFirestore
        .collection("carts")
        .doc(userId)
        .collection("items")
        .get();

    if (snapshots.docs.isNotEmpty) {
      return snapshots.docs
          .map((e) => CartModel.fromMap(e.data(), e.id))
          .toList();
    } else {
      return [];
    }
  }
}
