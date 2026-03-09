import 'package:boo/controllers/buyer_cubits/cart_cubit/cart_cubit.dart';
import 'package:boo/controllers/buyer_cubits/cart_cubit/cart_state.dart';
import 'package:boo/core/models/cart_model.dart';
import 'package:boo/core/models/products_model.dart';
import 'package:boo/core/services/get_init.dart';
import 'package:boo/core/services/navigation_service.dart';
import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/core/utils/app_padding.dart';
import 'package:boo/core/widgets/cached_image_widget.dart';
import 'package:boo/l10n/app_localizations.dart';
import 'package:boo/screens/authentication/widgets/gredient_button.dart';
import 'package:boo/screens/main_screen/main_screen_buyer/details/helpers/store_helper.dart';
import 'package:boo/screens/main_screen/main_screen_buyer/details/widgets/size_selector.dart';
import 'package:boo/screens/main_screen/main_screen_buyer/details/widgets/store_info.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../controllers/buyer_cubits/fav_cubit/fav_cubit.dart';
import '../../../../controllers/buyer_cubits/fav_cubit/fav_state.dart';

class ProductDetails extends StatefulWidget {
  final ProductsModel productsModel;

  const ProductDetails({super.key, required this.productsModel});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  String? selectedSize;
  Map<String, String> selectedAttributes = {};
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.productsModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.name,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w500,
            fontSize: 24,
          ),
        ),
        surfaceTintColor: Colors.transparent,
        actions: [
          BlocSelector<FavCubit, FavState, bool>(
            selector: (state) {
              return state.favourites.any((e) => e.id == product.id);
            },
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: () {
                    context.read<FavCubit>().toggleFav(product);
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: Icon(
                      state ? Icons.favorite : Icons.favorite_border,
                      size: 24,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppPadding.medium,
              children: [
                (product.images.isNotEmpty)
                    ? CarouselSlider(
                        items: List.generate(product.images.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                AppPadding.medium,
                              ),
                              child: CachedImageWidget(
                                imagePath: product.images[index],
                              ),
                            ),
                          );
                        }),
                        options: CarouselOptions(
                          autoPlay: true,
                          enableInfiniteScroll: false,
                          aspectRatio: 1.2,
                        ),
                      )
                    : CarouselSlider(
                        items: List.generate(1, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                AppPadding.medium,
                              ),
                              child: CachedImageWidget(
                                imagePath: product.image,
                              ),
                            ),
                          );
                        }),
                        options: CarouselOptions(
                          autoPlay: true,
                          enableInfiniteScroll: false,
                          aspectRatio: 1.2,
                        ),
                      ),
                SizedBox(height: AppPadding.medium),
                Text(
                  AppLocalizations.of(context)!.storeInfo,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
                StoreInfoWidget(product: product),
                SizedBox(height: AppPadding.medium),
                Text(
                  AppLocalizations.of(context)!.productDescription,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
                Text(
                  product.desc,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade800),
                ),
                SizedBox(height: AppPadding.medium),
                Text(
                  AppLocalizations.of(context)!.productPrice,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.newPrice != null
                              ? "${product.newPrice!.toStringAsFixed(0)} ${AppLocalizations.of(context)!.currency}"
                              : "${product.price.toStringAsFixed(0)} ${AppLocalizations.of(context)!.currency}",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                                fontSize: 20,
                              ),
                        ),
                        if (product.newPrice != null) SizedBox(height: 4),
                        if (product.newPrice != null &&
                            product.newPrice != product.price)
                          Text(
                            "${product.price.toStringAsFixed(0)} ${AppLocalizations.of(context)!.currency}",
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Colors.grey.shade800,
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 16,
                                ),
                          ),
                      ],
                    ),
                    Spacer(),
                    if (product.discount != "No Discount" &&
                        product.discount != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.shade700,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.redAccent.withValues(alpha: 0.4),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          "${product.discount} ${AppLocalizations.of(context)!.off}",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: AppPadding.medium),
                Text(
                  AppLocalizations.of(context)!.productQuantity,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
                Row(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          color: (product.quantity < 3)
                              ? Colors.redAccent.shade700
                              : AppColors.primaryColor,
                          size: 20,
                        ),
                        SizedBox(width: AppPadding.medium),
                        Text(
                          "${product.quantity} ${AppLocalizations.of(context)!.item}",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: (product.quantity < 3)
                                    ? Colors.redAccent.shade700
                                    : AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    Spacer(),
                    (widget.productsModel.createStoreModel.isDelivery)
                        ? Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (quantity > 1) {
                                      setState(() {
                                        quantity--;
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    Icons.remove,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                Text(
                                  quantity.toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    if (quantity < product.quantity) {
                                      setState(() {
                                        quantity++;
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
                if (product.sizes.isNotEmpty) ...[
                  SizedBox(height: AppPadding.medium),
                  Text(
                    AppLocalizations.of(context)!.productSizes,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                  SizeSelector(
                    sizes: product.sizes,
                    onSizeSelected: (size) {
                      setState(() {
                        selectedSize = size;
                      });
                    },
                  ),
                ],
                ...product.attributes.entries.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: AppPadding.medium),
                      Text(
                        entry.key,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizeSelector(
                        sizes: entry.value,
                        onSizeSelected: (value) {
                          setState(() {
                            selectedAttributes[entry.key] = value;
                          });
                        },
                      ),
                    ],
                  );
                }),
                SizedBox(height: AppPadding.medium),
                (widget.productsModel.createStoreModel.isDelivery == true)
                    ? BlocConsumer<CartCubit, CartState>(
                        listener: (context, state) {
                          if (state is CartLoaded) {
                            getIt<NavigationService>().showSnackBar(
                              Text(AppLocalizations.of(context)!.addedToCart),
                            );
                          }
                          if (state is CartError) {
                            getIt<NavigationService>().showSnackBar(
                              Text(state.message),
                            );
                          }
                        },
                        builder: (context, state) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.9,
                                child: GradientButton(
                                  onPressed: (state is CartLoading)
                                      ? null
                                      : () async {
                                          final cartId =
                                              "${product.id}_${selectedSize ?? ""}_${selectedAttributes.values.join('_')}";
                                          context.read<CartCubit>().addItem(
                                            CartModel(
                                              productsModel:
                                                  widget.productsModel,
                                              createStoreModel: widget
                                                  .productsModel
                                                  .createStoreModel,
                                              id: cartId,
                                              selectedSize: selectedSize,
                                              selectedOptions:
                                                  selectedAttributes,
                                              quantity: quantity,
                                            ),
                                          );
                                        },
                                  text: (state is CartLoading)
                                      ? AppLocalizations.of(context)!.loading
                                      : AppLocalizations.of(context)!.addToCart,
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.primaryColor.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.local_shipping_outlined,
                                size: 40,
                                color: AppColors.primaryColor,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.noDeliveryAvailable,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: AppPadding.large),
                              GradientButton(
                                text: AppLocalizations.of(context)!.showDetails,
                                onPressed: () {
                                  StoreHelper().showStoreDetails(
                                    context,
                                    widget.productsModel.createStoreModel,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
