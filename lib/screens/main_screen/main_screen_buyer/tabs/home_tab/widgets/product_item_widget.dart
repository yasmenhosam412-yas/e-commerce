import 'package:boo/controllers/buyer_cubits/home_cubit/home_cubit.dart';
import 'package:boo/core/models/products_model.dart';
import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/core/widgets/cached_image_widget.dart';
import 'package:boo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../controllers/buyer_cubits/fav_cubit/fav_cubit.dart';
import '../../../../../../controllers/buyer_cubits/fav_cubit/fav_state.dart';

class ProductClothesItem extends StatelessWidget {
  final String image;
  final String name;
  final double price;
  final double? oldPrice;
  final double rating;
  final int? ratingCount;
  final int? id;
  final ProductsModel productModel;

  const ProductClothesItem({
    super.key,
    required this.image,
    required this.name,
    required this.price,
    this.oldPrice,
    required this.rating,
    this.ratingCount,
    this.id,
    required this.productModel,
  });

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    if (locale == null) return const SizedBox.shrink();

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
                BlocSelector<FavCubit, FavState, bool>(
                  selector: (state) {
                    return state.favourites.any((e) => e.id == productModel.id);
                  },
                  builder: (context, state) {
                    return Positioned(
                      top: 6,
                      right: 6,
                      child: GestureDetector(
                        onTap: () {
                          context.read<FavCubit>().toggleFav(productModel);
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
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildRatingStars(rating),
                    if (ratingCount != null) ...[
                      const SizedBox(width: 4),
                      Text(
                        "($ratingCount ${locale.reviews})",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                    const Spacer(),
                    InkWell(
                      onTap: () async {
                        final homeCubit = context.read<HomeCubit>();
                        await homeCubit.getReviewOfProducts(
                          productModel.id.toString(),
                        );

                        if (!context.mounted) return;

                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25),
                            ),
                          ),
                          builder: (modalContext) {
                            return BlocBuilder<HomeCubit, HomeState>(
                              bloc: homeCubit,
                              builder: (context, state) {
                                return Container(
                                  padding: const EdgeInsets.all(16),
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Center(
                                        child: Text(
                                          "Reviews",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      if (state.isLoadingR == true)
                                        const Expanded(
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        )
                                      else if (state.review == null ||
                                          state.review!.isEmpty)
                                        const Expanded(
                                          child: Center(
                                            child: Text("No reviews yet"),
                                          ),
                                        )
                                      else
                                        Expanded(
                                          child: ListView.separated(
                                            itemCount: state.review!.length,
                                            separatorBuilder:
                                                (context, index) =>
                                                    const SizedBox(height: 12),
                                            itemBuilder: (context, index) {
                                              final item = state.review![index];
                                              return Container(
                                                padding: const EdgeInsets.all(
                                                  12,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade100,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 40,
                                                      height: 40,
                                                      child: ClipOval(
                                                        child:
                                                            (item.userImage !=
                                                                    null &&
                                                                item
                                                                    .userImage!
                                                                    .isNotEmpty)
                                                            ? CachedImageWidget(
                                                                imagePath: item
                                                                    .userImage!,
                                                              )
                                                            : const Icon(
                                                                Icons.person,
                                                                size: 30,
                                                              ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            item.userName ??
                                                                "Anonymous",
                                                            style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: AppColors
                                                                  .primaryColor,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                          Row(
                                                            children: List.generate(
                                                              item.rating
                                                                      ?.toInt()
                                                                      .clamp(
                                                                        0,
                                                                        5,
                                                                      ) ??
                                                                  0,
                                                              (
                                                                index,
                                                              ) => const Icon(
                                                                Icons.star,
                                                                color: Colors
                                                                    .amber,
                                                                size: 16,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 6,
                                                          ),
                                                          Text(
                                                            item.review ?? "",
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .grey
                                                                  .shade700,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                      child: const Icon(
                        Icons.chat,
                        size: 18,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      "${price.toStringAsFixed(0)} ${locale.currency}",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    if (oldPrice != null) ...[
                      const SizedBox(width: 6),
                      Text(
                        "${oldPrice!.toStringAsFixed(0)} ${locale.currency}",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 13,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      children: List.generate(5, (index) {
        if (index + 1 <= rating) {
          return const Icon(Icons.star, size: 14, color: Colors.amber);
        } else if (index + 0.5 <= rating) {
          return const Icon(Icons.star_half, size: 14, color: Colors.amber);
        } else {
          return const Icon(Icons.star_border, size: 14, color: Colors.amber);
        }
      }),
    );
  }
}
