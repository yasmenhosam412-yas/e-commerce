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
    required String selectedName,
    required String selectedDesc,
    required String selectedCat,
    required String selectedPhone,
    required String selectedEmail,
    required String selectedAddress,
    required String selectedFees,
    required String selectedDelivery,
    required String selectedImage,
    required bool isDelivery,
    List<String>? deliveryGovernorates,
    String? deliveryTime,
    String? deliveryInfo,
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
          'is_delivery': isDelivery,
          'delivery_governorates': deliveryGovernorates,
          'delivery_time': deliveryTime,
          'delivery_info': deliveryInfo,
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

    final data = result.data();
    if (data == null) return null;

    return CreateStoreModel.fromJson(data);
  }
}
