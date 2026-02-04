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
    };
  }
}
