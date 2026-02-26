import 'package:boo/core/models/products_model.dart';
import 'package:equatable/equatable.dart';

class FavState extends Equatable {
  final List<ProductsModel> favourites;
  final bool isLoading;

  const FavState({
    this.favourites = const [],
    this.isLoading = false,
  });

  FavState copyWith({
    List<ProductsModel>? favourites,
    bool? isLoading,
  }) {
    return FavState(
      favourites: favourites ?? this.favourites,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [favourites, isLoading];
}
