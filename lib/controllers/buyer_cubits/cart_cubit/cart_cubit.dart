import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:boo/core/models/cart_model.dart';
import 'package:boo/core/services/error_handler.dart';
import '../../../services/buyer_service/cart_service.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartService cartService;

  CartCubit(this.cartService) : super(CartInitial());

  List<CartModel> cartItems = [];
  final Map<String, Timer> _debounceTimers = {};

  Future<void> loadCart({bool showLoading = true}) async {
    try {
      if (showLoading) {
        emit(CartLoading());
      }

      cartItems = await cartService.getCart();

      emit(CartLoaded(items: List.from(cartItems)));
    } catch (e) {
      emit(CartError(ErrorHandler.fromException(e).message));
    }
  }

  Future<void> addItem(CartModel model) async {
    await cartService.addItemToCart(model);
    await loadCart(showLoading: false);
  }

  Future<void> updateQuantity(String cartItemId, int quantity) async {
    final index = cartItems.indexWhere((item) => item.id == cartItemId);
    if (index != -1) {
      final oldItem = cartItems[index];

      cartItems[index] = oldItem.copyWith(quantity: quantity);
      emit(CartLoaded(items: List.from(cartItems)));

      _debounceTimers[cartItemId]?.cancel();
      _debounceTimers[cartItemId] = Timer(
        const Duration(milliseconds: 500),
        () async {
          try {
            await cartService.updateItemQuantity(cartItemId, quantity);
          } catch (e) {
            emit(CartError(ErrorHandler.fromException(e).message));
            await loadCart(showLoading: false);
          } finally {
            _debounceTimers.remove(cartItemId);
          }
        },
      );
    }
  }

  Future<void> deleteItem(String cartItemId) async {
    final index = cartItems.indexWhere((item) => item.id == cartItemId);
    if (index != -1) {
      final removedItem = cartItems.removeAt(index);
      emit(CartLoaded(items: List.from(cartItems)));

      try {
        await cartService.deleteItemFromCart(cartItemId);
      } catch (e) {
        cartItems.insert(index, removedItem);
        emit(CartLoaded(items: List.from(cartItems)));
        emit(CartError(ErrorHandler.fromException(e).message));
      }
    }
  }

  Future<void> clearCart(String cartId) async {
    final oldItems = List<CartModel>.from(cartItems);
    cartItems.where((e) => e.id == cartId).toList().clear();
    emit(CartLoaded(items: []));

    try {
      for (var item in oldItems) {
        await cartService.deleteItemFromCart(item.id);
      }
    } catch (e) {
      cartItems = oldItems;
      emit(CartLoaded(items: List.from(cartItems)));
      emit(CartError(ErrorHandler.fromException(e).message));
    }
  }

  @override
  Future<void> close() {
    for (final timer in _debounceTimers.values) {
      timer.cancel();
    }
    return super.close();
  }
}
