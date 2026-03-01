import 'package:boo/controllers/buyer_cubits/sell_cubit/sell_cubit.dart';
import 'package:boo/core/services/navigation_service.dart';
import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/core/utils/app_padding.dart';
import 'package:boo/l10n/app_localizations.dart';
import 'package:boo/screens/main_screen/main_screen_buyer/details/product_details_user.dart';
import 'package:boo/screens/main_screen/main_screen_buyer/tabs/home_tab/widgets/product_item_user_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/services/get_init.dart';

class WantToSellList extends StatelessWidget {
  const WantToSellList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SellCubit, SellState>(
      builder: (context, state) {
        if (state is SellLoaded) {
          return (state.userProducts.isNotEmpty)
              ? SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.65,
                  child: GridView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: state.userProducts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.2,
                    ),
                    itemBuilder: (context, index) {
                      final item = state.userProducts[index];
                      return GestureDetector(
                        onTap: () {
                          getIt<NavigationService>().navigatePush(
                            ProductDetailsUser(userProductModel: item),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: UserProductClothesItem(
                            image: item.images.first,
                            name: item.name,
                            price: item.price,
                            sellerAvatar: item.userImage,
                            isUsed: item.status == "Used" ? true : false,
                            sellerName: item.userName,
                            userProduct: item,
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.large,
                      vertical: AppPadding.medium,
                    ),
                    margin: const EdgeInsets.all(AppPadding.large),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primaryColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 40,
                          color: AppColors.primaryColor,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          AppLocalizations.of(context)!.nothing,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                );
        }
        return SizedBox.shrink();
      },
    );
  }
}
