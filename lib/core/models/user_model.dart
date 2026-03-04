class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String photoURL;
  final String userType;

  final String phone;
  final String address;
  final String location;
  final String governorate;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.photoURL,
    required this.userType,
    required this.phone,
    required this.address,
    required this.location,
    required this.governorate,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? map['name'] ?? '',
      photoURL: map['photoURL'] ?? map['image'] ?? '',
      userType: map['userType'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      location: map['location'] ?? '',
      governorate: map['governorate'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "email": email,
      "displayName": displayName,
      "photoURL": photoURL,
      "userType": userType,
      "phone": phone,
      "address": address,
      "location": location,
      "governorate": governorate,
    };
  }
}