part of 'checkout_cubit.dart';

@immutable
sealed class CheckoutState {}

final class CheckoutInitial extends CheckoutState {}

final class CheckoutLoading extends CheckoutState {}

final class CancelOrderLoading extends CheckoutState {
  final String orderId;

  CancelOrderLoading({required this.orderId});
}

final class CheckoutLoaded extends CheckoutState {}

final class CheckoutLoadedOrders extends CheckoutState {
  final List<OrderModel> orders;

  CheckoutLoadedOrders({required this.orders});
}

final class CheckoutError extends CheckoutState {
  final String error;

  CheckoutError({required this.error});
}
