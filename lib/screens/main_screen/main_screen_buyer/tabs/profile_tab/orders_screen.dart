import 'package:boo/controllers/buyer_cubits/checkout_cubit/checkout_cubit.dart';
import 'package:boo/controllers/review_cubit/review_cubit.dart';
import 'package:boo/core/models/cart_model.dart';
import 'package:boo/core/models/order_model.dart';
import 'package:boo/core/models/user_model.dart';
import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/core/widgets/custom_form_field.dart';
import 'package:boo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/services/get_init.dart';
import '../../../../../core/services/navigation_service.dart';

class OrdersScreen extends StatefulWidget {
  final UserModel userModel;

  const OrdersScreen({super.key, required this.userModel});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<OrderModel>? _orders;

  @override
  void initState() {
    super.initState();
    context.read<CheckoutCubit>().getUserOrders();
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'ready':
        return Colors.blue;
      case 'delivered':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  void _showReviewDialog(BuildContext context, CartModel item) {
    final locale = AppLocalizations.of(context)!;
    final reviewController = TextEditingController();
    double currentRating = 0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                locale.rateProduct,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.primaryColor),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          onPressed: () {
                            setState(() {
                              currentRating = index + 1.0;
                            });
                          },
                          icon: Icon(
                            index < currentRating
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 32,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    CustomFormField(
                      controller: reviewController,
                      hint: locale.writeReview,
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(locale.cancel),
                ),
                BlocConsumer<ReviewCubit, ReviewState>(
                  listener: (context, state) {
                    if (state is ReviewAdded) {
                      getIt<NavigationService>().showToast(locale.reviewAdded);
                      Navigator.pop(context);
                    } else if (state is ReviewError) {
                      getIt<NavigationService>().showToast(state.error);
                    }
                  },
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is ReviewLoading
                          ? null
                          : () {
                              if (currentRating > 0) {
                                context.read<ReviewCubit>().addRate(
                                      currentRating,
                                      reviewController.text,
                                      item.productsModel.id.toString(),
                                      item.createStoreModel.id ?? "",
                                      widget.userModel.displayName,
                                      widget.userModel.photoURL,
                                    );
                              }
                            },
                      child: state is ReviewLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(locale.submit),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final locale = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(locale.myOrders, style: TextStyle(color: primaryColor)),
        backgroundColor: Colors.white,
      ),
      body: BlocConsumer<CheckoutCubit, CheckoutState>(
        listener: (context, state) {
          if (state is CheckoutLoaded) {
            getIt<NavigationService>().showToast(
              AppLocalizations.of(context)!.canceled,
            );
            context.read<CheckoutCubit>().getUserOrders();
          }
          if (state is CheckoutError) {
            getIt<NavigationService>().showToast(state.error);
          }
        },
        builder: (context, state) {
          if (state is CheckoutLoadedOrders) {
            _orders = state.orders;
          }

          if (_orders == null) {
            if (state is CheckoutLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CheckoutError) {
              return Center(
                child: Text(state.error, style: TextStyle(color: primaryColor)),
              );
            }
          }

          if (_orders == null || _orders!.isEmpty) {
            return Center(
              child: Text(
                locale.noOrdersFound,
                style: TextStyle(color: primaryColor),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: _orders!.length,
            itemBuilder: (context, index) {
              final order = _orders![index];

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${locale.order} #${order.orderId.substring(0, 8).toUpperCase()}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: primaryColor,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: getStatusColor(
                              order.status,
                            ).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            order.status.toUpperCase(),
                            style: TextStyle(
                              color: getStatusColor(order.status),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    if (order.createdAt != null)
                      Text(
                        DateFormat(
                          'dd MMM yyyy, hh:mm a',
                        ).format(order.createdAt!),
                        style: TextStyle(
                          color: primaryColor.withValues(alpha: 0.6),
                          fontSize: 13,
                        ),
                      ),

                    const Divider(height: 20, thickness: 1),
                    ...order.products.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    item.productsModel.images.first,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.broken_image,
                                              size: 60,
                                            ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.productsModel.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: primaryColor,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${locale.qty}: ${item.quantity}',
                                        style: TextStyle(
                                          color: primaryColor.withValues(alpha: 0.7),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '${item.productsModel.newPrice ?? item.productsModel.price} ${locale.currency}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            if (order.status.toLowerCase() == 'delivered')
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton.icon(
                                  onPressed: () =>
                                      _showReviewDialog(context, item),
                                  icon: const Icon(Icons.star_outline, size: 18),
                                  label: Text(locale.rateProduct),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    const Divider(height: 20, thickness: 1),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          locale.fees,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        Text(
                          '${order.products.first.createStoreModel.selectedFees} ${locale.currency}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          locale.deliveryPrice,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        Text(
                          '${order.products.first.createStoreModel.selectedDelivery} ${locale.currency}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),

                    if (order.withCoupon)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          "Coupon applied!",
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    const Divider(height: 20, thickness: 1),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          locale.total,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        Text(
                          '${order.totalPrice} ${locale.currency}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    if (order.status.toLowerCase() == 'pending')
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: SizedBox(
                          width: double.infinity,
                          child: BlocBuilder<CheckoutCubit, CheckoutState>(
                            builder: (context, state) {
                              final bool isThisOrderLoading =
                                  state is CancelOrderLoading &&
                                  state.orderId == order.orderId;
                              final bool isLoading =
                                  state is CheckoutLoading ||
                                  isThisOrderLoading;
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            backgroundColor: Colors.white,
                                            title: Text(
                                              locale.cancelOrder,
                                              style: const TextStyle(
                                                color: AppColors.primaryColor,
                                              ),
                                            ),
                                            content: Text(
                                              locale.areYouSureCancel,
                                              style: TextStyle(
                                                color: primaryColor,
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(ctx).pop(),
                                                child: Text(locale.no),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(ctx).pop();
                                                  context
                                                      .read<CheckoutCubit>()
                                                      .cancelOrder(
                                                        order.storeId,
                                                        order.orderId,
                                                      );
                                                },
                                                child: Text(
                                                  locale.yes,
                                                  style: const TextStyle(
                                                    color: AppColors.whiteColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                child: Text(
                                  isLoading
                                      ? locale.loading
                                      : locale.cancelOrder,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(color: primaryColor, thickness: 1);
            },
          );
        },
      ),
    );
  }
}
