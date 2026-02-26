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
        .get();

    return result.exists;
  }

  Future<CreateStoreModel?> getStore(String uid) async {
    final result = await firebaseFirestore
        .collection('stores')
        .doc(uid)
        .get();
    final isExist = await hasStore();

    if (isExist) {
      final name = result.get("name");
      final description = result.get("description");
      final category = result.get("category");
      final phone = result.get("phone");
      final email = result.get("email");
      final address = result.get("address");
      final fees = result.get("fees");
      final delivery = result.get("delivery");
      final image = result.get("image");
      return CreateStoreModel(
        selectedName: name,
        selectedDesc: description,
        selectedCat: category,
        selectedPhone: phone,
        selectedEmail: email,
        selectedAddress: address,
        selectedFees: fees,
        selectedDelivery: delivery,
        selectedImage: image,
      );
    }
    return null;
  }
}
