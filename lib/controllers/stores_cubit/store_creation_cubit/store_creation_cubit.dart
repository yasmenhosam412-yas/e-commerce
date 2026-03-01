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
        isDelivery: storeData.isDelivery,
        deliveryGovernorates: storeData.deliveryGovernorates,
        deliveryTime: storeData.deliveryTime,
        deliveryInfo: storeData.deliveryInfo,
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
        storeData.isDelivery,
        storeData.deliveryGovernorates,
        storeData.deliveryTime,
        storeData.deliveryInfo,
      );

      emit(state.copyWith(isLoading: false, isSuccess: true, store: storeData));
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

  Future<CreateStoreModel?> storeData(String uid) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final result = await storeCreationService.getStore(uid);

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
          result.isDelivery,
          result.deliveryGovernorates,
          result.deliveryTime,
          result.deliveryInfo,
        );
      }

      emit(state.copyWith(isLoading: false, store: result));
      return result;
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: ErrorHandler.fromException(e).message,
        ),
      );
      return null;
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
    bool isDelivery,
    List<String>? deliveryGovernorates,
    String? deliveryTime,
    String? deliveryInfo,
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
    await flutterSecureStorage.write(
      key: "is_delivery",
      value: isDelivery.toString(),
    );
    if (deliveryGovernorates != null) {
      await flutterSecureStorage.write(
        key: "delivery_governorates",
        value: deliveryGovernorates.join(' , '),
      );
    }
    if (deliveryTime != null) {
      await flutterSecureStorage.write(
        key: "delivery_time",
        value: deliveryTime,
      );
    }
    if (deliveryInfo != null) {
      await flutterSecureStorage.write(
        key: "delivery_info",
        value: deliveryInfo,
      );
    }
    await flutterSecureStorage.write(key: "hasStore", value: "true");
  }
}
