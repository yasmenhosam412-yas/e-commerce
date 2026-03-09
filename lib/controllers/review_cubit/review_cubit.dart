import 'package:bloc/bloc.dart';
import 'package:boo/core/services/error_handler.dart';
import 'package:boo/services/buyer_service/rate_review_service.dart';
import 'package:meta/meta.dart';

part 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final RateReviewService rateReviewService;

  ReviewCubit(this.rateReviewService) : super(ReviewInitial());

  Future<void> addRate(
    double rating,
    String review,
    String productModelId,
    String storeId,
    String username,
    String userImage,
  ) async {
    emit(ReviewLoading());
    try {
      await rateReviewService.addReviewRate(
        rating: rating,
        review: review,
        productModelId: productModelId,
        storeId: storeId,
        username: username,
        userImage: userImage,
      );
      emit(ReviewAdded());
    } catch (e) {
      emit(ReviewError(error: ErrorHandler.fromException(e).message));
    }
  }
}
