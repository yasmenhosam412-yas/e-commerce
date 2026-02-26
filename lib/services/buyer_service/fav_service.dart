import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/models/products_model.dart';

class FavService {
  Future<void> toggleFav(ProductsModel product) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    
    final uid = user.uid;
    final favRef = FirebaseFirestore.instance.collection("favourites").doc(uid);

    final doc = await favRef.get();
    final productMap = product.toMap();

    if (doc.exists) {
      final List products = doc.data()?['products'] ?? [];

      final existingProduct = products.firstWhere(
        (e) => e['id'] == product.id,
        orElse: () => null,
      );

      if (existingProduct != null) {
        await favRef.update({
          "products": FieldValue.arrayRemove([existingProduct]),
        });
      } else {
        await favRef.update({
          "products": FieldValue.arrayUnion([productMap]),
        });
      }
    } else {
      await favRef.set({
        "products": [productMap],
      });
    }
  }

  Future<List<ProductsModel>> getFavourites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final doc = await FirebaseFirestore.instance
        .collection("favourites")
        .doc(user.uid)
        .get();
        
    if (doc.exists) {
      final data = doc.data();
      final List products = data?['products'] ?? [];
      return products
          .map(
            (e) => ProductsModel.fromMap(
              e,
              e['id']?.toString() ?? '0',
            ),
          )
          .toList();
    } else {
      return [];
    }
  }
}
