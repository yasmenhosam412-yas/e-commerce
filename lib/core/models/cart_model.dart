import 'package:boo/core/models/products_model.dart';
import 'create_store_model.dart';

class CartModel {
  final String id;
  final ProductsModel productsModel;
  final CreateStoreModel createStoreModel;
  final String? selectedSize;
  final Map<String, String> selectedOptions;
  final int quantity;

  CartModel({
    required this.productsModel,
    required this.createStoreModel,
    required this.id,
    this.selectedSize,
    this.selectedOptions = const {},
    this.quantity = 1,
  });

  CartModel copyWith({
    String? id,
    ProductsModel? productsModel,
    CreateStoreModel? createStoreModel,
    String? selectedSize,
    Map<String, String>? selectedOptions,
    int? quantity,
  }) {
    return CartModel(
      id: id ?? this.id,
      productsModel: productsModel ?? this.productsModel,
      createStoreModel: createStoreModel ?? this.createStoreModel,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedOptions: selectedOptions ?? this.selectedOptions,
      quantity: quantity ?? this.quantity,
    );
  }

  factory CartModel.fromMap(Map<String, dynamic> map, String docId) {
    return CartModel(
      id: docId,
      productsModel: ProductsModel.fromMap(
        map['product'],
        map['product']['id'].toString(),
      ),
      createStoreModel: CreateStoreModel.fromJson(map['store']),
      selectedSize: map['selectedSize'],
      selectedOptions: Map<String, String>.from(map['selectedOptions'] ?? {}),
      quantity: map['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "product": productsModel.toMap(),
      "store": createStoreModel.toJson(),
      "selectedSize": selectedSize,
      "selectedOptions": selectedOptions,
      "quantity": quantity,
    };
  }
}
