import 'package:boo/controllers/buyer_cubits/sell_cubit/sell_cubit.dart';
import 'package:boo/core/services/navigation_service.dart';
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
          return SizedBox(
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
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
