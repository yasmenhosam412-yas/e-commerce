import 'dart:io';

import 'package:bloc/bloc.dart';
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
    required String storeImage,
    required String storeName,
    required String storeCategory,
    required String quantity,
    required Map<String, List<String>> attributes,
    List<String>? sizes,
  }) async {
    emit(state.copyWith(isLoading: true, isLoaded: false, error: ''));

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
        storeImage: storeImage,
        storeName: storeName,
        storeCategory: storeCategory,
      );

      emit(state.copyWith(isLoading: false, isLoaded: true, error: ''));
    } catch (e) {
      emit(
        state.copyWith(
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

  Future<void> addCoupon(
    String name,
    String value,
    String expiryDate,
    String type,
  ) async {
    emit(DashboardSuccess(isLoading: true, isLoaded: false, error: ''));

    try {
      await storeService.addCoupon(name, value, expiryDate, type);

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
    String storeName,
    String storeImage,
    String storeCategory,
  ) async {
    emit(DashboardSuccess(isLoading: true, isLoaded: false, error: ''));

    try {
      await storeService.addAds(
        image,
        badgeText,
        position,
        badgeColor,
        textColor,
        storeName,
        storeCategory,
        storeImage,
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

    List<String>? images, // NEW
    String? name,
    String? desc,
    double? price,
    String? category,
    int? quantity,
    List<String>? sizes, // legacy
    Map<String, List<String>>? attributes, // NEW

    String? collectionName,
    String? discount,
    double? newPrice,
    bool? isFeatured,
  }) async {
    emit(state.copyWith(isLoading: true, isLoaded: false, error: ''));

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

      emit(state.copyWith(isLoading: false, isLoaded: true, error: ''));
    } catch (e) {
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

  Future<void> getCoupons() async {
    emit(DashboardSuccess(isLoading: true, isLoaded: false, error: ''));

    try {
      final result = await storeService.getCoupons();

      emit(
        state.copyWith(
          isLoading: false,
          isLoaded: true,
          error: '',
          coupons: result,
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

  Future<void> deleteCollection(String collectionId) async {
    emit(DashboardSuccess(isLoading: true, isLoaded: false, error: ''));

    try {
      await storeService.deleteCollection(collectionId);
      await getCollection();
      emit(state.copyWith(isLoading: false, isLoaded: true, error: ''));
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

  Future<void> deleteAds(String adID) async {
    emit(DashboardSuccess(isLoading: true, isLoaded: false, error: ''));

    try {
      await storeService.deleteAd(adId: adID);
      await getAds();
      emit(state.copyWith(isLoading: false, isLoaded: true, error: ''));
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

  Future<void> deleteDiscount(String disId) async {
    emit(DashboardSuccess(isLoading: true, isLoaded: false, error: ''));

    try {
      await storeService.deleteDiscount(disId);
      await getDiscount();
      emit(state.copyWith(isLoading: false, isLoaded: true, error: ''));
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

  Future<void> deleteCoupon(String couponId) async {
    emit(DashboardSuccess(isLoading: true, isLoaded: false, error: ''));

    try {
      await storeService.deleteCoupon(couponId);
      await getAds();
      emit(state.copyWith(isLoading: false, isLoaded: true, error: ''));
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

  Future<void> getAds() async {
    emit(DashboardSuccess(isLoading: true, isLoaded: false, error: ''));

    try {
      final ads = await storeService.getAds();
      emit(
        state.copyWith(isLoading: false, isLoaded: true, error: '', ads: ads),
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

  Future<void> updateCollection(
    String collectionId,
    String name,
    String desc,
  ) async {
    emit(DashboardSuccess(isLoading: true, isLoaded: false, error: ''));

    try {
      await storeService.updateCollection(
        collectionId: collectionId,
        name: name,
        description: desc,
      );

      emit(state.copyWith(isLoading: false, isLoaded: true, error: ''));
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

  Future<void> deleteProduct(String productId, String uid) async {
    emit(DashboardSuccess(isLoading: true, isLoaded: false, error: ''));

    try {
      await storeService.deleteProduct(productId: productId);
      await getProducts(uid);
      emit(state.copyWith(isLoading: false, isLoaded: true, error: ''));
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

  Future<void> getProducts(String uid) async {
    emit(DashboardSuccess(isLoading: true, isLoaded: false, error: ''));

    try {
      final result = await storeService.getProducts(uid);

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
