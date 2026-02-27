import 'dart:io';
import 'package:boo/core/models/create_store_model.dart';
import 'package:boo/services/cloudinary_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StoreCreationService {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  CloudinaryService cloudinaryService = CloudinaryService();

  Future<void> createSteps({
    String selectedName = '',
    String selectedDesc = '',
    String selectedCat = '',
    String selectedPhone = '',
    String selectedEmail = '',
    String selectedAddress = '',
    String selectedFees = '',
    String selectedDelivery = '',
    String selectedImage = '',
  }) async {
    final imagePath = await cloudinaryService.saveToCloudinary(
      File(selectedImage),
    );

    await firebaseFirestore
        .collection('stores')
        .doc(firebaseAuth.currentUser!.uid)
        .set({
          'name': selectedName,
          'description': selectedDesc,
          'category': selectedCat,
          'phone': selectedPhone,
          'email': selectedEmail,
          'address': selectedAddress,
          'fees': selectedFees,
          'delivery': selectedDelivery,
          'image': imagePath,
        });
  }

  Future<bool> hasStore() async {
    final result = await firebaseFirestore
        .collection('stores')
        .doc(firebaseAuth.currentUser!.uid)
        .get(const GetOptions(source: Source.server));

    return result.exists;
  }

  Future<CreateStoreModel?> getStore(String uid) async {
    final result = await firebaseFirestore
        .collection('stores')
        .doc(uid)
        .get(const GetOptions(source: Source.server));

    if (!result.exists) return null;

    return CreateStoreModel(
      selectedName: result.get("name"),
      selectedDesc: result.get("description"),
      selectedCat: result.get("category"),
      selectedPhone: result.get("phone"),
      selectedEmail: result.get("email"),
      selectedAddress: result.get("address"),
      selectedFees: result.get("fees"),
      selectedDelivery: result.get("delivery"),
      selectedImage: result.get("image"),
    );
  }
}
