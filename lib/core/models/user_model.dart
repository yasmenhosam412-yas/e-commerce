class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String photoURL;
  final String userType;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.photoURL,
    required this.userType,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      photoURL: map['photoURL'] ?? '',
      userType: map['userType'] ?? '',
    );
  }
}