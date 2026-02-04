import 'package:boo/core/models/products_model.dart';
import 'package:boo/core/services/get_init.dart';
import 'package:boo/core/services/navigation_service.dart';
import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/core/utils/app_padding.dart';
import 'package:boo/core/widgets/cached_image_widget.dart';
import 'package:boo/l10n/app_localizations.dart';
import 'package:boo/screens/main_screen/main_screen_buyer/details/widgets/size_selector.dart';
import 'package:boo/screens/main_screen/main_screen_buyer/details/widgets/store_info.dart';
import 'package:flutter/material.dart';

class ProductDetails extends StatefulWidget {
  final ProductsModel productsModel;

  const ProductDetails({super.key, required this.productsModel});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  String? selectedSize;
  int qunatity = 1;

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
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppPadding.medium,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppPadding.medium),
                    child: CachedImageWidget(imagePath: product.image),
                  ),
                ),
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
                    if (product.discount != "No Discount" && product.discount != null)
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
                              color: Colors.redAccent.withOpacity(0.4),
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
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: (product.quantity < 3)
                            ? Colors.redAccent.shade700
                            : AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
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
            ),
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.6,
              child: ElevatedButton(
                onPressed: () {
                  getIt<NavigationService>().showSnackBar(
                    Text(AppLocalizations.of(context)!.addedToCart),
                  );
                },
                child: Text(AppLocalizations.of(context)!.addToCart),
              ),
            ),
            Spacer(),
            IconButton(
              onPressed: () {
                setState(() {
                  qunatity++;
                });
              },
              icon: Icon(Icons.add, color: AppColors.primaryColor),
            ),
            Text(
              qunatity.toString(),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.primaryColor),
            ),
            IconButton(
              onPressed: (qunatity > 1)
                  ? () {
                      setState(() {
                        qunatity--;
                      });
                    }
                  : null,
              icon: Icon(Icons.remove, color: AppColors.primaryColor),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
