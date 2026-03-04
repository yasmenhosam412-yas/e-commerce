import 'dart:io';

import 'package:boo/core/models/user_model.dart';
import 'package:boo/services/cloudinary_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InfoService {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final CloudinaryService cloudinaryService = CloudinaryService();

  Future<UserModel> addMoreInfo(
      String image,
      String name,
      String phone,
      String address,
      String location,
      String governorate,
      ) async {
    final uid = firebaseAuth.currentUser!.uid;

    final imagePath =
    await cloudinaryService.saveToCloudinary(File(image));

    await firebaseFirestore.collection("users").doc(uid).update({
      "displayName": name,
      "phone": phone,
      "photoURL": imagePath,
      "address": address,
      "location": location,
      "governorate": governorate,
    });

    final doc =
    await firebaseFirestore.collection("users").doc(uid).get();

    return UserModel.fromMap(doc.data()!);
  }
}