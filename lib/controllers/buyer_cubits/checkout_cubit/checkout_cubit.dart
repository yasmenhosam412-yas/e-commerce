import 'package:bloc/bloc.dart';
import 'package:boo/core/models/coupon_code.dart' show CouponCode;
import 'package:boo/core/models/order_model.dart';
import 'package:boo/core/models/user_model.dart';
import 'package:boo/core/services/error_handler.dart';
import 'package:boo/services/buyer_service/checkout_service.dart';
import 'package:meta/meta.dart';

import '../../../core/models/cart_model.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final CheckoutService checkoutService;

  CheckoutCubit(this.checkoutService) : super(CheckoutInitial());

  Future<void> createOrder(List<CartModel> cart, String total,bool withCoupon,UserModel userModel) async {
    emit(CheckoutLoading());
    try {
      await checkoutService.createOrder(cart, total,withCoupon,userModel);
      emit(CheckoutLoaded());
    } catch (e) {
      emit(CheckoutError(error: ErrorHandler.fromException(e).message));
    }
  }

  Future<void> updateOrderStatus(
    String storeId,
    String orderId,
    String userId,
    String newStatus,
  ) async {
    emit(CheckoutLoading());
    try {
      await checkoutService.updateOrderStatus(storeId, orderId,userId, newStatus);
      emit(CheckoutLoaded());
    } catch (e) {
      emit(CheckoutError(error: ErrorHandler.fromException(e).message));
    }
  }

  Future<void> cancelOrder(String storeId, String orderId) async {
    emit(CancelOrderLoading(orderId: orderId));
    try {
      await checkoutService.cancelOrder(storeId, orderId);
      emit(CheckoutLoaded());
    } catch (e) {
      emit(CheckoutError(error: ErrorHandler.fromException(e).message));
    }
  }

  Future<void> getStoreOrders(String storeId) async {
    emit(CheckoutLoading());
    try {
      final orders = await checkoutService.getStoreOrdersOnce(storeId);
      emit(CheckoutLoadedOrders(orders: orders));
    } catch (e) {
      emit(CheckoutError(error: ErrorHandler.fromException(e).message));
    }
  }

  Future<void> getUserOrders() async {
    emit(CheckoutLoading());
    try {
      final orders = await checkoutService.getUserOrdersOnce();
      emit(CheckoutLoadedOrders(orders: orders));
    } catch (e) {
      emit(CheckoutError(error: ErrorHandler.fromException(e).message));
    }
  }

  Future<void> applyCoupon(String code, String storeId) async {
    emit(CheckoutLoading());
    try {
      final result = await checkoutService.applyCoupon(code, storeId);
      emit(CheckoutCouponApplied(couponCode: result));
    } catch (e) {
      emit(CheckoutError(error: ErrorHandler.fromException(e).message));
    }
  }
}
