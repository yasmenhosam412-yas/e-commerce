import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/core/widgets/cached_image_widget.dart';
import 'package:boo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ProductClothesItem extends StatelessWidget {
  final String image;
  final String name;
  final double price;
  final double? oldPrice;
  final double rating;
  final int? ratingCount;
  final bool isFavorite;

  const ProductClothesItem({
    super.key,
    required this.image,
    required this.name,
    required this.price,
    this.oldPrice,
    this.isFavorite = false,
    required this.rating,
    this.ratingCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
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
                  top: 6,
                  right: 6,
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.white,
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 16,
                      color: Colors.redAccent,
                    ),
                  ),
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
                        "($ratingCount ${AppLocalizations.of(context)!.reviews})",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      "${price.toStringAsFixed(0)} ${AppLocalizations.of(context)!.currency}",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    if (oldPrice != null) ...[
                      const SizedBox(width: 6),
                      Text(
                        "${oldPrice!.toStringAsFixed(0)} ${AppLocalizations.of(context)!.currency}",
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
