import 'package:cloud_firestore/cloud_firestore.dart';

class RateReviewModel {
  final double? rating;
  final String? review;
  final String? userName;
  final String? userImage;
  final Timestamp? createdAt;

  RateReviewModel({
    required this.rating,
    required this.review,
    this.userName,
    this.userImage,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      "rating": rating,
      "review": review,
      "username": userName,
      "userImage": userImage,
      "createdAt": createdAt,
    };
  }

  factory RateReviewModel.fromJson(Map<String, dynamic> json) {
    return RateReviewModel(
      rating: (json['rating'] as num).toDouble(),
      review: json['review'] ?? '',
      userName: json['username'] ?? '',
      userImage: json['userImage'] ?? '',
      createdAt: json['createdAt'] ?? Timestamp.now(),
    );
  }
}
