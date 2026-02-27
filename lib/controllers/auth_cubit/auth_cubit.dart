import 'package:bloc/bloc.dart';
import 'package:boo/services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import '../../core/services/error_handler.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;
  final FlutterSecureStorage flutterSecureStorage;

  AuthCubit({required this.authService, required this.flutterSecureStorage})
    : super(AuthInitial());

  Future<void> signInWithEmail(String email, String password) async {
    emit(AuthLoading());
    try {
      final result = await authService.login(email, password);
      await saveUserType(result.userType ?? "");

      emit(AuthLoaded(userType: result.userType ?? ""));
    } catch (e) {
      final error = ErrorHandler.fromException(e);
      emit(AuthError(error: error.message));
    }
  }

  Future<void> resetPassword(String email) async {
    emit(AuthLoading());
    try {
      await authService.forgotPassword(email);

      emit(AuthLoaded(userType: ''));
    } catch (e) {
      final error = ErrorHandler.fromException(e);
      emit(AuthError(error: error.message));
    }
  }

  Future<void> signupWithEmail(
    String email,
    String password,
    String userType,
    String name,
  ) async {
    emit(AuthLoading());
    try {
      final result = await authService.signUp(email, password, userType, name);
      await saveUserType(result.userType ?? "");

      emit(AuthLoaded(userType: result.userType ?? ""));
    } catch (e) {
      final error = ErrorHandler.fromException(e);
      emit(AuthError(error: error.message));
    }
  }

  Future<void> saveUserType(String userType) async {
    await flutterSecureStorage.write(key: "userType", value: userType);
  }
}
