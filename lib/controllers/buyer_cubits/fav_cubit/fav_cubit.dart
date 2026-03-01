import 'package:bloc/bloc.dart';
import 'package:boo/core/models/products_model.dart';
import 'package:boo/core/models/user_product_model.dart';
import 'package:boo/services/buyer_service/fav_service.dart';
import 'fav_state.dart';

class FavCubit extends Cubit<FavState> {
  final FavService favService;

  FavCubit(this.favService) : super(const FavState());

  Future<void> toggleFav(ProductsModel product) async {
    try {
      final currentFavs = List<ProductsModel>.from(state.favourites);
      final isExisting = currentFavs.any((e) => e.id == product.id);

      if (isExisting) {
        currentFavs.removeWhere((e) => e.id == product.id);
      } else {
        currentFavs.add(product);
      }
      
      emit(state.copyWith(favourites: currentFavs));
      await favService.toggleFav(product);
    } catch (e) {
      // Rollback if needed or show error
      getAllFavourites();
    }
  }

  Future<void> toggleUserFav(UserProductModel product) async {
    try {
      final currentFavs = List<UserProductModel>.from(state.favouritesUsers);
      final isExisting = currentFavs.any((e) => e.id == product.id);

      if (isExisting) {
        currentFavs.removeWhere((e) => e.id == product.id);
      } else {
        currentFavs.add(product);
      }

      emit(state.copyWith(favouritesUsers: currentFavs));
      await favService.toggleUserFav(product);
    } catch (e) {
      // Rollback
      getAllFavourites();
    }
  }

  Future<void> getAllFavourites() async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await favService.getFavourites();
      emit(state.copyWith(
        favourites: List<ProductsModel>.from(result['shop_products'] ?? []),
        favouritesUsers: List<UserProductModel>.from(result['user_products'] ?? []),
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  bool isFavourite(ProductsModel product) {
    return state.favourites.any((e) => e.id == product.id);
  }

  bool isUserFavourite(UserProductModel product) {
    return state.favouritesUsers.any((e) => e.id == product.id);
  }
}
