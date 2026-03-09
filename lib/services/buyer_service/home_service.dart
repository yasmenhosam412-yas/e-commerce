import 'package:boo/core/models/create_store_model.dart';
import 'package:boo/core/models/products_model.dart';
import 'package:boo/core/models/rate_review_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeService {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<List<ProductsModel>> getFeaturedPicks() async {
    final snapshot = await firebaseFirestore
        .collection("featuredProducts")
        .get();

    return Future.wait(
      snapshot.docs.map((doc) async {
        final data = doc.data();

        final store = await getShopById(data['storeId']);

        return ProductsModel.fromMap({
          ...data,
          "id": doc.id,
          "storeId": data['storeId'],
          "storeName": store?.selectedName ?? '',
          "storeImage": store?.selectedImage ?? '',
        }, doc.id);
      }).toList(),
    );
  }

  Future<List<RateReviewModel>> getReviews(String id) async {
    final snapshot = await firebaseFirestore.collection("featuredProducts").doc(id).collection("reviews").get();

    return snapshot.docs.map((doc) {
      return RateReviewModel.fromJson(doc.data());
    }).toList();
  }

  Future<List<CreateStoreModel>> getStores() async {
    final snapshot = await firebaseFirestore.collection("stores").get();

    return snapshot.docs.map((doc) {
      return CreateStoreModel.fromJson({...doc.data(), "id": doc.id});
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getAds() async {
    final snapshot = await firebaseFirestore.collection("AllAds").get();

    return Future.wait(
      snapshot.docs.map((doc) async {
        final data = doc.data();

        final store = await getShopById(data['storeId']);

        return ({
          ...data,
          "id": doc.id,
          "storeId": data['storeId'],
          "storeName": store?.selectedName ?? '',
          "storeImage": store?.selectedImage ?? '',
        });
      }).toList(),
    );
  }

  Future<CreateStoreModel?> getShopById(String storeId) async {
    final doc = await firebaseFirestore.collection("stores").doc(storeId).get();

    if (!doc.exists) return null;

    return CreateStoreModel.fromJson(doc.data()!);
  }
}
