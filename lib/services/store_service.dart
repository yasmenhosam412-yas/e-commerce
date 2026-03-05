import 'dart:io';
import 'package:boo/core/models/create_store_model.dart';
import 'package:boo/core/models/products_model.dart';
import 'package:boo/services/cloudinary_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../core/models/discount_model.dart';

class StoreService {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<void> addProduct({
    required List<String> images,
    required String name,
    required String desc,
    required String price,
    required String category,
    required String quantity,
    required CreateStoreModel store,
    required Map<String, List<String>> attributes,
    List<String>? sizes,
    bool isFeatured = false,
  }) async {
    final List<String> uploadedImages = [];

    for (final path in images) {
      final imageUrl = await CloudinaryService().saveToCloudinary(File(path));
      if (imageUrl != null && imageUrl.isNotEmpty) {
        uploadedImages.add(imageUrl);
      }
    }

    if (uploadedImages.isEmpty) {
      throw Exception("At least one image must be uploaded for the product.");
    }

    final counterRef = firebaseFirestore.collection("counters").doc("products");

    await firebaseFirestore.runTransaction((transaction) async {
      final counterSnap = await transaction.get(counterRef);

      int newId = 1;

      if (counterSnap.exists) {
        newId = (counterSnap.get("lastId") ?? 0) + 1;
      }

      transaction.set(counterRef, {"lastId": newId});

      final String uid = firebaseAuth.currentUser!.uid;
      final dashboardRef = firebaseFirestore.collection("dashboard").doc(uid);

      final storeData = store.toJson();
      storeData['id'] = uid;

      transaction.set(dashboardRef, {
        "store": storeData,
        "uid": uid,
        "lastUpdated": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      final productRef = dashboardRef
          .collection("products")
          .doc(newId.toString());

      final productData = {
        "id": newId,
        "image": uploadedImages.first,
        "images": uploadedImages,
        "name": name,
        "desc": desc,
        "price": double.parse(price),
        "category": category,
        "quantity": int.parse(quantity),
        "sizes": sizes ?? [],
        "attributes": attributes,
        "isFeatured": isFeatured,
        "storeId": uid,
        "store": storeData,
        "createdAt": FieldValue.serverTimestamp(),
      };

      transaction.set(productRef, productData);

      if (isFeatured) {
        final featuredRef = firebaseFirestore
            .collection("featuredProducts")
            .doc(newId.toString());
        transaction.set(featuredRef, productData);
      }
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
    if (description != null && description.isNotEmpty) {
      updatedData['desc'] = description;
    }

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
    CreateStoreModel store,
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
      "store": store.toJson(),
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

  Future<List<ProductsModel>> getProducts(String uid) async {
    final snapshot = await firebaseFirestore
        .collection("dashboard")
        .doc(uid)
        .collection("products")
        .get();

    return snapshot.docs.map((doc) {
      return ProductsModel.fromMap(doc.data(), doc.id);
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
    List<String>? images,
    String? name,
    String? desc,
    double? price,
    String? category,
    int? quantity,
    List<String>? sizes,
    Map<String, List<String>>? attributes,
    String? collectionName,
    String? discount,
    double? newPrice,
    bool? isFeatured,
  }) async {
    final Map<String, dynamic> updatedData = {};

    if (images != null && images.isNotEmpty) {
      final List<String> uploadedImages = [];

      for (final path in images) {
        final imageUrl = await CloudinaryService().saveToCloudinary(File(path));
        uploadedImages.add(imageUrl ?? "");
      }

      updatedData['images'] = uploadedImages;
      updatedData['image'] = uploadedImages.first;
    }
    if (name != null) updatedData['name'] = name;
    if (desc != null) updatedData['desc'] = desc;
    if (price != null) updatedData['price'] = price;
    if (category != null) updatedData['category'] = category;
    if (quantity != null) updatedData['quantity'] = quantity;
    if (sizes != null) updatedData['sizes'] = sizes;
    if (attributes != null) updatedData['attributes'] = attributes;

    if (collectionName != null) {
      updatedData['collectionName'] = collectionName;
    }
    if (discount != null) updatedData['discount'] = discount;
    if (newPrice != null) updatedData['newPrice'] = newPrice;
    if (isFeatured != null) updatedData['isFeatured'] = isFeatured;

    if (updatedData.isEmpty && isFeatured == null) return;

    final String uid = firebaseAuth.currentUser!.uid;
    final productRef = firebaseFirestore
        .collection("dashboard")
        .doc(uid)
        .collection("products")
        .doc(productId);

    if (updatedData.isNotEmpty) {
      await productRef.update(updatedData);
    }

    final productSnapshot = await productRef.get();
    if (productSnapshot.exists) {
      final productData = productSnapshot.data()!;
      final bool currentlyFeatured = productData['isFeatured'] ?? false;

      if (currentlyFeatured) {
        await firebaseFirestore
            .collection("featuredProducts")
            .doc(productId)
            .set({...productData, "id": productId, "storeId": uid});
      } else {
        await firebaseFirestore
            .collection("featuredProducts")
            .doc(productId)
            .delete();
      }
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
