import 'package:bloc/bloc.dart';
import 'package:boo/core/models/create_store_model.dart';
import 'package:boo/core/models/products_model.dart';
import 'package:boo/core/models/rate_review_model.dart';
import 'package:boo/core/services/error_handler.dart';
import 'package:boo/services/buyer_service/home_service.dart';
import 'package:equatable/equatable.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeService homeService;

  HomeCubit(this.homeService) : super(HomeState());

  Future<void> getFeaturedPicks() async {
    emit(state.copyWith(isLoadingF: true));
    try {
      final result = await homeService.getFeaturedPicks();
      emit(state.copyWith(featuredProducts: result, isLoadingF: false));
    } catch (e) {
      emit(
        state.copyWith(
          errorF: ErrorHandler.fromException(e).message,
          isLoadingF: false,
        ),
      );
    }
  }

  Future<void> getReviewOfProducts(String id) async {
    emit(state.copyWith(isLoadingR: true));
    try {
      final result = await homeService.getReviews(id);
      emit(state.copyWith(review: result, isLoadingR: false));
    } catch (e) {
      emit(
        state.copyWith(
          errorR: ErrorHandler.fromException(e).message,
          isLoadingR: false,
        ),
      );
    }
  }

  Future<void> getStores() async {
    emit(state.copyWith(isLoadingS: true));
    try {
      final result = await homeService.getStores();
      emit(state.copyWith(stores: result, isLoadingS: false));
    } catch (e) {
      emit(
        state.copyWith(
          errorS: ErrorHandler.fromException(e).message,
          isLoadingS: false,
        ),
      );
    }
  }

  Future<void> getAds() async {
    emit(state.copyWith(isLoadingAds: true));
    try {
      final result = await homeService.getAds();
      emit(state.copyWith(ads: result, isLoadingAds: false));
    } catch (e) {
      emit(
        state.copyWith(
          errorAds: ErrorHandler.fromException(e).message,
          isLoadingAds: false,
        ),
      );
    }
  }
}
