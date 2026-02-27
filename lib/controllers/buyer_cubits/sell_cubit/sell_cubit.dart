import 'package:bloc/bloc.dart';
import 'package:boo/core/models/user_product_model.dart';
import 'package:boo/core/services/error_handler.dart';
import 'package:boo/services/buyer_service/sell_servcie.dart';
import 'package:equatable/equatable.dart';

part 'sell_state.dart';

class SellCubit extends Cubit<SellState> {
  final SellService sellServcie;

  SellCubit(this.sellServcie) : super(SellState());

  Future<void> sellSomething(UserProductModel userProduct) async {
    emit(SellLoading());
    try {
      await sellServcie.sellSomething(userProduct);
      final result = await sellServcie.getUsersProducts();
      emit(SellLoaded(userProducts: result));
    } catch (e) {
      emit(SellError(error: ErrorHandler.fromException(e).message));
    }
  }

  Future<void> getSell() async {
    emit(SellLoading());
    try {
      final result = await sellServcie.getUsersProducts();
      emit(SellLoaded(userProducts: result));
    } catch (e) {
      emit(SellError(error: ErrorHandler.fromException(e).message));
    }
  }
}
