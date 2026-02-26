import 'package:bloc/bloc.dart';
import 'package:boo/core/models/products_model.dart';
import 'package:boo/services/buyer_service/fav_service.dart';
import 'fav_state.dart';

class FavCubit extends Cubit<FavState> {
  final FavService favService;

  FavCubit(this.favService) : super(const FavState());

  Future<void> toggleFav(ProductsModel product) async {
    try {
      emit(state.copyWith(isLoading: true));

      await favService.toggleFav(product);

      final currentFavs = List<ProductsModel>.from(state.favourites);

      if (currentFavs.contains(product)) {
        currentFavs.remove(product);
      } else {
        currentFavs.add(product);
      }

      emit(state.copyWith(favourites: currentFavs, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> getAllFavourites() async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await favService.getFavourites();
      emit(state.copyWith(favourites: result, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, favourites: []));
    }
  }

  bool isFavourite(ProductsModel product) {
    return state.favourites.contains(product);
  }
}
