import 'package:boo/screens/main_screen/main_screen_buyer/tabs/home_tab/widgets/product_mixed_widget.dart';
import 'package:flutter/material.dart';

class MixedList extends StatelessWidget {
  const MixedList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.68,
      child: GridView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
        ),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ProductItem(
              ownerType: ProductOwnerType.store,
              image:
                  "https://tse3.mm.bing.net/th/id/OIP.PTrMioI24oEhJ-NRvoTZcwHaE8?rs=1&pid=ImgDetMain&o=7&rm=3",
              name: "Summer T Shirt",
              price: 266,
              isFavorite: true,
              oldPrice: 280,
              rating: 4.2,
              reviewsCount: 6,
            ),
          );
        },
      ),
    );
  }
}
