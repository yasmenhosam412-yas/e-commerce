import 'package:boo/core/models/user_product_model.dart';
import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/core/widgets/cached_image_widget.dart';
import 'package:boo/l10n/app_localizations.dart';
import 'package:boo/screens/authentication/widgets/gredient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../controllers/buyer_cubits/fav_cubit/fav_cubit.dart';
import '../../../../controllers/buyer_cubits/fav_cubit/fav_state.dart';

class ProductDetailsUser extends StatefulWidget {
  final UserProductModel userProductModel;

  const ProductDetailsUser({super.key, required this.userProductModel});

  @override
  State<ProductDetailsUser> createState() => _ProductDetailsUserState();
}

class _ProductDetailsUserState extends State<ProductDetailsUser> {
  int currentIndex = 0;

  Future<void> _callNumber(String number) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.userProductModel;
    final primaryTextColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(
          product.name,
          style: const TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor),
        ),
        actions: [
          BlocSelector<FavCubit, FavState, bool>(
            selector: (state) {
              return state.favouritesUsers.any((e) => e.id == product.id);
            },
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: () {
                    context.read<FavCubit>().toggleUserFav(product);
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: Icon(
                      state ? Icons.favorite : Icons.favorite_border,
                      size: 24,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: PageView.builder(
                itemCount: product.images.length,
                onPageChanged: (index) => setState(() => currentIndex = index),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                    child: CachedImageWidget(imagePath: product.images[index]),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            if (product.images.length > 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  product.images.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: currentIndex == index ? 14 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: currentIndex == index
                          ? AppColors.primaryColor
                          : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // 🔥 Product Info Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name & Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: primaryTextColor,
                            ),
                          ),
                        ),
                        Text(
                          "${product.price} ${AppLocalizations.of(context)!.currency}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        product.status,
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Description
                    Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      product.desc,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade800,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Category & Size
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            "Category",
                            product.category,
                            primaryTextColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildInfoCard(
                            "Size",
                            product.size,
                            primaryTextColor,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Seller Info
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: product.userImage.isNotEmpty
                              ? NetworkImage(product.userImage)
                              : null,
                          backgroundColor: product.userImage.isEmpty
                              ? Colors.grey.shade300
                              : null,
                          child: product.userImage.isEmpty
                              ? Icon(Icons.person, color: primaryTextColor)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.userName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: primaryTextColor,
                              ),
                            ),
                            Text(
                              "Seller",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // 🔥 Contact Button
                    GradientButton(
                      text: "Contact Seller",
                      onPressed: () => _callNumber(product.contactNumber),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
          ),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(color: Colors.grey.shade700)),
        ],
      ),
    );
  }
}
