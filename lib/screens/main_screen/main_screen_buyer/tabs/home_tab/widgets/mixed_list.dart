import 'package:boo/core/models/products_model.dart';
import 'package:boo/core/models/user_product_model.dart';
import 'package:boo/core/services/get_init.dart';
import 'package:boo/core/services/navigation_service.dart';
import 'package:boo/screens/main_screen/main_screen_buyer/details/product_details.dart';
import 'package:boo/screens/main_screen/main_screen_buyer/details/product_details_user.dart';
import 'package:boo/screens/main_screen/main_screen_buyer/tabs/home_tab/widgets/product_mixed_widget.dart';
import 'package:flutter/material.dart';

class MixedList extends StatelessWidget {
  final List<ProductsModel> productsModel;
  final List<UserProductModel> userProductsModel;

  const MixedList({
    super.key,
    required this.productsModel,
    required this.userProductsModel,
  });

  @override
  Widget build(BuildContext context) {
    final totalItems = [
      ...productsModel.map((p) => ProductWrapper.storeProduct(p)),
      ...userProductsModel.map((u) => ProductWrapper.userProduct(u)),
    ];

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.68,
      child: GridView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: totalItems.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
        ),
        itemBuilder: (context, index) {
          final item = totalItems[index];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                if (item.ownerType == ProductOwnerType.store) {
                  getIt<NavigationService>().navigatePush(
                    ProductDetails(productsModel: item.productModel!),
                  );
                } else {
                  getIt<NavigationService>().navigatePush(
                    ProductDetailsUser(
                      userProductModel: item.userProductModel!,
                    ),
                  );
                }
              },
              child: ProductItem(
                ownerType: item.ownerType,
                image: item.image,
                name: item.name,
                price: item.price,
                oldPrice: (item.oldPrice == item.price) ? null : item.oldPrice,
                rating: item.rating,
                isUsed: item.userProductModel?.status == "Used",
                sellerAvatar: item.userProductModel?.userImage ?? "",
                sellerName: item.userProductModel?.userName ?? "",
                userProductModel: (item.ownerType == ProductOwnerType.user)
                    ? item.userProductModel
                    : null,
                productModel: (item.ownerType == ProductOwnerType.store)
                    ? item.productModel
                    : null,
                reviewsCount: item.reviewsCount,
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProductWrapper {
  final ProductOwnerType ownerType;
  final String image;
  final String name;
  final double price;
  final double oldPrice;
  final double rating;
  final int reviewsCount;

  final ProductsModel? productModel;
  final UserProductModel? userProductModel;

  ProductWrapper({
    required this.ownerType,
    required this.image,
    required this.name,
    required this.price,
    required this.oldPrice,
    required this.rating,
    required this.reviewsCount,
    this.productModel,
    this.userProductModel,
  });

  factory ProductWrapper.storeProduct(ProductsModel p) {
    return ProductWrapper(
      ownerType: ProductOwnerType.store,
      image: p.images.isNotEmpty ? p.images.first : "",
      name: p.name,
      price: p.newPrice ?? p.price,
      oldPrice: p.price,
      rating: p.ratingAvg ?? 0.0,
      reviewsCount: p.reviewsCount ?? 0,
      productModel: p,
      userProductModel: null,
    );
  }

  factory ProductWrapper.userProduct(UserProductModel u) {
    return ProductWrapper(
      ownerType: ProductOwnerType.user,
      image: u.images.isNotEmpty ? u.images.first : "",
      name: u.name,
      price: double.tryParse(u.price) ?? 0,
      oldPrice: double.tryParse(u.price) ?? 0,
      rating: 0,
      reviewsCount: 0,
      productModel: null,
      userProductModel: u,
    );
  }
}
