import 'package:boo/core/models/user_product_model.dart';
import 'package:flutter/material.dart';
import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/core/widgets/cached_image_widget.dart';
import 'package:boo/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../controllers/buyer_cubits/fav_cubit/fav_cubit.dart';
import '../../../../../../controllers/buyer_cubits/fav_cubit/fav_state.dart';

class UserProductClothesItem extends StatelessWidget {
  final String image;
  final String name;
  final String price;

  final String sellerName;
  final String sellerAvatar;

  final bool isUsed;
  final UserProductModel userProduct;

  const UserProductClothesItem({
    super.key,
    required this.image,
    required this.name,
    required this.price,
    required this.sellerName,
    required this.sellerAvatar,
    this.isUsed = true,
    required this.userProduct,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: CachedImageWidget(imagePath: image),
                ),

                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isUsed
                          ? Colors.orange.withValues(alpha: 0.9)
                          : Colors.green.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      isUsed ? "Used" : "New",
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                BlocSelector<FavCubit, FavState, bool>(
                  selector: (state) {
                    return state.favouritesUsers.contains(userProduct);
                  },
                  builder: (context, state) {
                    return Positioned(
                      top: 6,
                      right: 6,
                      child: GestureDetector(
                        onTap: () {
                          context.read<FavCubit>().toggleUserFav(userProduct);
                        },
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white,
                          child: Icon(
                            state ? Icons.favorite : Icons.favorite_border,
                            size: 22,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    (sellerAvatar.isNotEmpty)
                        ? CircleAvatar(
                      radius: 10,
                      backgroundImage: NetworkImage(sellerAvatar),
                    )
                        : CircleAvatar(
                      backgroundColor: AppColors.grey200,
                      radius: 10,
                      child: Icon(
                        Icons.person, size: 13, color: AppColors.primaryColor,),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        sellerName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  "$price ${AppLocalizations.of(context)!.currency}",
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),

                const SizedBox(height: 8),

                SizedBox(
                  width: double.infinity,
                  height: 34,
                  child: ElevatedButton(
                    onPressed: () async {
                      final Uri phoneUri = Uri(
                        scheme: 'tel',
                        path: userProduct.contactNumber,
                      );

                      if (await canLaunchUrl (phoneUri)
                      ) {
                      await launchUrl(phoneUri);
                      }

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child:  Text(
                      AppLocalizations.of(context)!.contactSeller,
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
