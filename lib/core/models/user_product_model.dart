import 'package:equatable/equatable.dart';

class UserProductModel extends Equatable {
  final String id;
  final String name;
  final List<String> images;
  final String desc;
  final String category;
  final String size;
  final String price;
  final String contactNumber;
  final String status;
  final String userName;
  final String userImage;

  const UserProductModel({
    required this.id,
    required this.name,
    required this.desc,
    required this.category,
    required this.size,
    required this.price,
    required this.contactNumber,
    required this.status,
    required this.userName,
    required this.userImage,
    required this.images,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        images,
        desc,
        category,
        size,
        price,
        contactNumber,
        status,
        userName,
        userImage,
      ];

  factory UserProductModel.fromMap(Map<String, dynamic> map) {
    return UserProductModel(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? '',
      desc: map['desc'] ?? '',
      category: map['category'] ?? '',
      size: map['size'] ?? '',
      price: map['price'] ?? '',
      contactNumber: map['contactNumber'] ?? '',
      status: map['status'] ?? '',
      userName: map['userName'] ?? '',
      userImage: map['userImage'] ?? '',
      images: List<String>.from(map['images'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "desc": desc,
      "category": category,
      "size": size,
      "price": price,
      "contactNumber": contactNumber,
      "status": status,
      "userName": userName,
      "userImage": userImage,
      "images": images,
    };
  }
}
