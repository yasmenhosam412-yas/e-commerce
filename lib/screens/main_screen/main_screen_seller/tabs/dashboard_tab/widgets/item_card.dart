import 'package:boo/core/models/products_model.dart';
import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final ProductsModel product;
  final String? discount;
  final String? collection;
  final bool isFeatured;
  final VoidCallback onProductClick;

  const ItemCard({
    super.key,
    required this.product,
    required this.discount,
    required this.collection,
    required this.isFeatured,
    required this.onProductClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onProductClick,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                  child: Image.network(
                    product.image,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                if (isFeatured)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        "Featured",
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "${product.price.toStringAsFixed(0)} ${AppLocalizations.of(context)!.currency}",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  if (discount != null && discount != "0")
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        "🔥 $discount OFF",
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontSize: 15,
                        ),
                      ),
                    ),

                  if (collection != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        collection ?? "",
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
