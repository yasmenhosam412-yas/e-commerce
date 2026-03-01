import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:boo/core/models/create_store_model.dart';
import 'package:boo/core/services/error_handler.dart';
import 'package:boo/services/store_service.dart';

import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final StoreService storeService;

  DashboardCubit(this.storeService) : super(const DashboardInitial());

  Future<void> addProduct({
    required List<String> images,
    required String name,
    required String desc,
    required String price,
    required String category,
    required String quantity,
    required Map<String, List<String>> attributes,
    List<String>? sizes,
    required CreateStoreModel store,
    bool isFeatured = false,
  }) async {
    emit(state.copyWith(isLoadingAction: true, isLoaded: false, error: ''));

    try {
      await storeService.addProduct(
        images: images,
        name: name,
        desc: desc,
        price: price,
        category: category,
        quantity: quantity,
        attributes: attributes,
        sizes: sizes,
        store: store,
        isFeatured: isFeatured,
      );

      emit(state.copyWith(isLoadingAction: false, isLoaded: true, error: ''));
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingAction: false,
          isLoaded: false,
          error: ErrorHandler.fromException(e).message,
        ),
      );
    }
  }

  Future<void> addCollection(String name, String desc) async {
    emit(state.copyWith(isLoadingAction: true, isLoaded: false, error: ''));

    try {
      await storeService.addCollection(name, desc);

      emit(state.copyWith(isLoadingAction: false, isLoaded: true, error: ''));
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingAction: false,
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
    emit(state.copyWith(isLoadingAction: true, isLoaded: false, error: ''));

    try {
      await storeService.addDiscount(name, value, start, end);

      emit(state.copyWith(isLoadingAction: false, isLoaded: true, error: ''));
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingAction: false,
          isLoaded: false,
          error: ErrorHandler.fromException(e).message,
        ),
      );
    }
  }

  Future<void> addCoupon(
    String name,
    String value,
    String expiryDate,
    String type,
  ) async {
    emit(state.copyWith(isLoadingAction: true, isLoaded: false, error: ''));

    try {
      await storeService.addCoupon(name, value, expiryDate, type);

      emit(state.copyWith(isLoadingAction: false, isLoaded: true, error: ''));
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingAction: false,
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
      CreateStoreModel store
  ) async {
    emit(state.copyWith(isLoadingAction: true, isLoaded: false, error: ''));

    try {
      await storeService.addAds(
        image,
        badgeText,
        position,
        badgeColor,
        textColor,
        store,
      );

      emit(state.copyWith(isLoadingAction: false, isLoaded: true, error: ''));
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingAction: false,
          isLoaded: false,
          error: ErrorHandler.fromException(e).message,
        ),
      );
    }
  }

  Future<void> updateProduct({
    required String productId,
    List<String>? images,
    String? name,
    String? desc,
    double? price,
    String? category,
    int? quantity,
    List<String>? sizes,
    Map<String, List<String>>? attributes,
    String? collectionName,
    String? discount,
    double? newPrice,
    bool? isFeatured,
  }) async {
    emit(state.copyWith(isLoadingAction: true, isLoaded: false, error: ''));

    try {
      await storeService.updateProduct(
        productId: productId,
        images: images,
        name: name,
        desc: desc,
        price: price,
        category: category,
        quantity: quantity,
        sizes: sizes,
        attributes: attributes,
        collectionName: collectionName,
        discount: discount,
        newPrice: newPrice,
        isFeatured: isFeatured,
      );

      emit(state.copyWith(isLoadingAction: false, isLoaded: true, error: ''));
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingAction: false,
          isLoaded: false,
          error: ErrorHandler.fromException(e).message,
        ),
      );
    }
  }

  Future<void> getDiscount() async {
    emit(state.copyWith(isLoadingDiscounts: true, isLoaded: false, error: ''));

    try {
      final result = await storeService.getDiscounts();

      emit(
        state.copyWith(
          isLoadingDiscounts: false,
          isLoaded: true,
          error: '',
          discounts: result,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingDiscounts: false,
          isLoaded: false,
          error: ErrorHandler.fromException(e).message,
        ),
      );
    }
  }

  Future<void> getCollection() async {
    emit(state.copyWith(isLoadingCollections: true, isLoaded: false, error: ''));

    try {
      final result = await storeService.getCollections();

      emit(
        state.copyWith(
          isLoadingCollections: false,
          isLoaded: true,
          error: '',
          collections: result,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingCollections: false,
          isLoaded: false,
          error: ErrorHandler.fromException(e).message,
        ),
      );
    }
  }

  Future<void> getCoupons() async {
    emit(state.copyWith(isLoadingCoupons: true, isLoaded: false, error: ''));

    try {
      final result = await storeService.getCoupons();

      emit(
        state.copyWith(
          isLoadingCoupons: false,
          isLoaded: true,
          error: '',
          coupons: result,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingCoupons: false,
          isLoaded: false,
          error: ErrorHandler.fromException(e).message,
        ),
      );
    }
  }

  Future<void> deleteCollection(String collectionId) async {
    emit(state.copyWith(isLoadingAction: true, isLoaded: false, error: ''));

    try {
      await storeService.deleteCollection(collectionId);
      await getCollection();
      emit(state.copyWith(isLoadingAction: false, isLoaded: true, error: ''));
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingAction: false,
          isLoaded: false,
          error: ErrorHandler.fromException(e).message,
        ),
      );
    }
  }

  Future<void> deleteAds(String adID) async {
    emit(state.copyWith(isLoadingAction: true, isLoaded: false, error: ''));

    try {
      await storeService.deleteAd(adId: adID);
      await getAds();
      emit(state.copyWith(isLoadingAction: false, isLoaded: true, error: ''));
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingAction: false,
          isLoaded: false,
          error: ErrorHandler.fromException(e).message,
        ),
      );
    }
  }

  Future<void> deleteDiscount(String disId) async {
    emit(state.copyWith(isLoadingAction: true, isLoaded: false, error: ''));

    try {
      await storeService.deleteDiscount(disId);
      await getDiscount();
      emit(state.copyWith(isLoadingAction: false, isLoaded: true, error: ''));
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingAction: false,
          isLoaded: false,
          error: ErrorHandler.fromException(e).message,
        ),
      );
    }
  }

  Future<void> deleteCoupon(String couponId) async {
    emit(state.copyWith(isLoadingAction: true, isLoaded: false, error: ''));

    try {
      await storeService.deleteCoupon(couponId);
      await getAds();
      emit(state.copyWith(isLoadingAction: false, isLoaded: true, error: ''));
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingAction: false,
          isLoaded: false,
          error: ErrorHandler.fromException(e).message,
        ),
      );
    }
  }

  Future<void> getAds() async {
    emit(state.copyWith(isLoadingAds: true, isLoaded: false, error: ''));

    try {
      final ads = await storeService.getAds();
      emit(
        state.copyWith(
          isLoadingAds: false,
          isLoaded: true,
          error: '',
          ads: ads,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingAds: false,
          isLoaded: false,
          error: ErrorHandler.fromException(e).message,
        ),
      );
    }
  }

  Future<void> updateCollection(
    String collectionId,
    String name,
    String desc,
  ) async {
    emit(state.copyWith(isLoadingAction: true, isLoaded: false, error: ''));

    try {
      await storeService.updateCollection(
        collectionId: collectionId,
        name: name,
        description: desc,
      );

      emit(state.copyWith(isLoadingAction: false, isLoaded: true, error: ''));
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingAction: false,
          isLoaded: false,
          error: ErrorHandler.fromException(e).message,
        ),
      );
    }
  }

  Future<void> deleteProduct(String productId, String uid) async {
    emit(state.copyWith(isLoadingAction: true, isLoaded: false, error: ''));

    try {
      await storeService.deleteProduct(productId: productId);
      await getProducts(uid);
      emit(state.copyWith(isLoadingAction: false, isLoaded: true, error: ''));
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingAction: false,
          isLoaded: false,
          error: ErrorHandler.fromException(e).message,
        ),
      );
    }
  }

  Future<void> getProducts(String uid) async {
    emit(state.copyWith(isLoadingProducts: true, isLoaded: false, error: ''));

    try {
      final result = await storeService.getProducts(uid);

      emit(
        state.copyWith(
          isLoadingProducts: false,
          isLoaded: true,
          error: '',
          products: result,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingProducts: false,
          isLoaded: false,
          error: ErrorHandler.fromException(e).message,
        ),
      );
    }
  }
}
