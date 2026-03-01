import 'package:boo/core/models/products_model.dart';
import 'package:boo/core/models/user_product_model.dart';
import 'package:equatable/equatable.dart';

class FavState extends Equatable {
  final List<ProductsModel> favourites;
  final List<UserProductModel> favouritesUsers;
  final bool isLoading;

  const FavState({
    this.favourites = const [],
    this.isLoading = false, this.favouritesUsers = const [],
  });

  FavState copyWith({
    List<ProductsModel>? favourites,
    List<UserProductModel>? favouritesUsers,
    bool? isLoading,
  }) {
    return FavState(
      favourites: favourites ?? this.favourites,
      isLoading: isLoading ?? this.isLoading,
      favouritesUsers: favouritesUsers ?? this.favouritesUsers
    );
  }

  @override
  List<Object?> get props => [favourites, isLoading,favouritesUsers];
}
