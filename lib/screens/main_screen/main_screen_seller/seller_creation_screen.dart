import 'dart:io';
import 'package:boo/controllers/stores_cubit/store_creation_cubit/store_creation_cubit.dart';
import 'package:boo/core/models/create_store_model.dart';
import 'package:boo/core/services/navigation_service.dart';
import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/core/utils/app_padding.dart';
import 'package:boo/l10n/app_localizations.dart';
import 'package:boo/screens/main_screen/main_screen_seller/tabs/dashboard_tab/widgets/business_details.dart';
import 'package:boo/screens/main_screen/main_screen_seller/tabs/dashboard_tab/widgets/fees_and_delivery.dart';
import 'package:boo/screens/main_screen/main_screen_seller/tabs/dashboard_tab/widgets/review_publish.dart';
import 'package:boo/screens/main_screen/main_screen_seller/tabs/dashboard_tab/widgets/store_info.dart';
import 'package:boo/screens/main_screen/main_screen_seller/tabs/dashboard_tab/widgets/tile_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/services/get_init.dart';

class SellerCreationScreen extends StatefulWidget {
  const SellerCreationScreen({super.key});

  @override
  State<SellerCreationScreen> createState() => _SellerCreationScreenState();
}

class _SellerCreationScreenState extends State<SellerCreationScreen> {
  String selectedName = '';
  String selectedDesc = '';
  String selectedCat = '';
  String selectedPhone = '';
  String selectedEmail = '';
  String selectedAddress = '';
  String selectedFees = '';
  String selectedDelivery = '';
  String selectedImage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              spacing: AppPadding.xxlarge,
              children: [
                Text(
                  AppLocalizations.of(context)!.createStore,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.primaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TileStep(
                  isFinished: true,
                  step: AppLocalizations.of(context)!.title1,
                  onTab: () {
                    _showStepModal(AppLocalizations.of(context)!.title1);
                  },
                ),
                TileStep(
                  isFinished: true,
                  step: AppLocalizations.of(context)!.title2,
                  onTab: () {
                    _showBusinessDetailsModal(
                      AppLocalizations.of(context)!.title2,
                    );
                  },
                ),
                TileStep(
                  isFinished: true,
                  step: AppLocalizations.of(context)!.title3,
                  onTab: () {
                    _showFeesModal(AppLocalizations.of(context)!.title3);
                  },
                ),
                TileStep(
                  isFinished: true,
                  step: AppLocalizations.of(context)!.title4,
                  onTab: () {
                    _showReviewAndPublishModal();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showStepModal(String title) {
    getIt<NavigationService>().showCustomBottomDialog(
      content: StoreInfo(
        onClick: (String name, String category, String desc, String image) {
          setState(() {
            selectedName = name;
            selectedCat = category;
            selectedDesc = desc;
            selectedImage = image;
          });
          Navigator.pop(context);
        },
        name: selectedName,
        category: selectedCat,
        desc: selectedDesc,
        image: selectedImage,
      ),
    );
  }

  void _showBusinessDetailsModal(String title) {
    getIt<NavigationService>().showCustomBottomDialog(
      content: BusinessDetails(
        onClick: (String phone, String email, String address) {
          setState(() {
            selectedPhone = phone;
            selectedEmail = email;
            selectedAddress = address;
          });
          Navigator.pop(context);
        },
        email: selectedEmail,
        phone: selectedPhone,
        address: selectedAddress,
      ),
    );
  }

  void _showFeesModal(String title) {
    getIt<NavigationService>().showCustomBottomDialog(
      content: FeesAndDelivery(
        onClick: (String fees, String delivery) {
          setState(() {
            selectedFees = fees;
            selectedDelivery = delivery;
          });
          Navigator.pop(context);
        },
        fees: selectedFees,
        deliveryPrice: selectedDelivery,
      ),
    );
  }

  void _showReviewAndPublishModal() {
    getIt<NavigationService>().showCustomBottomDialog(
      content: ReviewAndPublishContent(
        selectedImage: File(selectedImage),
        storeName: selectedName,
        storeDesc: selectedDesc,
        storeCategory: selectedCat,
        businessPhone: selectedPhone,
        businessEmail: selectedEmail,
        businessAddress: selectedAddress,
        fees: "$selectedFees ${AppLocalizations.of(context)!.currency}",
        deliveryPrice:
        "$selectedDelivery ${AppLocalizations.of(context)!.currency}",
        onPublish: () {
          context.read<StoreCreationCubit>().storeCreation(
            storeData: CreateStoreModel(
              selectedName: selectedName,
              selectedDesc: selectedDesc,
              selectedCat: selectedCat,
              selectedPhone: selectedPhone,
              selectedEmail: selectedEmail,
              selectedAddress: selectedAddress,
              selectedFees: selectedFees,
              selectedDelivery: selectedDelivery,
              selectedImage: selectedImage,
            ),
          );
        },
      ),
    );
  }
}
