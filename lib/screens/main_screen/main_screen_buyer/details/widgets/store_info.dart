import 'package:boo/core/services/get_init.dart';
import 'package:boo/core/services/navigation_service.dart';
import 'package:boo/screens/main_screen/main_screen_buyer/details/shop_details.dart';
import 'package:flutter/material.dart';

import '../../../../../core/models/products_model.dart';
import '../../../../../core/widgets/cached_image_widget.dart';

class StoreInfoWidget extends StatelessWidget {
  const StoreInfoWidget({super.key, required this.product});

  final ProductsModel product;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, width: 2),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: CachedImageWidget(imagePath: product.createStoreModel.selectedImage),
            ),
          ),

          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.createStoreModel.selectedName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${product.category} • ${product.collectionName ?? ""} ",
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Material(
            color: Colors.grey.shade100,
            shape: const CircleBorder(),
            child: IconButton(
              onPressed: () {
                getIt<NavigationService>().navigatePush(
                  ShopDetails(
                    shopId: product.storeId,
                    createStoreModel: product.createStoreModel,
                  ),
                );
              },
              icon: const Icon(Icons.arrow_forward),
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
