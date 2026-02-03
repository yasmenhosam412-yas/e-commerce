import 'package:boo/core/models/social_auth_result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<SocialAuthResult> signUp(
    String email,
    String password,
    String userType,
    String name,
  ) async {
    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await saveUserData(userCredential.user!, userType, name);

    return SocialAuthResult(success: true, userType: userType);
  }

  Future<SocialAuthResult> login(String email, String password) async {
    final userCredential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final userDoc = firebaseFirestore
        .collection('users')
        .doc(userCredential.user!.uid);

    final snapshot = await userDoc.get();

    if (!snapshot.exists) {
      return SocialAuthResult(success: false);
    }

    final data = snapshot.data();

    return SocialAuthResult(success: true, userType: data?['userType']);
  }

  Future<void> forgotPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> saveUserData(User user, String userType, String name) async {
    final userDoc = firebaseFirestore.collection('users').doc(user.uid);
    final snapshot = await userDoc.get();

    if (!snapshot.exists) {
      await userDoc.set({
        'uid': user.uid,
        'email': user.email ?? '',
        'displayName': name,
        'photoURL': user.photoURL ?? '',
        'userType': userType,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }
}
