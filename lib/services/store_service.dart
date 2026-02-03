import 'dart:io';
import 'dart:ui';
import 'package:boo/core/models/products_model.dart';
import 'package:boo/services/cloudinary_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../core/models/discount_model.dart';

class StoreService {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<void> addProduct(
    String image,
    String name,
    String desc,
    String price,
    String category,
    String quantity,
    List<String> sizes,
  ) async {
    final imagePath = await CloudinaryService().saveToCloudinary(File(image));

    final counterRef = firebaseFirestore.collection("counters").doc("products");

    await firebaseFirestore.runTransaction((transaction) async {
      final counterSnap = await transaction.get(counterRef);

      int newId = 1;

      if (counterSnap.exists) {
        newId = (counterSnap.get("lastId") ?? 0) + 1;
      }

      transaction.set(counterRef, {"lastId": newId});

      final productRef = firebaseFirestore
          .collection("dashboard")
          .doc(firebaseAuth.currentUser!.uid)
          .collection("products")
          .doc(newId.toString());

      transaction.set(productRef, {
        "id": newId,
        "image": imagePath,
        "name": name,
        "desc": desc,
        "price": double.parse(price),
        "category": category,
        "quantity": int.parse(quantity),
        "sizes": sizes,
        "createdAt": FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> addCollection(String name, String desc) async {
    await firebaseFirestore
        .collection("dashboard")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("collections")
        .add({
          "name": name,
          "desc": desc,
          "createdAt": FieldValue.serverTimestamp(),
        });
  }

  Future<void> addAds(
    File image,
    String badgeText,
    String position,
    String badgeColor,
    String textColor,
  ) async {
    final imagePath = await CloudinaryService().saveToCloudinary(image);

    await firebaseFirestore
        .collection("dashboard")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("ads")
        .add({
          "image": imagePath,
          "badgeText": badgeText,
          "position": position,
          "badgeColor": badgeColor,
          "textColor": textColor,
        });
  }

  Future<void> addDiscount(
    String name,
    String value,
    String start,
    String end,
  ) async {
    await firebaseFirestore
        .collection("dashboard")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("discount")
        .add({
          "name": name,
          "value": "$value %",
          "start": start,
          "end": end,
          "createdAt": FieldValue.serverTimestamp(),
        });
  }

  Future<List<ProductsModel>> getProducts() async {
    final snapshot = await firebaseFirestore
        .collection("dashboard")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("products")
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return ProductsModel(
        id: data['id'],
        image: data['image'] ?? '',
        name: data['name'] ?? '',
        desc: data['desc'] ?? '',
        price: data['price'] ?? 0,
        category: data['category'] ?? '',
        quantity: data['quantity'] ?? 0,
        sizes: List<String>.from(data['sizes'] ?? []),
        isFeatured: data['isFeatured'],
        collectionName: data['collectionName'],
        newPrice: data['newPrice'],
        discount: data['discount'],
      );
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getCollections() async {
    final snapshot = await firebaseFirestore
        .collection("dashboard")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("collections")
        .get();

    return snapshot.docs.map((doc) => {"id": doc.id, ...doc.data()}).toList();
  }

  Future<List<DiscountModel>> getDiscounts() async {
    final snapshot = await firebaseFirestore
        .collection("dashboard")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("discount")
        .get();

    return snapshot.docs
        .map((doc) => DiscountModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> updateProduct({
    required String productId,
    String? image,
    String? name,
    String? desc,
    double? price,
    String? category,
    int? quantity,
    List<String>? sizes,
    String? collectionName,
    String? discount,
    double? newPrice,
    bool? isFeatured,
  }) async {
    final Map<String, dynamic> updatedData = {};

    if (image != null) updatedData['image'] = image;
    if (name != null) updatedData['name'] = name;
    if (desc != null) updatedData['desc'] = desc;
    if (price != null) updatedData['price'] = price;
    if (category != null) updatedData['category'] = category;
    if (quantity != null) updatedData['quantity'] = quantity;
    if (sizes != null) updatedData['sizes'] = sizes;

    updatedData['collectionName'] = collectionName;
    updatedData['discount'] = discount;
    if (newPrice != null) updatedData['newPrice'] = newPrice;
    if (isFeatured != null) updatedData['isFeatured'] = isFeatured;

    await firebaseFirestore
        .collection("dashboard")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("products")
        .doc(productId)
        .update(updatedData);
  }
}
