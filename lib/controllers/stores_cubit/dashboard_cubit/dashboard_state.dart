import 'package:boo/core/models/discount_model.dart';
import 'package:boo/core/models/products_model.dart';
import 'package:equatable/equatable.dart';

sealed class DashboardState extends Equatable {
  final bool isLoading;
  final bool isLoaded;
  final String error;
  final List<ProductsModel>? products;
  final List<DiscountModel>? discounts;
  final List<Map<String, dynamic>>? collections;
  final List<Map<String, dynamic>>? ads;
  final List<Map<String, dynamic>>? coupons;

  const DashboardState({
    required this.isLoading,
    required this.isLoaded,
    required this.error,
    this.products,
    this.discounts,
    this.collections,
    this.ads,
    this.coupons,
  });

  DashboardState copyWith({
    bool? isLoading,
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
        isLoading,
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
          isLoading: false,
          isLoaded: false,
          error: '',
          products: null,
          discounts: null,
          collections: null,
          coupons: null,
          ads: null,
        );

  @override
  DashboardState copyWith({
    bool? isLoading,
    bool? isLoaded,
    String? error,
    List<ProductsModel>? products,
    List<DiscountModel>? discounts,
    List<Map<String, dynamic>>? collections,
    List<Map<String, dynamic>>? ads,
    List<Map<String, dynamic>>? coupons,
  }) {
    return DashboardSuccess(
      isLoading: isLoading ?? this.isLoading,
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
    required super.isLoading,
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
    bool? isLoading,
    bool? isLoaded,
    String? error,
    List<ProductsModel>? products,
    List<DiscountModel>? discounts,
    List<Map<String, dynamic>>? collections,
    List<Map<String, dynamic>>? ads,
    List<Map<String, dynamic>>? coupons,
  }) {
    return DashboardSuccess(
      isLoading: isLoading ?? this.isLoading,
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
