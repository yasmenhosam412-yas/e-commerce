class CreateStoreModel {
  final String selectedName;
  final String selectedDesc;
  final String selectedCat;
  final String selectedPhone;
  final String selectedEmail;
  final String selectedAddress;
  final String selectedFees;
  final String selectedDelivery;
  final String selectedImage;
  final String? id;
  final bool isDelivery;
  final List<String>? deliveryGovernorates;
  final String? deliveryTime;
  final String? deliveryInfo;

  CreateStoreModel({
    required this.selectedName,
    required this.selectedDesc,
    required this.selectedCat,
    required this.selectedPhone,
    required this.selectedEmail,
    required this.selectedAddress,
    required this.selectedFees,
    required this.selectedDelivery,
    required this.selectedImage,
    this.id,
    this.isDelivery = false,
    this.deliveryGovernorates,
    this.deliveryTime,
    this.deliveryInfo,
  });

  factory CreateStoreModel.fromJson(Map<String, dynamic> json) {
    return CreateStoreModel(
      selectedName: json['name'] ?? '',
      selectedDesc: json['description'] ?? '',
      selectedCat: json['category'] ?? '',
      selectedPhone: json['phone'] ?? '',
      selectedEmail: json['email'] ?? '',
      selectedAddress: json['address'] ?? '',
      selectedFees: json['fees'] ?? '',
      selectedDelivery: json['delivery'] ?? '',
      selectedImage: json['image'] ?? '',
      id: json['id'],
      isDelivery: json['is_delivery'] ?? false,
      deliveryGovernorates: json['delivery_governorates'] != null
          ? List<String>.from(json['delivery_governorates'].map((e) => e.toString()))
          : null,
      deliveryTime: json['delivery_time'],
      deliveryInfo: json['delivery_info'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': selectedName,
      'description': selectedDesc,
      'category': selectedCat,
      'phone': selectedPhone,
      'email': selectedEmail,
      'address': selectedAddress,
      'fees': selectedFees,
      'delivery': selectedDelivery,
      'image': selectedImage,
      "id": id,
      'is_delivery': isDelivery,
      'delivery_governorates': deliveryGovernorates,
      'delivery_time': deliveryTime,
      'delivery_info': deliveryInfo,
    };
  }
}
