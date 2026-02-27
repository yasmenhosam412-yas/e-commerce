part of 'sell_cubit.dart';

class SellState extends Equatable {
  const SellState();

  @override
  List<Object?> get props => [];
}

final class SellLoading extends SellState {
  @override
  List<Object> get props => [];
}

final class SellLoaded extends SellState {
  final List<UserProductModel> userProducts;

  SellLoaded({required this.userProducts});
  @override
  List<Object> get props => [];
}

final class SellError extends SellState {
  final String error;

  const SellError({required this.error});

  @override
  List<Object> get props => [error];
}
