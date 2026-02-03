import 'package:boo/core/utils/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/l10n/app_localizations.dart';

double getCartTotal(List<ShopCartSection> sections) {
  return sections.fold(0, (sum, section) => sum + section.total);
}

class CartTab extends StatelessWidget {
  const CartTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Define your sections
    final sections = [
      const ShopCartSection(
        shopName: "Nike Store",
        items: [
          CartItemData("Running Shoes", 120, 1),
          CartItemData("Sport T-Shirt", 45, 2),
        ],
      ),
      const ShopCartSection(
        shopName: "Apple Store",
        items: [CartItemData("AirPods Pro", 250, 1)],
      ),
    ];

    final totalAllItems = getCartTotal(sections);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.myCart),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Text(
              "${AppLocalizations.of(context)!.totalCart} : ${totalAllItems.toStringAsFixed(0)} ${AppLocalizations.of(context)!.currency}",
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ...sections.map((s) => s).toList(),
        ],
      ),
    );
  }
}

class CartItemData {
  final String name;
  final double price;
  final int quantity;

  const CartItemData(this.name, this.price, this.quantity);
}

class ShopCartSection extends StatelessWidget {
  final String shopName;
  final List<CartItemData> items;

  const ShopCartSection({
    super.key,
    required this.shopName,
    required this.items,
  });

  double get total =>
      items.fold(0, (sum, item) => sum + item.price * item.quantity);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.store,
                  color: AppColors.primaryColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    shopName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: items.map((item) => CartItemRow(item: item)).toList(),
            ),
          ),

          const Divider(height: 1),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.subtotal,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "${total.toStringAsFixed(0)} ${AppLocalizations.of(context)!.currency}",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppPadding.large),
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.fees,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "34 ${AppLocalizations.of(context)!.currency}",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                Divider(color: AppColors.primaryColor),
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.total,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "${(34 + total).toStringAsFixed(0)} ${AppLocalizations.of(context)!.currency}",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 4,
                    ),
                    onPressed: () {},
                    child: Text(
                      AppLocalizations.of(context)!.checkout,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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

class CartItemRow extends StatelessWidget {
  final CartItemData item;

  const CartItemRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.image, size: 30, color: Colors.white70),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${item.price} ${AppLocalizations.of(context)!.currency}",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primaryColor.withOpacity(0.8),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),

          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                _QuantityButton(icon: Icons.remove, onPressed: () {}),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    item.quantity.toString(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
                _QuantityButton(icon: Icons.add, onPressed: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _QuantityButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          elevation: 0,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.primaryColor, width: 1),
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onPressed,
        child: Icon(icon, size: 18, color: AppColors.primaryColor),
      ),
    );
  }
}
