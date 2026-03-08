import 'dart:io';
import 'package:boo/controllers/stores_cubit/store_creation_cubit/store_creation_cubit.dart';
import 'package:boo/core/widgets/cached_image_widget.dart';
import 'package:boo/screens/main_screen/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/services/get_init.dart';
import '../../../../../../core/services/navigation_service.dart';
import '../../../../../../core/utils/app_colors.dart';
import '../../../../../../core/utils/app_padding.dart';
import '../../../../../../l10n/app_localizations.dart';

class ReviewAndPublishContent extends StatefulWidget {
  final String selectedImage;
  final String storeName;
  final String storeDesc;
  final String storeCategory;
  final String businessPhone;
  final String businessEmail;
  final String businessAddress;
  final String fees;
  final String deliveryPrice;
  final bool isDelivery;
  final List<String>? deliveryGovernorates;
  final String? deliveryTime;
  final String? deliveryInfo;
  final VoidCallback onPublish;

  const ReviewAndPublishContent({
    super.key,
    required this.selectedImage,
    required this.storeName,
    required this.storeDesc,
    required this.storeCategory,
    required this.businessPhone,
    required this.businessEmail,
    required this.businessAddress,
    required this.fees,
    required this.deliveryPrice,
    required this.isDelivery,
    this.deliveryGovernorates,
    this.deliveryTime,
    this.deliveryInfo,
    required this.onPublish,
  });

  @override
  State<ReviewAndPublishContent> createState() =>
      _ReviewAndPublishContentState();
}

class _ReviewAndPublishContentState extends State<ReviewAndPublishContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppLocalizations.of(context)!.title4,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(height: AppPadding.medium),

        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: widget.selectedImage.startsWith('http')
              ? SizedBox(
              width: 105,
              height: 105,
              child: CachedImageWidget(imagePath: widget.selectedImage))
              : widget.selectedImage.isNotEmpty
                  ? Image.file(
                      File(widget.selectedImage),
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error, color: AppColors.primaryColor);
                      },
                    )
                  : Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.store, color: Colors.grey, size: 50),
                    ),
        ),
        const SizedBox(height: AppPadding.medium),

        _buildReviewRow(
          AppLocalizations.of(context)!.storeName,
          widget.storeName,
        ),
        _buildReviewRow(
          AppLocalizations.of(context)!.storeDesc,
          widget.storeDesc,
        ),
        _buildReviewRow(
          AppLocalizations.of(context)!.storeCategory,
          widget.storeCategory,
        ),

        const SizedBox(height: AppPadding.medium),

        _buildReviewRow(
          AppLocalizations.of(context)!.phoneNumber,
          widget.businessPhone,
        ),
        _buildReviewRow(
          AppLocalizations.of(context)!.email,
          widget.businessEmail,
        ),
        _buildReviewRow(
          AppLocalizations.of(context)!.address,
          widget.businessAddress,
        ),

        const SizedBox(height: AppPadding.medium),

        _buildReviewRow(AppLocalizations.of(context)!.fees, widget.fees),
        _buildReviewRow(
          AppLocalizations.of(context)!.isDelivery,
          widget.isDelivery ? "Yes" : "No",
        ),
        if (widget.isDelivery) ...[
          _buildReviewRow(
            AppLocalizations.of(context)!.deliveryPrice,
            widget.deliveryPrice,
          ),
          _buildReviewRow(
            AppLocalizations.of(context)!.deliveryGovernorates,
            widget.deliveryGovernorates?.join(' , ') ?? "",
          ),
          _buildReviewRow(
            AppLocalizations.of(context)!.deliveryTime,
            widget.deliveryTime ?? "-",
          ),
          _buildReviewRow(
            AppLocalizations.of(context)!.deliveryInfo,
            widget.deliveryInfo ?? "-",
          ),
        ],

        const SizedBox(height: AppPadding.xxlarge),

        BlocConsumer<StoreCreationCubit, StoreCreationState>(
          listener: (context, state) {
            if (state.isSuccess) {
              getIt<NavigationService>().showToast(
                AppLocalizations.of(context)!.storeCreated,
              );
              getIt<NavigationService>().navigatePushRemoveUntil(
                const LoadingScreen(),
              );
            }

            if (state.error != null) {
              getIt<NavigationService>().showToast(state.error ?? "");
            }
          },
          builder: (context, state) {
            return SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (state.isLoading) ? null : widget.onPublish,
                child: Text(
                  (state.isLoading)
                      ? AppLocalizations.of(context)!.loading
                      : AppLocalizations.of(context)!.publish,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: Colors.white),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: AppPadding.xxlarge),
      ],
    );
  }

  Widget _buildReviewRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
              fontSize: 15,
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : '-',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
