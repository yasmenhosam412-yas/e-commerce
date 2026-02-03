import 'package:bloc/bloc.dart';
import 'package:boo/core/models/create_store_model.dart';
import 'package:boo/core/services/error_handler.dart';
import 'package:boo/services/store_creation_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

part 'store_creation_state.dart';

class StoreCreationCubit extends Cubit<StoreCreationState> {
  final StoreCreationService storeCreationService;
  final FlutterSecureStorage flutterSecureStorage;

  StoreCreationCubit({
    required this.flutterSecureStorage,
    required this.storeCreationService,
  }) : super(StoreCreationState.initial());

  Future<void> storeCreation({required CreateStoreModel storeData}) async {
    emit(state.copyWith(isLoading: true, error: null, isSuccess: false));

    try {
      await storeCreationService.createSteps(
        selectedName: storeData.selectedName,
        selectedDesc: storeData.selectedDesc,
        selectedCat: storeData.selectedCat,
        selectedPhone: storeData.selectedPhone,
        selectedEmail: storeData.selectedEmail,
        selectedAddress: storeData.selectedAddress,
        selectedFees: storeData.selectedFees,
        selectedDelivery: storeData.selectedDelivery,
        selectedImage: storeData.selectedImage,
      );

      await _saveStoreData(
        storeData.selectedName,
        storeData.selectedDesc,
        storeData.selectedCat,
        storeData.selectedPhone,
        storeData.selectedEmail,
        storeData.selectedAddress,
        storeData.selectedFees,
        storeData.selectedDelivery,
        storeData.selectedImage,
      );

      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: ErrorHandler.fromException(e).message,
        ),
      );
    }
  }

  Future<void> hasStore() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final result = await storeCreationService.hasStore();
      emit(state.copyWith(isLoading: false, hasStore: result));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: ErrorHandler.fromException(e).message,
        ),
      );
    }
  }

  Future<void> storeData() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final result = await storeCreationService.getStore();

      if (result != null) {
        await _saveStoreData(
          result.selectedName,
          result.selectedDesc,
          result.selectedCat,
          result.selectedPhone,
          result.selectedEmail,
          result.selectedAddress,
          result.selectedFees,
          result.selectedDelivery,
          result.selectedImage,
        );
      }

      emit(state.copyWith(isLoading: false, store: result));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: ErrorHandler.fromException(e).message,
        ),
      );
    }
  }

  Future<void> _saveStoreData(
    String selectedName,
    String selectedDesc,
    String selectedCat,
    String selectedPhone,
    String selectedEmail,
    String selectedAddress,
    String selectedFees,
    String selectedDelivery,
    String selectedImage,
  ) async {
    await flutterSecureStorage.write(key: "name", value: selectedName);
    await flutterSecureStorage.write(key: "desc", value: selectedDesc);
    await flutterSecureStorage.write(key: "category", value: selectedCat);
    await flutterSecureStorage.write(key: "phone", value: selectedPhone);
    await flutterSecureStorage.write(key: "email", value: selectedEmail);
    await flutterSecureStorage.write(key: "address", value: selectedAddress);
    await flutterSecureStorage.write(key: "fees", value: selectedFees);
    await flutterSecureStorage.write(key: "delivery", value: selectedDelivery);
    await flutterSecureStorage.write(key: "image", value: selectedImage);
    await flutterSecureStorage.write(key: "hasStore", value: "true");
  }
}
