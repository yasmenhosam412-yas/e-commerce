class SocialAuthResult {
  final bool success;
  final String? userType;
  final String? errorCode;

  SocialAuthResult({
    required this.success,
    this.userType,
    this.errorCode,
  });

  factory SocialAuthResult.success(String userType) {
    return SocialAuthResult(success: true, userType: userType);
  }

  factory SocialAuthResult.failure(String code) {
    return SocialAuthResult(success: false, errorCode: code);
  }
}
