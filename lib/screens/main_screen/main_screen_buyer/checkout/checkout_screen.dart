import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/core/utils/app_padding.dart';
import 'package:boo/core/widgets/cached_image_widget.dart';
import 'package:boo/core/widgets/custom_drop_down.dart';
import 'package:boo/core/widgets/custom_form_field.dart';
import 'package:boo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/models/cart_model.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartModel> cardModel;
  final double delivery;
  final double subtotal;
  final double fees;

  const CheckoutScreen({
    super.key,
    required this.cardModel,
    required this.delivery,
    required this.subtotal,
    required this.fees,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  String? selectedGov;

  TextStyle primaryStyle({
    double size = 14,
    FontWeight weight = FontWeight.normal,
  }) {
    return TextStyle(
      color: AppColors.primaryColor,
      fontSize: size,
      fontWeight: weight,
    );
  }

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
        child: SizedBox(
          height: 55,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: validateAndCheckout,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  "${AppLocalizations.of(context)!.checkout} • ${widget.delivery + widget.fees + widget.subtotal} ${AppLocalizations.of(context)!.currency}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
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

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Divider(thickness: 1),
                  ),

                  _buildSummaryRow(
                    AppLocalizations.of(context)!.total,
                    "${widget.delivery + widget.fees + widget.subtotal} ${AppLocalizations.of(context)!.currency}",
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

  void validateAndCheckout() {
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!.orderPlaced,
          style: TextStyle(color: Colors.white),
        ),
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
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

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
        String address =
            "${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}";

        locationController.text = address;
      } else {
        locationController.text =
            "${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}";
      }
    } catch (e) {
      locationController.text =
          "${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}";
    }
  }
}
