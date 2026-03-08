import 'dart:io';
import 'package:boo/controllers/manage_cubit/manage_cubit.dart';
import 'package:boo/controllers/stores_cubit/store_creation_cubit/store_creation_cubit.dart';
import 'package:boo/core/models/create_store_model.dart';
import 'package:boo/core/services/navigation_service.dart';
import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/core/utils/app_padding.dart';
import 'package:boo/l10n/app_localizations.dart';
import 'package:boo/screens/authentication/auth_screen.dart';
import 'package:boo/screens/main_screen/main_screen_seller/tabs/dashboard_tab/widgets/business_details.dart';
import 'package:boo/screens/main_screen/main_screen_seller/tabs/dashboard_tab/widgets/fees_and_delivery.dart';
import 'package:boo/screens/main_screen/main_screen_seller/tabs/dashboard_tab/widgets/review_publish.dart';
import 'package:boo/screens/main_screen/main_screen_seller/tabs/dashboard_tab/widgets/store_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  bool isDelivery = false;
  List<String>? deliveryGovernorates;
  String? deliveryTime;
  String? deliveryInfo;

  @override
  void initState() {
    super.initState();
    final state = context.read<ManageCubit>().state;
    if (state is ManageLoaded && state.createStoreModel != null) {
      final store = state.createStoreModel!;
      selectedName = store.selectedName;
      selectedDesc = store.selectedDesc;
      selectedCat = store.selectedCat;
      selectedPhone = store.selectedPhone;
      selectedEmail = store.selectedEmail;
      selectedAddress = store.selectedAddress;
      selectedFees = store.selectedFees;
      selectedDelivery = store.selectedDelivery;
      selectedImage = store.selectedImage;
      isDelivery = store.isDelivery;
      deliveryGovernorates = store.deliveryGovernorates;
      deliveryTime = store.deliveryTime;
      deliveryInfo = store.deliveryInfo;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  (selectedName.isNotEmpty)
                      ? AppLocalizations.of(context)!.myStore
                      : AppLocalizations.of(context)!.createStore,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ),
              SizedBox(height: AppPadding.large),
              Expanded(
                child: ListView(
                  children: [
                    _buildStepTile(
                      title: AppLocalizations.of(context)!.title1,
                      isFinished:
                          selectedName.isNotEmpty &&
                          selectedDesc.isNotEmpty &&
                          selectedCat.isNotEmpty &&
                          selectedImage.isNotEmpty,
                      onTap: () =>
                          _showStepModal(AppLocalizations.of(context)!.title1),
                    ),
                    _buildStepTile(
                      title: AppLocalizations.of(context)!.title2,
                      isFinished:
                          selectedPhone.isNotEmpty &&
                          selectedEmail.isNotEmpty &&
                          selectedAddress.isNotEmpty,
                      onTap: () => _showBusinessDetailsModal(
                        AppLocalizations.of(context)!.title2,
                      ),
                    ),
                    _buildStepTile(
                      title: AppLocalizations.of(context)!.title3,
                      isFinished:
                          selectedFees.isNotEmpty &&
                          (!isDelivery || selectedDelivery.isNotEmpty),
                      onTap: () =>
                          _showFeesModal(AppLocalizations.of(context)!.title3),
                    ),
                    _buildStepTile(
                      title: AppLocalizations.of(context)!.title4,
                      isFinished: true,
                      onTap: _showReviewAndPublishModal,
                    ),
                    SizedBox(height: AppPadding.medium),
                    (selectedName.isNotEmpty)
                        ? SizedBox.shrink()
                        : _buildStepTile(
                            title: AppLocalizations.of(context)!.signout,
                            isFinished: false,
                            onTap: () async {
                              await FirebaseAuth.instance.signOut();
                              getIt<NavigationService>()
                                  .navigatePushRemoveUntil(const AuthScreen());
                            },
                            isSignOut: true,
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepTile({
    required String title,
    required bool isFinished,
    required VoidCallback onTap,
    bool isSignOut = false,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: AppPadding.small),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppPadding.small),
      ),
      color: isSignOut ? AppColors.errorColor : AppColors.whiteColor,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppPadding.medium,
          vertical: AppPadding.small,
        ),
        leading: Icon(
          isFinished ? Icons.check_circle : Icons.circle_outlined,
          color: isSignOut ? AppColors.whiteColor : AppColors.primaryColor,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isSignOut ? AppColors.whiteColor : AppColors.primaryColor,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: isSignOut ? AppColors.whiteColor : AppColors.grey500,
        ),
        onTap: onTap,
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
        onClick:
            (
              String fees,
              String delivery,
              bool deliveryEnabled,
              List<String>? governorates,
              String? time,
              String? info,
            ) {
              setState(() {
                selectedFees = fees;
                selectedDelivery = delivery;
                isDelivery = deliveryEnabled;
                deliveryGovernorates = governorates;
                deliveryTime = time;
                deliveryInfo = info;
              });
              Navigator.pop(context);
            },
        fees: selectedFees,
        deliveryPrice: selectedDelivery,
        isDelivery: isDelivery,
        governorates: deliveryGovernorates,
        time: deliveryTime,
        info: deliveryInfo,
      ),
    );
  }

  void _showReviewAndPublishModal() {
    getIt<NavigationService>().showCustomBottomDialog(
      content: ReviewAndPublishContent(
        selectedImage: selectedImage,
        storeName: selectedName,
        storeDesc: selectedDesc,
        storeCategory: selectedCat,
        businessPhone: selectedPhone,
        businessEmail: selectedEmail,
        businessAddress: selectedAddress,
        fees: "$selectedFees ${AppLocalizations.of(context)!.currency}",
        deliveryPrice:
            "$selectedDelivery ${AppLocalizations.of(context)!.currency}",
        isDelivery: isDelivery,
        deliveryGovernorates: deliveryGovernorates,
        deliveryTime: deliveryTime,
        deliveryInfo: deliveryInfo,
        onPublish: () {
          if (selectedName.isEmpty ||
              selectedDesc.isEmpty ||
              selectedCat.isEmpty ||
              selectedPhone.isEmpty ||
              selectedEmail.isEmpty ||
              selectedAddress.isEmpty ||
              selectedFees.isEmpty ||
              (isDelivery && selectedDelivery.isEmpty) ||
              selectedImage.isEmpty) {
            getIt<NavigationService>().showToast(
              AppLocalizations.of(context)!.enterAllData,
            );
            return;
          }
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
              isDelivery: isDelivery,
              deliveryGovernorates: deliveryGovernorates,
              deliveryTime: deliveryTime,
              deliveryInfo: deliveryInfo,
            ),
          );
        },
      ),
    );
  }
}
