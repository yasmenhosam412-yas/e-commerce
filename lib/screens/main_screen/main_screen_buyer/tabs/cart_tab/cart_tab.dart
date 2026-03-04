import 'package:boo/controllers/buyer_cubits/cart_cubit/cart_cubit.dart';
import 'package:boo/controllers/buyer_cubits/cart_cubit/cart_state.dart';
import 'package:boo/controllers/manage_cubit/manage_cubit.dart';
import 'package:boo/core/models/cart_model.dart';
import 'package:boo/core/services/get_init.dart';
import 'package:boo/core/services/navigation_service.dart';
import 'package:boo/core/widgets/cached_image_widget.dart';
import 'package:boo/screens/main_screen/main_screen_buyer/checkout/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/app_padding.dart';

class CartTab extends StatefulWidget {
  const CartTab({super.key});

  @override
  State<CartTab> createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().loadCart();
  }

  double calculateTotal(Map<String, List<CartModel>> groupedItems) {
    double total = 0;

    groupedItems.forEach((shopName, items) {
      double subtotal = items.fold(
        0,
        (sum, item) =>
            sum +
            (item.productsModel.newPrice ?? item.productsModel.price) *
                item.quantity,
      );

      double delivery =
          double.tryParse(items.first.createStoreModel.selectedDelivery) ?? 0;
      double fees =
          double.tryParse(items.first.createStoreModel.selectedFees) ?? 0;

      total += subtotal + delivery + fees;
    });

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.myCart),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartLoaded) {
            if (state.items.isEmpty) {
              return Center(
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.68,
                  height: MediaQuery.sizeOf(context).width * 0.68,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.large,
                    vertical: AppPadding.medium,
                  ),
                  margin: const EdgeInsets.all(AppPadding.large),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primaryColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 40,
                          color: AppColors.primaryColor,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          AppLocalizations.of(context)!.nothing,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            Map<String, List<CartModel>> groupedItems = {};
            for (var item in state.items) {
              final storeName = item.createStoreModel.selectedName;
              if (!groupedItems.containsKey(storeName)) {
                groupedItems[storeName] = [];
              }
              groupedItems[storeName]!.add(item);
            }

            double totalAllItems = calculateTotal(groupedItems);

            return ListView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 110,
                top: 10,
                right: 10,
                left: 10,
              ),
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
                ...groupedItems.entries.map((entry) {
                  return ShopCartSection(
                    shopName: entry.key,
                    items: entry.value,
                    deliveryFees:
                        double.tryParse(
                          entry.value.first.createStoreModel.selectedDelivery,
                        ) ??
                        0,
                    shopFees:
                        double.tryParse(
                          entry.value.first.createStoreModel.selectedFees,
                        ) ??
                        0,
                  );
                }),
              ],
            );
          } else if (state is CartError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class ShopCartSection extends StatelessWidget {
  final String shopName;
  final List<CartModel> items;
  final double deliveryFees;
  final double shopFees;

  const ShopCartSection({
    super.key,
    required this.shopName,
    required this.items,
    required this.deliveryFees,
    required this.shopFees,
  });

  double get subtotal => items.fold(
    0,
    (sum, item) =>
        sum +
        (item.productsModel.newPrice ?? item.productsModel.price) *
            item.quantity,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
                      "${subtotal.toStringAsFixed(0)} ${AppLocalizations.of(context)!.currency}",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
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
                      "${shopFees.toStringAsFixed(0)} ${AppLocalizations.of(context)!.currency}",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.deliveryPrice,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "${deliveryFees.toStringAsFixed(0)} ${AppLocalizations.of(context)!.currency}",
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
                      "${(deliveryFees + shopFees + subtotal).toStringAsFixed(0)} ${AppLocalizations.of(context)!.currency}",
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
                    onPressed: () {
                      getIt<NavigationService>().navigatePush(
                        BlocBuilder<ManageCubit, ManageState>(
                          builder: (context, state) {
                            if (state is ManageLoaded) {
                              return CheckoutScreen(
                                cardModel: items,
                                delivery: deliveryFees,
                                subtotal: subtotal,
                                fees: shopFees,
                                userModel: state.userModel,
                              );
                            }
                            return SizedBox.shrink();
                          },
                        ),
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.checkout,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
  final CartModel item;

  const CartItemRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final price = item.productsModel.newPrice ?? item.productsModel.price;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: CachedImageWidget(imagePath: item.productsModel.image),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productsModel.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    if (item.selectedSize != null)
                      Text(
                        "${AppLocalizations.of(context)!.productSizes}: ${item.selectedSize}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    if (item.selectedOptions.isNotEmpty)
                      ...item.selectedOptions.entries.map(
                        (e) => Text(
                          "${e.key}: ${e.value}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    const SizedBox(height: 6),
                    Text(
                      "${price.toStringAsFixed(0)} ${AppLocalizations.of(context)!.currency}",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.primaryColor.withOpacity(0.8),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  context.read<CartCubit>().deleteItem(item.id);
                },
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    _QuantityButton(
                      icon: Icons.remove,
                      onPressed: () {
                        if (item.quantity > 1) {
                          context.read<CartCubit>().updateQuantity(
                            item.id,
                            item.quantity - 1,
                          );
                        }
                      },
                    ),
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
                    _QuantityButton(
                      icon: Icons.add,
                      onPressed: () {
                        if (item.quantity < item.productsModel.quantity) {
                          context.read<CartCubit>().updateQuantity(
                            item.id,
                            item.quantity + 1,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
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
