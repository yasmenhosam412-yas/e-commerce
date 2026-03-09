part of 'home_cubit.dart';

class HomeState extends Equatable {
  final List<ProductsModel>? featuredProducts;
  final List<CreateStoreModel>? stores;
  final List<RateReviewModel>? review;
  final List<Map<String, dynamic>>? ads;
  final bool? isLoadingR;
  final bool? isLoadingF;
  final bool? isLoadingS;
  final bool? isLoadingAds;
  final String? errorR;
  final String? errorF;
  final String? errorS;
  final String? errorAds;

  const HomeState({
    this.featuredProducts,
    this.isLoadingF,
    this.errorF,
    this.ads,
    this.isLoadingAds,
    this.errorAds,
    this.stores,
    this.isLoadingS,
    this.errorS, this.review, this.isLoadingR, this.errorR,
  });

  HomeState copyWith({
    List<ProductsModel>? featuredProducts,
    bool? isLoadingF,
    String? errorF,
    List<Map<String, dynamic>>? ads,
    bool? isLoadingAds,
    String? errorAds,
    List<CreateStoreModel>? stores,
    bool? isLoadingS,
    String? errorS,
    List<RateReviewModel>? review,
    bool? isLoadingR,
    String? errorR,
  }) {
    return HomeState(
      featuredProducts: featuredProducts ?? this.featuredProducts,
      isLoadingF: isLoadingF ?? this.isLoadingF,
      errorF: errorF ?? this.errorF,
      ads: ads ?? this.ads,
      isLoadingAds: isLoadingAds ?? this.isLoadingAds,
      errorAds: errorAds ?? this.errorAds,
      stores: stores ?? this.stores,
      isLoadingS: isLoadingS ?? this.isLoadingS,
      errorS: errorS ?? this.errorS,
      review: review ?? this.review,
      isLoadingR: isLoadingR ?? this.isLoadingR,
      errorR: errorR ?? this.errorR,
    );
  }

  @override
  List<Object?> get props => [
    featuredProducts,
    isLoadingF,
    errorF,
    ads,
    isLoadingAds,
    errorAds,
    stores,
    isLoadingS,
    errorS,
    review,
    isLoadingR,
    errorR,
  ];
}
