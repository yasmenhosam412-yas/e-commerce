import 'package:cloud_firestore/cloud_firestore.dart';

class RateReviewService {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addReviewRate({
    required double rating,
    required String review,
    required String username,
    required String userImage,
    required String productModelId,
    required String storeId,
  }) async {
    final productRef = firebaseFirestore
        .collection('featuredProducts')
        .doc(productModelId);

    final dashboardRef = firebaseFirestore
        .collection('dashboard')
        .doc(storeId)
        .collection('products')
        .doc(productModelId);

    final productReviewsRef = productRef.collection('reviews');
    final dashboardReviewsRef = dashboardRef.collection('reviews');

    await Future.wait([
      productReviewsRef.add({
        "rating": rating,
        "review": review,
        "username": username,
        "userImage": userImage,
        "createdAt": FieldValue.serverTimestamp(),
      }),
      dashboardReviewsRef.add({
        "rating": rating,
        "review": review,
        "username": username,
        "userImage": userImage,
        "createdAt": FieldValue.serverTimestamp(),
      }),
    ]);

    final snapshot = await productReviewsRef.get();
    double total = 0;
    for (var doc in snapshot.docs) {
      total += (doc['rating'] as num).toDouble();
    }

    final ratingAvg = snapshot.docs.isNotEmpty
        ? total / snapshot.docs.length
        : 0;

    await Future.wait([
      productRef.update({
        "ratingAvg": ratingAvg,
        "reviewsCount": snapshot.docs.length,
      }),
      dashboardRef.update({
        "ratingAvg": ratingAvg,
        "reviewsCount": snapshot.docs.length,
      }),
    ]);
  }
}
