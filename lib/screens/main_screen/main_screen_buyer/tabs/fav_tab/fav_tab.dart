import 'package:boo/controllers/fav_cubit/fav_cubit.dart';
import 'package:boo/controllers/fav_cubit/fav_state.dart';
import 'package:boo/core/models/products_model.dart';
import 'package:boo/core/models/user_product_model.dart';
import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/services/get_init.dart';
import '../../../../../core/services/navigation_service.dart';
import '../../details/product_details.dart';
import '../../details/product_details_user.dart';
import '../home_tab/widgets/product_mixed_widget.dart';

class FavTab extends StatefulWidget {
  const FavTab({super.key});

  @override
  State<FavTab> createState() => _FavTabState();
}

class _FavTabState extends State<FavTab> {
  @override
  void initState() {
    super.initState();
    context.read<FavCubit>().getAllFavourites();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.favs,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.primaryColor),
          ),
          bottom: TabBar(
            isScrollable: false,
            indicatorSize: TabBarIndicatorSize.tab,
            padding: const EdgeInsets.all(8),
            tabs: [
              Tab(text: AppLocalizations.of(context)!.shops),
              Tab(text: AppLocalizations.of(context)!.users),
            ],
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<FavCubit, FavState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                );
              }
              return TabBarView(
                children: [
                  _FavGridShop(
                    ownerType: ProductOwnerType.store,
                    productsModel: state.favourites,
                  ),
                  _FavGridUser(
                    ownerType: ProductOwnerType.user,
                    productsModel: state.favouritesUsers,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FavGridShop extends StatelessWidget {
  final ProductOwnerType ownerType;
  final List<ProductsModel> productsModel;

  const _FavGridShop({required this.ownerType, required this.productsModel});

  @override
  Widget build(BuildContext context) {
    return (productsModel.isNotEmpty)
        ? GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: ownerType == ProductOwnerType.store
                  ? 0.9
                  : 0.68,
            ),
            itemCount: productsModel.length,
            itemBuilder: (context, index) {
              final item = productsModel[index];
              return GestureDetector(
                onTap: () {
                  getIt<NavigationService>().navigatePush(
                    ProductDetails(productsModel: item),
                  );
                },
                child: ProductItem(
                  ownerType: ownerType,
                  image: item.image,
                  name: item.name,
                  price: item.newPrice ?? item.price,
                  oldPrice: item.newPrice != null ? item.price : null,
                  rating: 0,
                  reviewsCount: 0,
                  productModel: item,
                ),
              );
            },
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.remove_shopping_cart_outlined,
                  size: 80,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.nothingFavs,
                  style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                ),
              ],
            ),
          );
  }
}

class _FavGridUser extends StatelessWidget {
  final ProductOwnerType ownerType;
  final List<UserProductModel> productsModel;

  const _FavGridUser({required this.ownerType, required this.productsModel});

  @override
  Widget build(BuildContext context) {
    return (productsModel.isNotEmpty)
        ? GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: ownerType == ProductOwnerType.store
                  ? 0.9
                  : 0.68,
            ),
            itemCount: productsModel.length,
            itemBuilder: (context, index) {
              final item = productsModel[index];
              return GestureDetector(
                onTap: () {
                  getIt<NavigationService>().navigatePush(
                    ProductDetailsUser(userProductModel: item),
                  );
                },
                child: ProductItem(
                  ownerType: ownerType,
                  image: item.images.isNotEmpty ? item.images.first : '',
                  name: item.name,
                  price: double.tryParse(item.price) ?? 0.0,
                  oldPrice: null,
                  rating: 0,
                  reviewsCount: 0,
                  userProductModel: item,
                  isUsed: item.status == "Used",
                  sellerName: item.userName,
                  sellerAvatar: item.userImage,
                ),
              );
            },
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.remove_shopping_cart_outlined,
                  size: 80,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.nothingFavs,
                  style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                ),
              ],
            ),
          );
  }
}
