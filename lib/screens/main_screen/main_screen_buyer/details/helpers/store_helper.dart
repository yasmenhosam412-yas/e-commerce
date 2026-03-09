import 'package:boo/core/widgets/cached_image_widget.dart';
import 'package:flutter/material.dart';

import '../../../../../core/models/create_store_model.dart';
import '../../../../../core/utils/app_colors.dart';

class StoreHelper {
  void showStoreDetails(BuildContext context, CreateStoreModel store) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          maxChildSize: 0.95,
          minChildSize: 0.6,
          builder: (_, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: SingleChildScrollView(
                controller: controller,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Drag Handle
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Store Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SizedBox(
                        height: 250,
                        child: CachedImageWidget(
                          imagePath: store.selectedImage,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Store Name
                    Text(
                      store.selectedName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// Description
                    Text(
                      store.selectedDesc,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.primaryColor,
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Basic Info Card
                    BuildSectionCard(
                      title: "Store Information",
                      children: [
                        InfoRow(title: "Category", value: store.selectedCat),
                        InfoRow(title: "Phone", value: store.selectedPhone),
                        InfoRow(title: "Email", value: store.selectedEmail),
                        InfoRow(title: "Address", value: store.selectedAddress),
                        InfoRow(title: "Fees", value: store.selectedFees),
                      ],
                    ),

                    const SizedBox(height: 16),

                    BuildSectionCard(
                      title: "Delivery Information",
                      children: [
                        InfoRow(
                          title: "Offers Delivery :",
                          value: store.isDelivery ? "Yes" : "No",
                        ),
                        if (store.isDelivery) ...[
                          InfoRow(
                            title: "Governorates",
                            value: store.deliveryGovernorates?.join(' ,').toString() ?? "",
                          ),
                          InfoRow(
                            title: "Delivery Time",
                            value: store.deliveryTime ?? "-",
                          ),
                          InfoRow(
                            title: "Additional Info",
                            value: store.deliveryInfo ?? "-",
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class BuildSectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const BuildSectionCard({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryColor.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.store, color: AppColors.primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const InfoRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
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
