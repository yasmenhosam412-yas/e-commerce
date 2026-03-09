import 'package:boo/controllers/orders_cubit/orders_cubit.dart';
import 'package:boo/core/models/order_model.dart';
import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/core/utils/app_padding.dart';
import 'package:boo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StaticsTab extends StatefulWidget {
  const StaticsTab({super.key});

  @override
  State<StaticsTab> createState() => _StaticsTabState();
}

class _StaticsTabState extends State<StaticsTab> {
  @override
  void initState() {
    super.initState();
    context.read<OrdersCubit>().getOrders();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(
          l10n.statistics,
          style: const TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          if (state is OrdersLoaded) {
            final stats = _calculateStats(state.orders);

            return RefreshIndicator(
              onRefresh: () => context.read<OrdersCubit>().getOrders(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppPadding.xlarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryCards(stats, l10n),
                    const SizedBox(height: 24),
                    Text(
                      l10n.revenueBreakdown,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildRevenueChart(stats, l10n),
                    const SizedBox(height: 24),
                    Text(
                      l10n.topSellingProducts,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildProductStats(stats.productSales, l10n),
                  ],
                ),
              ),
            );
          } else if (state is OrdersError) {
            return Center(child: Text(state.error));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildSummaryCards(_SellerStats stats, AppLocalizations l10n) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: l10n.totalEarnings,
                value:
                    "${stats.totalEarnings.toStringAsFixed(2)} ${l10n.currency}",
                icon: Icons.account_balance_wallet,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: l10n.comingEarnings,
                value:
                    "${stats.comingEarnings.toStringAsFixed(2)} ${l10n.currency}",
                icon: Icons.hourglass_empty,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: l10n.lossCancelled,
                value:
                    "${stats.cancelledLoss.toStringAsFixed(2)} ${l10n.currency}",
                icon: Icons.cancel_outlined,
                color: Colors.red,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: l10n.totalOrders,
                value: "${stats.totalOrders}",
                icon: Icons.shopping_bag_outlined,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRevenueChart(_SellerStats stats, AppLocalizations l10n) {
    final total =
        stats.totalEarnings + stats.comingEarnings + stats.cancelledLoss;
    if (total == 0) {
      return Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(child: Text("No revenue data yet")),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              if (stats.totalEarnings > 0)
                _chartSegment(stats.totalEarnings / total, Colors.green),
              if (stats.comingEarnings > 0)
                _chartSegment(stats.comingEarnings / total, Colors.orange),
              if (stats.cancelledLoss > 0)
                _chartSegment(stats.cancelledLoss / total, Colors.red),
            ],
          ),
          const SizedBox(height: 16),
          _LegendItem(color: Colors.green, label: l10n.totalEarnings),
          _LegendItem(color: Colors.orange, label: l10n.comingEarnings),
          _LegendItem(color: Colors.red, label: l10n.lossCancelled),
        ],
      ),
    );
  }

  Widget _chartSegment(double percentage, Color color) {
    return Expanded(
      flex: (percentage * 100).toInt().clamp(1, 100),
      child: Container(
        height: 24,
        margin: const EdgeInsets.symmetric(horizontal: 1),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget _buildProductStats(
    Map<String, int> productSales,
    AppLocalizations l10n,
  ) {
    if (productSales.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            "No sales yet",
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.primaryColor),
          ),
        ),
      );
    }

    final sortedProducts = productSales.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final maxSales = sortedProducts.first.value;

    return Column(
      children: sortedProducts.take(5).map((entry) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      entry.key,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.primaryColor,
                      ),

                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    "${entry.value} ${l10n.sold}",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Stack(
                children: [
                  Container(
                    height: 8,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: maxSales > 0 ? entry.value / maxSales : 0,
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  _SellerStats _calculateStats(List<OrderModel> orders) {
    double totalEarnings = 0;
    double comingEarnings = 0;
    double cancelledLoss = 0;
    Map<String, int> productSales = {};

    for (var order in orders) {
      double price = double.tryParse(order.totalPrice) ?? 0;

      if (order.status == 'delivered') {
        totalEarnings += price;
      } else if (order.status == 'canceled' || order.status == 'rejected') {
        cancelledLoss += price;
      } else {
        comingEarnings += price;
      }

      // Products stats (count sales for non-cancelled orders)
      if (order.status != 'canceled' && order.status != 'rejected') {
        for (var cartItem in order.products) {
          final productName = cartItem.productsModel.name;
          productSales[productName] =
              (productSales[productName] ?? 0) + cartItem.quantity;
        }
      }
    }

    return _SellerStats(
      totalEarnings: totalEarnings,
      comingEarnings: comingEarnings,
      cancelledLoss: cancelledLoss,
      totalOrders: orders.length,
      productSales: productSales,
    );
  }
}

class _SellerStats {
  final double totalEarnings;
  final double comingEarnings;
  final double cancelledLoss;
  final int totalOrders;
  final Map<String, int> productSales;

  _SellerStats({
    required this.totalEarnings,
    required this.comingEarnings,
    required this.cancelledLoss,
    required this.totalOrders,
    required this.productSales,
  });
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}
