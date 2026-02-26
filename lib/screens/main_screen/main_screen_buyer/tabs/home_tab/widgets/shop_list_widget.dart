import 'package:boo/core/models/create_store_model.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/utils/app_colors.dart';
import '../../../../../../../core/utils/app_padding.dart';
import '../../../../../../core/services/get_init.dart';
import '../../../../../../core/services/navigation_service.dart';
import '../../../details/shop_details.dart';

class ShopListWidget extends StatelessWidget {
  final List<CreateStoreModel> stores;

  const ShopListWidget({super.key, required this.stores});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.2,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: stores.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final store = stores[index];
          return GestureDetector(
            onTap: () {
              getIt<NavigationService>().navigatePush(
                ShopDetails(
                  shopId: store.id ?? "",
                  shopName: store.selectedName, shopImage: store.selectedImage, category: store.selectedCat,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Container(
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: AppPadding.small,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryColor.withValues(alpha: 0.3),
                          width: 2,
                        ),
                        image: DecorationImage(
                          image: NetworkImage(store.selectedImage),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      store.selectedName,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      margin: EdgeInsets.all(AppPadding.small),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        store.selectedCat,
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
