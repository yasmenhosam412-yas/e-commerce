import 'package:boo/controllers/fav_cubit/fav_cubit.dart';
import 'package:boo/controllers/fav_cubit/fav_state.dart';
import 'package:boo/core/models/products_model.dart';
import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/services/get_init.dart';
import '../../../../../core/services/navigation_service.dart';
import '../../details/product_details.dart';
import '../home_tab/widgets/product_mixed_widget.dart';

class FavTab extends StatelessWidget {
  const FavTab({super.key});

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
            padding: EdgeInsets.all(8),
            tabs: [
              Tab(text: AppLocalizations.of(context)!.shops),
              Tab(text: AppLocalizations.of(context)!.users),
            ],
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<FavCubit, FavState>(
            builder: (context, state) {
              return TabBarView(
                children: [
                  _FavGridShop(ownerType: ProductOwnerType.store, productsModel: state.favourites,),
                  _FavGridUser(ownerType: ProductOwnerType.user, productsModel: state.favourites,),
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
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: ownerType == ProductOwnerType.store ? 0.9 : 0.68,
      ),
      itemCount: productsModel.length,
      itemBuilder: (context, index) {
        final item =productsModel[index];
        return GestureDetector(
          onTap: () {
            getIt<NavigationService>().navigatePush(ProductDetails(productsModel: item,));
          },
          child: ProductItem(
            ownerType: ownerType,
            image:item.image,
            name: item.name,
            price: item.newPrice ?? item.price,
            oldPrice: item.price,
            rating: 0,
            reviewsCount: 0,
            productModel: item,
          ),
        );
      },
    );
  }
}
class _FavGridUser extends StatelessWidget {
  final ProductOwnerType ownerType;
  final List<ProductsModel> productsModel;

  const _FavGridUser({required this.ownerType, required this.productsModel});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: ownerType == ProductOwnerType.store ? 0.9 : 0.68,
      ),
      itemCount: productsModel.length,
      itemBuilder: (context, index) {
        final item =productsModel[index];
        return GestureDetector(
          onTap: () {
            getIt<NavigationService>().navigatePush(ProductDetails(productsModel: item,));
          },
          child: ProductItem(
            ownerType: ownerType,
            image:item.image,
            name: item.name,
            price: item.newPrice ?? item.price,
            oldPrice: item.price,
            rating: 0,
            reviewsCount: 0,
            productModel: item,
            isUsed: true,
            sellerName: "User",
            sellerAvatar: "https://i.pravatar.cc/150",
            sellerRating: 0,
            sellerSalesCount: 0,
          ),
        );
      },
    );
  }
}
