import 'package:boo/screens/main_screen/main_screen_buyer/tabs/home_tab/widgets/product_item_user_widget.dart';
import 'package:flutter/material.dart';

class WantToSellList extends StatelessWidget {
  const WantToSellList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.65,
      child: GridView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2
        ),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: UserProductClothesItem(
              image:
              "https://tse3.mm.bing.net/th/id/OIP.PTrMioI24oEhJ-NRvoTZcwHaE8?rs=1&pid=ImgDetMain&o=7&rm=3",
              name: "Summer T Shirt",
              price: 266,
              isFavorite: true,
              sellerAvatar: "https://tse3.mm.bing.net/th/id/OIP.PTrMioI24oEhJ-NRvoTZcwHaE8?rs=1&pid=ImgDetMain&o=7&rm=3",
              isUsed: true,
              sellerName: "Yasmeen Hossam",
            ),
          );
        },
      ),
    );
  }
}
