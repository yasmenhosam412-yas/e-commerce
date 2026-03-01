import 'package:boo/core/models/cart_model.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartModel> items;

  CartLoaded({required this.items});
}

class CartError extends CartState {
  final String message;

  CartError(this.message);
}
