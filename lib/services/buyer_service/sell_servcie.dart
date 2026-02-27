import 'dart:io';

import 'package:boo/services/cloudinary_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/models/user_product_model.dart';

class SellService {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> sellSomething(UserProductModel productModel) async {
    final counterRef = firebaseFirestore.collection("counters").doc("products");

    final int newId = await firebaseFirestore.runTransaction((
      transaction,
    ) async {
      final counterSnap = await transaction.get(counterRef);

      int updatedId = 1;

      if (counterSnap.exists) {
        updatedId = (counterSnap.get("lastId") ?? 0) + 1;
      }

      transaction.set(counterRef, {"lastId": updatedId});

      return updatedId;
    });

    List<String> imageUrls = [];

    for (String image in productModel.images) {
      final uploadedUrl = await CloudinaryService().saveToCloudinary(
        File(image),
      );

      imageUrls.add(uploadedUrl ?? "");
    }

    await firebaseFirestore.collection("selling").doc(newId.toString()).set({
      "id": newId,
      "name": productModel.name,
      "desc": productModel.desc,
      "category": productModel.category,
      "size": productModel.size,
      "price": productModel.price,
      "contactNumber": productModel.contactNumber,
      "status": productModel.status,
      "userImage": productModel.userImage,
      "userName": productModel.userName,
      "images": imageUrls,
    });
  }

  Future<List<UserProductModel>> getUsersProducts() async {
    final snapshot = await firebaseFirestore
        .collection("selling")
        .orderBy("id", descending: true)
        .get();

    return snapshot.docs
        .map((doc) => UserProductModel.fromMap(doc.data()))
        .toList();
  }
}
