class ProductsModel {
  final int id;
  final String image;
  final String name;
  final String desc;
  final double price;
  final String category;
  final int quantity;
  final List<String> sizes;
  final bool? isFeatured;
  final String? collectionName;
  final double? newPrice;
  final String? discount;

  ProductsModel({
    required this.id,
    required this.image,
    required this.name,
    required this.desc,
    required this.price,
    required this.category,
    required this.quantity,
    required this.sizes,
    this.isFeatured,
    this.collectionName,
    this.newPrice,
    this.discount,
  });

  factory ProductsModel.fromMap(Map<String, dynamic> map) {
    return ProductsModel(
      id: map['id'],
      image: map['image'] ?? '',
      name: map['name'] ?? '',
      desc: map['desc'] ?? '',
      price: (map['price'] ?? ""),
      category: map['category'] ?? '',
      quantity: (map['quantity'] ?? "0"),
      sizes: List<String>.from(map['sizes'] ?? []),
      newPrice: map['newPrice'],
      discount: map['discount'],
      collectionName: map['collectionName'],
      isFeatured: map['isFeatured'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'name': name,
      'desc': desc,
      'price': price,
      'category': category,
      'quantity': quantity,
      'sizes': sizes,
      'isFeatured': isFeatured,
      'collectionName': collectionName,
      'newPrice': newPrice,
      'discount': discount,
    };
  }
}
