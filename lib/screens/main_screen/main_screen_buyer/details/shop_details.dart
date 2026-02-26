import 'package:boo/controllers/stores_cubit/dashboard_cubit/dashboard_cubit.dart';
import 'package:boo/controllers/stores_cubit/dashboard_cubit/dashboard_state.dart';
import 'package:boo/core/models/products_model.dart';
import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/core/utils/app_padding.dart';
import 'package:boo/core/widgets/custom_drop_down.dart';
import 'package:boo/l10n/app_localizations.dart';
import 'package:boo/screens/main_screen/main_screen_buyer/details/product_details.dart';
import 'package:boo/screens/main_screen/main_screen_buyer/tabs/home_tab/widgets/product_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/services/get_init.dart';
import '../../../../core/services/navigation_service.dart';

class ShopDetails extends StatefulWidget {
  final String shopId;
  final String shopName;
  final String shopImage;
  final String category;

  const ShopDetails({
    super.key,
    required this.shopId,
    required this.shopName,
    required this.shopImage,
    required this.category,
  });

  @override
  State<ShopDetails> createState() => _ShopDetailsState();
}

class _ShopDetailsState extends State<ShopDetails> {
  int selectedIndex = 0;
  int selectedIndexCollection = 0;

  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().getProducts(widget.shopId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            if (state.isLoading) {
              return Skeletonizer(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppPadding.medium),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(24),
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundImage: NetworkImage(widget.shopImage),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              "${widget.shopName} - ${widget.category}",
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      height: 45,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final isSelected = selectedIndex == index;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primaryColor
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  "categories",
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 16),
                    SizedBox(
                      height: 45,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final isSelected = selectedIndexCollection == index;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndexCollection = index;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primaryColor
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  "collections",
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: 8,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 0.72,
                            ),
                        itemBuilder: (context, index) {
                          return ProductClothesItem(
                            image: "placeholder",
                            name: "placeholder",
                            price: 0.0,
                            rating: 0,
                            productModel: ProductsModel(
                              id: 0,
                              image: "",
                              images: [],
                              name: "name",
                              desc: "",
                              price: 0,
                              category: "",
                              quantity: 0,
                              sizes: [],
                              attributes: {},
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }

            final products = state.products ?? [];

            if (products.isEmpty) {
              return Center(child: Text(AppLocalizations.of(context)!.noData));
            }

            final categories = products.map((e) => e.category).toSet().toList();

            final selectedCategory = categories[selectedIndex];

            final collections = products
                .where((e) => e.category == selectedCategory)
                .map((e) => e.collectionName ?? "")
                .where((e) => e.isNotEmpty)
                .toSet()
                .toList();

            final filteredProducts = products
                .where((e) => e.category == selectedCategory)
                .toList();

            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppPadding.medium),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(24),
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundImage: NetworkImage(widget.shopImage),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          "${widget.shopName} - ${widget.category}",
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  height: 45,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final isSelected = selectedIndex == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryColor
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              categories[index],
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),
                SizedBox(
                  height: 45,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: collections.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final isSelected = selectedIndexCollection == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndexCollection = index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryColor
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              collections[index],
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredProducts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.72,
                        ),
                    itemBuilder: (context, index) {
                      final item = filteredProducts[index];

                      return GestureDetector(
                        onTap: () {
                          getIt<NavigationService>().navigatePush(
                            ProductDetails(
                              productsModel: item.copyWith(
                                storeImage: widget.shopImage,
                                storeName: widget.shopName,
                              ),
                            ),
                          );
                        },
                        child: ProductClothesItem(
                          image: item.image ?? "",
                          name: item.name ?? "",
                          price: item.newPrice ?? item.price ?? 0.0,
                          rating: 0,
                          oldPrice: item.newPrice != item.price
                              ? item.price
                              : null, productModel: item,
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
