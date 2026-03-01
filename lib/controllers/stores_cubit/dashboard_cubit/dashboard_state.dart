import 'package:boo/core/models/discount_model.dart';
import 'package:boo/core/models/products_model.dart';
import 'package:equatable/equatable.dart';

sealed class DashboardState extends Equatable {
  final bool isLoadingProducts;
  final bool isLoadingDiscounts;
  final bool isLoadingCollections;
  final bool isLoadingAds;
  final bool isLoadingCoupons;
  final bool isLoadingAction;
  
  final bool isLoaded;
  final String error;
  final List<ProductsModel>? products;
  final List<DiscountModel>? discounts;
  final List<Map<String, dynamic>>? collections;
  final List<Map<String, dynamic>>? ads;
  final List<Map<String, dynamic>>? coupons;

  bool get isLoading =>
      isLoadingProducts ||
      isLoadingDiscounts ||
      isLoadingCollections ||
      isLoadingAds ||
      isLoadingCoupons ||
      isLoadingAction;

  const DashboardState({
    this.isLoadingProducts = false,
    this.isLoadingDiscounts = false,
    this.isLoadingCollections = false,
    this.isLoadingAds = false,
    this.isLoadingCoupons = false,
    this.isLoadingAction = false,
    required this.isLoaded,
    required this.error,
    this.products,
    this.discounts,
    this.collections,
    this.ads,
    this.coupons,
  });

  DashboardState copyWith({
    bool? isLoadingProducts,
    bool? isLoadingDiscounts,
    bool? isLoadingCollections,
    bool? isLoadingAds,
    bool? isLoadingCoupons,
    bool? isLoadingAction,
    bool? isLoaded,
    String? error,
    List<ProductsModel>? products,
    List<DiscountModel>? discounts,
    List<Map<String, dynamic>>? collections,
    List<Map<String, dynamic>>? ads,
    List<Map<String, dynamic>>? coupons,
  });

  @override
  List<Object?> get props => [
        isLoadingProducts,
        isLoadingDiscounts,
        isLoadingCollections,
        isLoadingAds,
        isLoadingCoupons,
        isLoadingAction,
        isLoaded,
        error,
        products,
        discounts,
        ads,
        collections,
        coupons,
      ];
}

final class DashboardInitial extends DashboardState {
  const DashboardInitial()
      : super(
          isLoaded: false,
          error: '',
        );

  @override
  DashboardState copyWith({
    bool? isLoadingProducts,
    bool? isLoadingDiscounts,
    bool? isLoadingCollections,
    bool? isLoadingAds,
    bool? isLoadingCoupons,
    bool? isLoadingAction,
    bool? isLoaded,
    String? error,
    List<ProductsModel>? products,
    List<DiscountModel>? discounts,
    List<Map<String, dynamic>>? collections,
    List<Map<String, dynamic>>? ads,
    List<Map<String, dynamic>>? coupons,
  }) {
    return DashboardSuccess(
      isLoadingProducts: isLoadingProducts ?? this.isLoadingProducts,
      isLoadingDiscounts: isLoadingDiscounts ?? this.isLoadingDiscounts,
      isLoadingCollections: isLoadingCollections ?? this.isLoadingCollections,
      isLoadingAds: isLoadingAds ?? this.isLoadingAds,
      isLoadingCoupons: isLoadingCoupons ?? this.isLoadingCoupons,
      isLoadingAction: isLoadingAction ?? this.isLoadingAction,
      isLoaded: isLoaded ?? this.isLoaded,
      error: error ?? this.error,
      products: products ?? this.products,
      discounts: discounts ?? this.discounts,
      collections: collections ?? this.collections,
      ads: ads ?? this.ads,
      coupons: coupons ?? this.coupons,
    );
  }
}

final class DashboardSuccess extends DashboardState {
  const DashboardSuccess({
    super.isLoadingProducts,
    super.isLoadingDiscounts,
    super.isLoadingCollections,
    super.isLoadingAds,
    super.isLoadingCoupons,
    super.isLoadingAction,
    required super.isLoaded,
    required super.error,
    super.products,
    super.discounts,
    super.ads,
    super.collections,
    super.coupons,
  });

  @override
  DashboardSuccess copyWith({
    bool? isLoadingProducts,
    bool? isLoadingDiscounts,
    bool? isLoadingCollections,
    bool? isLoadingAds,
    bool? isLoadingCoupons,
    bool? isLoadingAction,
    bool? isLoaded,
    String? error,
    List<ProductsModel>? products,
    List<DiscountModel>? discounts,
    List<Map<String, dynamic>>? collections,
    List<Map<String, dynamic>>? ads,
    List<Map<String, dynamic>>? coupons,
  }) {
    return DashboardSuccess(
      isLoadingProducts: isLoadingProducts ?? this.isLoadingProducts,
      isLoadingDiscounts: isLoadingDiscounts ?? this.isLoadingDiscounts,
      isLoadingCollections: isLoadingCollections ?? this.isLoadingCollections,
      isLoadingAds: isLoadingAds ?? this.isLoadingAds,
      isLoadingCoupons: isLoadingCoupons ?? this.isLoadingCoupons,
      isLoadingAction: isLoadingAction ?? this.isLoadingAction,
      isLoaded: isLoaded ?? this.isLoaded,
      error: error ?? this.error,
      products: products ?? this.products,
      discounts: discounts ?? this.discounts,
      collections: collections ?? this.collections,
      ads: ads ?? this.ads,
      coupons: coupons ?? this.coupons,
    );
  }
}
