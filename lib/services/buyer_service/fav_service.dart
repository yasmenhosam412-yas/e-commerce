import 'package:boo/core/models/user_product_model.dart';
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
      final List products = doc.data()?['shop_products'] ?? [];

      final existingProduct = products.firstWhere(
        (e) => e['id']?.toString() == product.id.toString(),
        orElse: () => null,
      );

      if (existingProduct != null) {
        await favRef.update({
          "shop_products": FieldValue.arrayRemove([existingProduct]),
        });
      } else {
        await favRef.update({
          "shop_products": FieldValue.arrayUnion([productMap]),
        });
      }
    } else {
      await favRef.set({
        "shop_products": [productMap],
      });
    }
  }

  Future<void> toggleUserFav(UserProductModel product) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final uid = user.uid;
    final favRef = FirebaseFirestore.instance.collection("favourites").doc(uid);

    final doc = await favRef.get();
    final productMap = product.toMap();

    if (doc.exists) {
      final List products = doc.data()?['user_products'] ?? [];

      final existingProduct = products.firstWhere(
        (e) => e['id']?.toString() == product.id.toString(),
        orElse: () => null,
      );

      if (existingProduct != null) {
        await favRef.update({
          "user_products": FieldValue.arrayRemove([existingProduct]),
        });
      } else {
        await favRef.update({
          "user_products": FieldValue.arrayUnion([productMap]),
        });
      }
    } else {
      await favRef.set({
        "user_products": [productMap],
      });
    }
  }

  Future<Map<String, List>> getFavourites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {"shop_products": [], "user_products": []};

    final doc = await FirebaseFirestore.instance
        .collection("favourites")
        .doc(user.uid)
        .get();

    if (doc.exists) {
      final data = doc.data();
      final List shopProductsData = data?['shop_products'] ?? [];
      final List userProductsData = data?['user_products'] ?? [];

      final List<ProductsModel> shopProducts = shopProductsData
          .map(
            (e) => ProductsModel.fromMap(
              e,
              e['id']?.toString() ?? '0',
            ),
          )
          .toList();

      final List<UserProductModel> userProducts = userProductsData
          .map(
            (e) => UserProductModel.fromMap(e),
          )
          .toList();

      return {
        "shop_products": shopProducts,
        "user_products": userProducts,
      };
    } else {
      return {"shop_products": [], "user_products": []};
    }
  }
}
