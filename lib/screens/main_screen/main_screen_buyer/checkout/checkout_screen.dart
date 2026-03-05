import 'package:boo/controllers/buyer_cubits/cart_cubit/cart_cubit.dart';
import 'package:boo/controllers/buyer_cubits/checkout_cubit/checkout_cubit.dart';
import 'package:boo/core/models/coupon_code.dart';
import 'package:boo/core/models/user_model.dart';
import 'package:boo/core/services/navigation_service.dart';
import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/core/utils/app_padding.dart';
import 'package:boo/core/widgets/cached_image_widget.dart';
import 'package:boo/core/widgets/custom_drop_down.dart';
import 'package:boo/core/widgets/custom_form_field.dart';
import 'package:boo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/models/cart_model.dart';
import '../../../../core/services/get_init.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartModel> cardModel;
  final UserModel? userModel;
  final double delivery;
  final double subtotal;
  final double fees;

  const CheckoutScreen({
    super.key,
    required this.cardModel,
    required this.delivery,
    required this.subtotal,
    required this.fees,
    required this.userModel,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController couponController = TextEditingController();

  String? selectedGov;

  double discount = 0;
  bool couponApplied = false;

  @override
  void initState() {
    super.initState();

    nameController.text = widget.userModel?.displayName ?? "";
    phoneController.text = widget.userModel?.phone ?? "";
    addressController.text = widget.userModel?.address ?? "";
    locationController.text = widget.userModel?.location ?? "";
    selectedGov = widget.userModel?.governorate ?? "";
  }

  double get total =>
      widget.delivery + widget.fees + widget.subtotal - discount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.primaryColor),
        title: Text(
          AppLocalizations.of(context)!.checkout,
          style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 10),
          ],
        ),
        child: BlocConsumer<CheckoutCubit, CheckoutState>(
          listener: (context, state) {
            if (state is CheckoutLoaded) {
              getIt<NavigationService>().showToast(
                AppLocalizations.of(context)!.orderPlaced,
              );
              Navigator.pop(context);
              context.read<CartCubit>().clearCart(widget.cardModel.first.id);
            }

            if (state is CheckoutError) {
              getIt<NavigationService>().showToast(state.error);
            }
          },
          builder: (context, state) {
            return SizedBox(
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: (state is CheckoutLoading)
                    ? null
                    : () async {
                        if (nameController.text.isEmpty ||
                            phoneController.text.isEmpty ||
                            addressController.text.isEmpty ||
                            locationController.text.isEmpty ||
                            selectedGov == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(context)!.enterAllData,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                          return;
                        }

                        await context.read<CheckoutCubit>().createOrder(
                          widget.cardModel,
                          total.toStringAsFixed(0),
                          couponApplied,
                          widget.userModel ??
                              UserModel(
                                uid: "",
                                email: "",
                                displayName: "",
                                photoURL: "",
                                userType: "",
                                phone: "",
                                address: "",
                                location: "",
                                governorate: "",
                              ),
                        );
                      },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock, color: Colors.white),
                    const SizedBox(width: 10),
                    Text(
                      (state is CheckoutLoading)
                          ? AppLocalizations.of(context)!.loading
                          : "${AppLocalizations.of(context)!.checkout} • ${total.toStringAsFixed(0)} ${AppLocalizations.of(context)!.currency}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.medium),
        child: Column(
          children: [
            _buildSectionCard(
              title: AppLocalizations.of(context)!.orderItems,
              child: Column(
                children: widget.cardModel.map((item) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            width: 70,
                            height: 70,
                            child: CachedImageWidget(
                              imagePath: item.productsModel.image,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.productsModel.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "${item.quantity} x ${item.productsModel.price} ${AppLocalizations.of(context)!.currency}",
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            _buildSectionCard(
              title: AppLocalizations.of(context)!.deliveryInformation,
              child: Column(
                children: [
                  CustomFormField(
                    controller: nameController,
                    hint: AppLocalizations.of(context)!.fullName,
                  ),
                  const SizedBox(height: 12),
                  CustomFormField(
                    controller: phoneController,
                    hint: AppLocalizations.of(context)!.phoneNumber,
                    textInputType: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),
                  CustomDropdown(
                    value: selectedGov,
                    label: AppLocalizations.of(context)!.governorate,
                    items:
                        widget
                            .cardModel
                            .first
                            .createStoreModel
                            .deliveryGovernorates ??
                        [],
                    onChanged: (value) {
                      setState(() {
                        selectedGov = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  CustomFormField(
                    controller: addressController,
                    hint: AppLocalizations.of(context)!.address,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  CustomFormField(
                    controller: locationController,
                    hint: AppLocalizations.of(context)!.location,
                    readOnly: true,
                    onTap: getLocation,
                    suffixIcon: const Icon(Icons.my_location),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _buildSectionCard(
              title: "Coupon",
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomFormField(
                          controller: couponController,
                          hint: "Enter coupon code",
                        ),
                      ),
                      const SizedBox(width: 10),
                      BlocConsumer<CheckoutCubit, CheckoutState>(
                        listener: (context, state) {
                          if (state is CheckoutCouponApplied) {
                            applyCoupon(state.couponCode);
                          }

                          if (state is CheckoutError) {
                            getIt<NavigationService>().showToast(state.error);
                          }
                        },
                        builder: (context, state) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              if (couponController.text.isEmpty) return;

                              context.read<CheckoutCubit>().applyCoupon(
                                couponController.text,
                                widget.cardModel.first.createStoreModel.id ??
                                    "",
                              );
                            },
                            child: const Text(
                              "Apply",
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  if (couponApplied)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "Coupon applied! -${discount.toStringAsFixed(0)} ${AppLocalizations.of(context)!.currency}",
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _buildSectionCard(
              title: AppLocalizations.of(context)!.paymentSummary,
              child: Column(
                children: [
                  _buildSummaryRow(
                    AppLocalizations.of(context)!.subtotal,
                    "${widget.subtotal} ${AppLocalizations.of(context)!.currency}",
                  ),
                  const SizedBox(height: 10),
                  _buildSummaryRow(
                    AppLocalizations.of(context)!.deliveryPrice,
                    "${widget.delivery} ${AppLocalizations.of(context)!.currency}",
                  ),
                  const SizedBox(height: 10),
                  _buildSummaryRow(
                    AppLocalizations.of(context)!.fees,
                    "${widget.fees} ${AppLocalizations.of(context)!.currency}",
                  ),
                  if (discount > 0) ...[
                    const SizedBox(height: 10),
                    _buildSummaryRow(
                      "Discount",
                      "-${discount.toStringAsFixed(0)} ${AppLocalizations.of(context)!.currency}",
                    ),
                  ],
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Divider(thickness: 1),
                  ),
                  _buildSummaryRow(
                    AppLocalizations.of(context)!.total,
                    "${total.toStringAsFixed(0)} ${AppLocalizations.of(context)!.currency}",
                    isTotal: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  void applyCoupon(CouponCode? coupon) {
    if (coupon == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid or expired coupon")),
      );
      return;
    }

    double calculatedDiscount = 0;

    if (coupon.type == "Fixed Amount") {
      calculatedDiscount = coupon.value;
    } else if (coupon.type == "Percentage") {
      calculatedDiscount = widget.subtotal * (coupon.value / 100);
    }

    if (calculatedDiscount > widget.subtotal) {
      calculatedDiscount = widget.subtotal;
    }

    setState(() {
      discount = calculatedDiscount;
      couponApplied = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Coupon applied successfully")),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? AppColors.primaryColor : Colors.grey.shade700,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: FontWeight.bold,
            color: isTotal ? AppColors.primaryColor : Colors.black,
          ),
        ),
      ],
    );
  }

  Future<void> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        locationController.text =
            "${placemark.street}, ${placemark.locality}, ${placemark.country}";
      }
    } catch (_) {
      locationController.text = "${position.latitude}, ${position.longitude}";
    }
  }
}
