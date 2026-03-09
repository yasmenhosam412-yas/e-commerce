import 'package:boo/core/models/products_model.dart';
import 'package:boo/core/services/navigation_service.dart';
import 'package:boo/screens/main_screen/main_screen_buyer/details/product_details.dart';
import 'package:boo/screens/main_screen/main_screen_buyer/tabs/home_tab/widgets/product_item_widget.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/services/get_init.dart';

class FeaturedPickList extends StatelessWidget {
  final List<ProductsModel> products;

  const FeaturedPickList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.5,
      child: GridView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          final product = products[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                getIt<NavigationService>().navigatePush(
                  ProductDetails(productsModel: product),
                );
              },
              child: ProductClothesItem(
                image: product.image,
                name: product.name,
                id: product.id,
                price: product.newPrice ?? product.price,
                oldPrice: (product.newPrice != product.price)
                    ? product.price
                    : null,
                rating: product.ratingAvg ?? 0,
                ratingCount: product.reviewsCount,
                productModel: product,
              ),
            ),
          );
        },
      ),
    );
  }
}
