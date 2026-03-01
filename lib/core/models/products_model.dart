import 'package:boo/core/models/create_store_model.dart';
import 'package:equatable/equatable.dart';

class ProductsModel extends Equatable {
  final int id;
  final String image;
  final List<String> images;
  final String name;
  final String desc;
  final double price;
  final double? newPrice;
  final String category;
  final int quantity;
  final List<String> sizes;
  final Map<String, List<String>> attributes;

  final bool? isFeatured;
  final String? collectionName;
  final String? discount;
  final CreateStoreModel createStoreModel;
  final String storeId;

  const ProductsModel({
    required this.id,
    required this.image,
    required this.images,
    required this.name,
    required this.desc,
    required this.price,
    this.newPrice,
    required this.category,
    required this.quantity,
    required this.sizes,
    required this.attributes,
    this.isFeatured,
    this.collectionName,
    this.discount,
    required this.createStoreModel, required this.storeId,
  });

  @override
  List<Object?> get props => [
    id,
    image,
    images,
    name,
    desc,
    price,
    newPrice,
    category,
    quantity,
    sizes,
    attributes,
    isFeatured,
    collectionName,
    discount,
    createStoreModel,
  ];

  factory ProductsModel.fromMap(Map<String, dynamic> map, String docId) {
    return ProductsModel(
      id:
          int.tryParse(docId) ??
          (map['id'] is int
              ? map['id']
              : int.tryParse(map['id']?.toString() ?? '0') ?? 0),
      image: map['image'] ?? '',
      images: map['images'] != null ? List<String>.from(map['images']) : [],
      name: map['name'] ?? '',
      desc: map['desc'] ?? '',
      price: (map['price'] is int)
          ? (map['price'] as int).toDouble()
          : (map['price'] as num?)?.toDouble() ?? 0.0,
      newPrice: map['newPrice'] != null
          ? (map['newPrice'] as num).toDouble()
          : null,
      category: map['category'] ?? '',
      quantity: (map['quantity'] is int)
          ? map['quantity']
          : int.tryParse(map['quantity'].toString()) ?? 0,
      sizes: map['sizes'] != null ? List<String>.from(map['sizes']) : [],
      attributes: map['attributes'] != null
          ? Map<String, List<String>>.from(
              (map['attributes'] as Map).map(
                (key, value) =>
                    MapEntry(key.toString(), List<String>.from(value)),
              ),
            )
          : {},
      isFeatured: map['isFeatured'],
      collectionName: map['collectionName'],
      discount: map['discount'],
      createStoreModel: CreateStoreModel.fromJson(map['store']),
      storeId: map['storeId']
    );
  }

  ProductsModel copyWith({
    int? id,
    String? image,
    List<String>? images,
    String? name,
    String? desc,
    double? price,
    double? newPrice,
    String? category,
    int? quantity,
    List<String>? sizes,
    Map<String, List<String>>? attributes,
    bool? isFeatured,
    String? collectionName,
    String? discount,
    String? storeId,
    CreateStoreModel? createStoreModel
  }) {
    return ProductsModel(
      id: id ?? this.id,
      image: image ?? this.image,
      images: images ?? this.images,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      price: price ?? this.price,
      newPrice: newPrice ?? this.newPrice,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      sizes: sizes ?? this.sizes,
      attributes: attributes ?? this.attributes,
      isFeatured: isFeatured ?? this.isFeatured,
      collectionName: collectionName ?? this.collectionName,
      discount: discount ?? this.discount, createStoreModel: createStoreModel ?? this.createStoreModel,
      storeId: storeId ?? this
        .storeId
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'images': images,
      'name': name,
      'desc': desc,
      'price': price,
      'newPrice': newPrice,
      'category': category,
      'quantity': quantity,
      'sizes': sizes,
      'attributes': attributes,
      'isFeatured': isFeatured,
      'collectionName': collectionName,
      'discount': discount,
      'store': createStoreModel.toJson(),
      'storeId':storeId,
    };
  }
}
