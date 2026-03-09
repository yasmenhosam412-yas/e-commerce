import 'package:boo/controllers/orders_cubit/orders_cubit.dart';
import 'package:boo/core/services/navigation_service.dart';
import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/core/utils/app_padding.dart';
import 'package:boo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/get_init.dart';
import 'order_details.dart';

class OrdersTab extends StatefulWidget {
  const OrdersTab({super.key});

  @override
  State<OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab> {
  String selectedStatus = "all";

  @override
  void initState() {
    super.initState();
    context.read<OrdersCubit>().getOrders();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> statuses = [
      {"key": "all", "label": AppLocalizations.of(context)!.all},
      {"key": "pending", "label": AppLocalizations.of(context)!.pending},
      {"key": "ready", "label": AppLocalizations.of(context)!.ready},
      {"key": "onWay", "label": AppLocalizations.of(context)!.onWay},
      {"key": "canceled", "label": AppLocalizations.of(context)!.canceled},
      {"key": "rejected", "label": AppLocalizations.of(context)!.rejected},
      {"key": "accepted", "label": AppLocalizations.of(context)!.accepted},
      {"key": "delivered", "label": AppLocalizations.of(context)!.delivered},
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            if (state is OrdersLoaded) {
              final filteredOrders = selectedStatus == "all"
                  ? state.orders
                  : state.orders
                        .where((o) => o.status == selectedStatus)
                        .toList();

              return Column(
                children: [
                  SizedBox(
                    height: 55,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppPadding.medium,
                      ),
                      itemCount: statuses.length,
                      itemBuilder: (context, index) {
                        final status = statuses[index];

                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: AppColors.primaryColor.withValues(
                                  alpha: .3,
                                ),
                              ),
                            ),
                            backgroundColor: Colors.white,
                            selectedColor: AppColors.primaryColor,
                            showCheckmark: false,
                            label: Text(
                              status["label"]!,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: selectedStatus == status["key"]
                                    ? Colors.white
                                    : AppColors.primaryColor,
                              ),
                            ),
                            selected: selectedStatus == status["key"],
                            onSelected: (_) {
                              setState(() {
                                selectedStatus = status["key"]!;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 8),

                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      itemCount: filteredOrders.length,
                      itemBuilder: (context, index) {
                        final order = filteredOrders[index];

                        return GestureDetector(
                          onTap: () {
                            getIt<NavigationService>().navigatePush(
                              OrderDetails(order: order),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: .05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 26,
                                  backgroundColor: Colors.grey.shade100,
                                  backgroundImage:
                                      order.userModel.photoURL.isNotEmpty
                                      ? NetworkImage(order.userModel.photoURL)
                                      : null,
                                  child: order.userModel.photoURL.isEmpty
                                      ? const Icon(Icons.person)
                                      : null,
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        order.userModel.displayName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),

                                      const SizedBox(height: 6),

                                      Text(
                                        "${order.products.length} ${AppLocalizations.of(context)!.products}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      Text(
                                        "${order.totalPrice} ${AppLocalizations.of(context)!.currency}",
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: getBorderColor(
                                          order.status,
                                        ).withValues(alpha: .12),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        order.status,
                                        style: TextStyle(
                                          color: getBorderColor(order.status),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 12),

                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: AppColors.primaryColor,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Color getBorderColor(String status) {
    switch (status) {
      case "pending":
        return Colors.amber;

      case "canceled":
        return Colors.red;

      case "ready":
        return Colors.green;

      case "onWay":
        return Colors.indigo;
      case "rejected":
        return Colors.deepOrange;

      default:
        return AppColors.primaryColor;
    }
  }
}
