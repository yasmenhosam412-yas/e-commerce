import 'dart:io';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:boo/core/services/error_handler.dart';
import 'package:boo/services/store_service.dart';

import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final StoreService storeService;

  DashboardCubit(this.storeService) : super(const DashboardInitial());

  Future<void> addProduct(
    String image,
    String name,
    String desc,
    String price,
    String category,
    String quantity,
    List<String> sizes,
  ) async {
    emit(DashboardSuccess(isLoading: true, isLoaded: false, error: ''));

    try {
      await storeService.addProduct(
        image,
        name,
        desc,
        price,
        category,
        quantity,
        sizes,
      );

      emit(DashboardSuccess(isLoading: false, isLoaded: true, error: ''));
    } catch (e) {
      emit(
        DashboardSuccess(
          isLoading: false,
          isLoaded: false,
          error: ErrorHandler.fromException(e).message,
        ),
      );
    }
  }

  Future<void> addCollection(String name, String desc) async {
    emit(DashboardSuccess(isLoading: true, isLoaded: false, error: ''));

    try {
      await storeService.addCollection(name, desc);

      emit(DashboardSuccess(isLoading: false, isLoaded: true, error: ''));
    } catch (e) {
      emit(
        DashboardSuccess(
          isLoading: false,
          isLoaded: false,
          error: ErrorHandler.fromException(e).message,
        ),
      );
    }
  }

  Future<void> addDiscount(
    String name,
    String value,
    String start,
    String end,
  ) async {
    emit(DashboardSuccess(isLoading: true, isLoaded: false, error: ''));

    try {
      await storeService.addDiscount(name, value, start, end);

      emit(DashboardSuccess(isLoading: false, isLoaded: true, error: ''));
    } catch (e) {
      emit(
        DashboardSuccess(
          isLoading: false,
          isLoaded: false,
          error: ErrorHandler.fromException(e).message,
        ),
      );
    }
  }

  Future<void> addAds(
    File image,
    String badgeText,
    String position,
    String badgeColor,
    String textColor,
  ) async {
    emit(DashboardSuccess(isLoading: true, isLoaded: false, error: ''));

    try {
      await storeService.addAds(
        image,
        badgeText,
        position,
        badgeColor,
        textColor,
      );

      emit(DashboardSuccess(isLoading: false, isLoaded: true, error: ''));
    } catch (e) {
      emit(
        DashboardSuccess(
          isLoading: false,
          isLoaded: false,
          error: ErrorHandler.fromException(e).message,
        ),
      );
    }
  }

  Future<void> updateProduct({
    required String productId,
    String? image,
    String? name,
    String? desc,
    double? price,
    String? category,
    int? quantity,
    List<String>? sizes,
    String? collectionName,
    String? discount,
    double? newPrice,
    bool? isFeatured,
  }) async {
    emit(state.copyWith(isLoading: true, isLoaded: false, error: ''));

    try {
      await storeService.updateProduct(
        productId: productId,
        image: image,
        name: name,
        desc: desc,
        price: price,
        category: category,
        quantity: quantity,
        sizes: sizes,
        collectionName: collectionName,
        discount: discount,
        newPrice: newPrice,
        isFeatured: isFeatured,
      );

      emit(state.copyWith(isLoading: false, isLoaded: true, error: ''));
    } catch (e) {
      print(e);
      emit(
        state.copyWith(
          isLoading: false,
          isLoaded: false,
          error: ErrorHandler.fromException(e).message,
        ),
      );
    }
  }

  Future<void> getDiscount() async {
    emit(DashboardSuccess(isLoading: true, isLoaded: false, error: ''));

    try {
      final result = await storeService.getDiscounts();

      emit(
        state.copyWith(
          isLoading: false,
          isLoaded: true,
          error: '',
          discounts: result,
        ),
      );
    } catch (e) {
      emit(
        DashboardSuccess(
          isLoading: false,
          isLoaded: false,
          error: ErrorHandler.fromException(e).message,
        ),
      );
    }
  }

  Future<void> getCollection() async {
    emit(DashboardSuccess(isLoading: true, isLoaded: false, error: ''));

    try {
      final result = await storeService.getCollections();

      emit(
        state.copyWith(
          isLoading: false,
          isLoaded: true,
          error: '',
          collections: result,
        ),
      );
    } catch (e) {
      emit(
        DashboardSuccess(
          isLoading: false,
          isLoaded: false,
          error: ErrorHandler.fromException(e).message,
        ),
      );
    }
  }

  Future<void> getProducts() async {
    emit(DashboardSuccess(isLoading: true, isLoaded: false, error: ''));

    try {
      final result = await storeService.getProducts();

      emit(
        state.copyWith(
          isLoading: false,
          isLoaded: true,
          error: '',
          products: result,
        ),
      );
    } catch (e) {
      emit(
        DashboardSuccess(
          isLoading: false,
          isLoaded: false,
          error: ErrorHandler.fromException(e).message,
        ),
      );
    }
  }
}
