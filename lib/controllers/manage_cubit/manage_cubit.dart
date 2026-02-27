import 'package:bloc/bloc.dart';
import 'package:boo/core/models/create_store_model.dart';
import 'package:boo/core/models/user_model.dart';
import 'package:boo/core/services/error_handler.dart';
import 'package:boo/services/auth_service.dart';
import 'package:boo/services/store_creation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

part 'manage_state.dart';

class ManageCubit extends Cubit<ManageState> {
  final StoreCreationService storeCreationService;
  final AuthService authService;

  ManageCubit(this.storeCreationService, {required this.authService})
    : super(ManageInitial());

  Future<void> userTypeAndStore() async {
    emit(ManageLoading());
    try {
      FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
      String? userType = await flutterSecureStorage.read(key: "userType");
      final user = await authService.getUserData();
      if (userType == "seller") {
        final hasStore = await checkHasStore();
        final storeData = await getStoreData(
          FirebaseAuth.instance.currentUser!.uid,
        );

        if (hasStore == false) {
          emit(
            ManageLoaded(userType: "seller", hasStore: false, userModel: user),
          );
        } else {
          emit(
            ManageLoaded(
              userType: "seller",
              hasStore: true,
              createStoreModel: storeData,
              userModel: user,
            ),
          );
        }
      } else {
        emit(ManageLoaded(userType: "buyer", userModel: user));
      }
    } on FirebaseException catch (e) {
      emit(ManageError(error: ErrorHandler.fromException(e).message));
    } catch (e) {
      emit(ManageError(error: ErrorHandler.fromException(e).message));
    }
  }

  Future<bool> checkHasStore() async {
    try {
      return await storeCreationService.hasStore();
    } catch (e) {
      rethrow;
    }
  }

  Future<CreateStoreModel?> getStoreData(String uid) async {
    try {
      return await storeCreationService.getStore(uid);
    } catch (e) {
      rethrow;
    }
  }
}
