import 'package:bloc/bloc.dart';
import 'package:boo/core/models/order_model.dart';
import 'package:boo/core/services/error_handler.dart';
import 'package:boo/services/orders_service.dart';
import 'package:meta/meta.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersService ordersService;

  OrdersCubit(this.ordersService) : super(OrdersInitial());

  Future<void> getOrders() async {
    emit(OrdersLoading());
    try {
      final result = await ordersService.getOrders();
      emit(OrdersLoaded(orders: result));
    } catch (e) {
      emit(OrdersError(error: ErrorHandler.fromException(e).message));
    }
  }
}
