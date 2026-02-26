import 'package:boo/core/models/products_model.dart';
import 'package:flutter/material.dart';
import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/core/widgets/cached_image_widget.dart';
import 'package:boo/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../controllers/fav_cubit/fav_cubit.dart';
import '../../../../../../controllers/fav_cubit/fav_state.dart';

enum ProductOwnerType { store, user }

class ProductItem extends StatelessWidget {
  final ProductOwnerType ownerType;

  final String image;
  final String name;
  final double price;

  final double? oldPrice;
  final double? rating;
  final int? reviewsCount;

  final String? sellerName;
  final String? sellerAvatar;
  final double? sellerRating;
  final int? sellerSalesCount;
  final bool? isUsed;
  final ProductsModel productModel;

  const ProductItem({
    super.key,
    required this.ownerType,
    required this.image,
    required this.name,
    required this.price,

    this.oldPrice,
    this.rating,
    this.reviewsCount,

    this.sellerName,
    this.sellerAvatar,
    this.sellerRating,
    this.sellerSalesCount,
    this.isUsed,
    required this.productModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImage(context),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ownerType == ProductOwnerType.store
                ? _buildStoreDetails(context)
                : _buildUserDetails(context),
          ),
        ],
      ),
    );
  }

  BoxDecoration _boxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 6,
        offset: const Offset(0, 4),
      ),
    ],
  );

  Widget _buildImage(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: CachedImageWidget(imagePath: image),
          ),

          BlocSelector<FavCubit, FavState, bool>(
            selector: (state) {
              return state.favourites.contains(productModel);
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
                    radius: 14,
                    backgroundColor: Colors.white,
                    child: Icon(
                      state ? Icons.favorite : Icons.favorite_border,
                      size: 16,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              );
            },
          ),

          if (ownerType == ProductOwnerType.user)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: (isUsed ?? true) ? Colors.orange : Colors.green,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  (isUsed ?? true) ? "Used" : "New",
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStoreDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(context),
        const SizedBox(height: 4),
        _rating(context, rating ?? 0, reviewsCount),
        const SizedBox(height: 4),
        _price(context, oldPrice),
      ],
    );
  }

  Widget _buildUserDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(context),
        const SizedBox(height: 6),
        _sellerInfo(context),
        const SizedBox(height: 4),
        _sellerRating(context),
        const SizedBox(height: 6),
        _price(context, null),
        const SizedBox(height: 8),
        _chatButton(),
      ],
    );
  }

  Widget _title(BuildContext context) {
    return Text(
      name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryColor,
      ),
    );
  }

  Widget _price(BuildContext context, double? oldPrice) {
    return Row(
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
            "${oldPrice.toStringAsFixed(0)} ${AppLocalizations.of(context)!.currency}",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              decoration: TextDecoration.lineThrough,
              color: Colors.grey,
            ),
          ),
        ],
      ],
    );
  }

  Widget _rating(BuildContext context, double value, int? count) {
    return Row(
      children: [
        _stars(value),
        if (count != null) ...[
          const SizedBox(width: 4),
          Text("($count)", style: Theme.of(context).textTheme.bodySmall),
        ],
      ],
    );
  }

  Widget _sellerInfo(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 10,
          backgroundImage: NetworkImage(
            sellerAvatar ?? "https://i.pravatar.cc/150",
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            sellerName ?? "User",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _sellerRating(BuildContext context) {
    return Row(
      children: [
        _stars(sellerRating ?? 0),
        const SizedBox(width: 4),
        Text(
          "(${sellerSalesCount ?? 0})",
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _stars(double rating) {
    return Row(
      children: List.generate(5, (index) {
        if (index + 1 <= rating) {
          return const Icon(Icons.star, size: 13, color: Colors.amber);
        } else if (index + 0.5 <= rating) {
          return const Icon(Icons.star_half, size: 13, color: Colors.amber);
        } else {
          return const Icon(Icons.star_border, size: 13, color: Colors.amber);
        }
      }),
    );
  }

  Widget _chatButton() {
    return SizedBox(
      width: double.infinity,
      height: 34,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text("Chat with seller", style: TextStyle(fontSize: 13)),
      ),
    );
  }
}
