import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
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
        body: const SafeArea(
          child: TabBarView(
            children: [
              _FavGrid(ownerType: ProductOwnerType.store),
              _FavGrid(ownerType: ProductOwnerType.user),
            ],
          ),
        ),
      ),
    );
  }
}

class _FavGrid extends StatelessWidget {
  final ProductOwnerType ownerType;

  const _FavGrid({required this.ownerType});

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
      itemCount: 5,
      itemBuilder: (context, index) {
        return ProductItem(
          ownerType: ownerType,
          image:
              "https://tse3.mm.bing.net/th/id/OIP.PTrMioI24oEhJ-NRvoTZcwHaE8?rs=1&pid=ImgDetMain&o=7&rm=3",
          name: "Summer T Shirt",
          price: 266,
          oldPrice: 280,
          rating: 4.2,
          reviewsCount: 6,
          isFavorite: true,
        );
      },
    );
  }
}
