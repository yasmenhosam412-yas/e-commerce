part of 'review_cubit.dart';

@immutable
sealed class ReviewState {}

final class ReviewInitial extends ReviewState {}

final class ReviewLoading extends ReviewState {}

final class ReviewAdded extends ReviewState {}

final class ReviewError extends ReviewState {
  final String error;

  ReviewError({required this.error});
}
