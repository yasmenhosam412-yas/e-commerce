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
    final docRef = firebaseFirestore
        .collection("dashboard")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("collections")
        .doc();

    await docRef.set({
      "id": docRef.id,
      "name": name,
      "desc": desc,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteCollection(String collectionId) async {
    await firebaseFirestore
        .collection("dashboard")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("collections")
        .doc(collectionId)
        .delete();
  }

  Future<void> updateCollection({
    required String collectionId,
    String? name,
    String? description,
  }) async {
    final Map<String, dynamic> updatedData = {};

    if (name != null && name.isNotEmpty) updatedData['name'] = name;
    if (description != null && description.isNotEmpty)
      updatedData['desc'] = description;

    if (updatedData.isEmpty) return;

    await firebaseFirestore
        .collection("dashboard")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("collections")
        .doc(collectionId)
        .update(updatedData);
  }

  Future<void> addAds(
    File image,
    String badgeText,
    String position,
    String badgeColor,
    String textColor,
  ) async {
    final imagePath = await CloudinaryService().saveToCloudinary(image);

    final docRef = firebaseFirestore
        .collection("dashboard")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("ads")
        .doc();
    await docRef.set({
      "id": docRef.id,
      "image": imagePath,
      "badgeText": badgeText,
      "position": position,
      "badgeColor": badgeColor,
      "textColor": textColor,
    });

    await firebaseFirestore.collection("AllAds").doc(docRef.id).set({
      "id": docRef.id,
      "image": imagePath,
      "badgeText": badgeText,
      "position": position,
      "badgeColor": badgeColor,
      "textColor": textColor,
      "storeId": FirebaseAuth.instance.currentUser?.uid,
    });
  }

  Future<void> deleteAd({required String adId}) async {
    await firebaseFirestore
        .collection("dashboard")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("ads")
        .doc(adId)
        .delete();
    await firebaseFirestore.collection("AllAds").doc(adId).delete();
  }

  Future<List<Map<String, dynamic>>> getAds() async {
    final querySnapshot = await firebaseFirestore
        .collection("dashboard")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("ads")
        .get();

    final ads = querySnapshot.docs.map((doc) {
      final data = doc.data();
      data["id"] = doc.id;
      return data;
    }).toList();

    return ads;
  }

  Future<void> addDiscount(
    String name,
    String value,
    String start,
    String end,
  ) async {
    final docRef = firebaseFirestore
        .collection("dashboard")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("discount")
        .doc();

    await docRef.set({
      "id": docRef.id,
      "name": name,
      "value": "$value %",
      "start": start,
      "end": end,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> addCoupon(
    String name,
    String value,
    String expiryDate,
    String type,
  ) async {
    final docRef = firebaseFirestore
        .collection("dashboard")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("coupons")
        .doc();
    await docRef.set({
      "id": docRef.id,
      "code": name,
      "value": value,
      "expiryDate": expiryDate,
      "type": type,

      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteDiscount(String discountId) async {
    await firebaseFirestore
        .collection("dashboard")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("discount")
        .doc(discountId)
        .delete();
  }

  Future<void> deleteCoupon(String couponId) async {
    await firebaseFirestore
        .collection("dashboard")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("coupons")
        .doc(couponId)
        .delete();
  }

  Future<List<Map<String, dynamic>>> getCoupons() async {
    final querySnapshot = await firebaseFirestore
        .collection("dashboard")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("coupons")
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
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

    String? imagePath;

    if (image != null && image.isNotEmpty) {
      imagePath = await CloudinaryService().saveToCloudinary(File(image));
      updatedData['image'] = imagePath;
    }

    if (name != null) updatedData['name'] = name;
    if (desc != null) updatedData['desc'] = desc;
    if (price != null) updatedData['price'] = price;
    if (category != null) updatedData['category'] = category;
    if (quantity != null) updatedData['quantity'] = quantity;
    if (sizes != null) updatedData['sizes'] = sizes;
    if (collectionName != null) {
      updatedData['collectionName'] = collectionName;
    }
    if (discount != null) updatedData['discount'] = discount;
    if (newPrice != null) updatedData['newPrice'] = newPrice;
    if (isFeatured != null) updatedData['isFeatured'] = isFeatured;

    final productRef = firebaseFirestore
        .collection("dashboard")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("products")
        .doc(productId);

    await productRef.update(updatedData);

    if (isFeatured == true) {
      final productSnapshot = await productRef.get();
      final productData = productSnapshot.data()!;

      await firebaseFirestore
          .collection("featuredProducts")
          .doc(productId)
          .set({
            ...productData,
            "id": productId,
            "storeId": FirebaseAuth.instance.currentUser?.uid,
          });
    } else if (isFeatured == false) {
      await firebaseFirestore
          .collection("featuredProducts")
          .doc(productId)
          .delete();
    }
  }

  Future<void> deleteProduct({required String productId}) async {
    await firebaseFirestore
        .collection("dashboard")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("products")
        .doc(productId)
        .delete();

    await firebaseFirestore
        .collection("featuredProducts")
        .doc(productId)
        .delete();
  }
}
