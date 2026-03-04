import 'dart:io';
import 'package:boo/controllers/buyer_cubits/info_cubit/info_cubit.dart';
import 'package:boo/controllers/manage_cubit/manage_cubit.dart';
import 'package:boo/core/models/user_model.dart';
import 'package:boo/core/services/navigation_service.dart';
import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/core/utils/app_padding.dart';
import 'package:boo/core/utils/constants.dart';
import 'package:boo/core/widgets/custom_drop_down.dart';
import 'package:boo/core/widgets/custom_form_field.dart';
import 'package:boo/l10n/app_localizations.dart';
import 'package:boo/screens/authentication/widgets/gredient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/services/get_init.dart';

class InfoScreen extends StatefulWidget {
  final UserModel? userModel;

  const InfoScreen({super.key, required this.userModel});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController addressController;
  late final TextEditingController locationController;

  String? selectedGovernorate;
  File? selectedImage;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: widget.userModel?.displayName ?? '',
    );
    phoneController = TextEditingController(
      text: widget.userModel?.phone ?? '',
    );
    addressController = TextEditingController(
      text: widget.userModel?.address ?? '',
    );
    locationController = TextEditingController(
      text: widget.userModel?.location ?? '',
    );
    selectedGovernorate = widget.userModel?.governorate;
  }

  final List<String> governorates = [
    "Cairo",
    "Giza",
    "Alexandria",
    "Dakahlia",
    "Sharqia",
  ];

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.primaryColor),
        title: Text(
          "Complete Profile",
          style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.medium),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 55,
                backgroundColor: AppColors.primaryColor.withOpacity(.1),
                backgroundImage: selectedImage != null
                    ? FileImage(selectedImage!)
                    : (widget.userModel?.photoURL != null && widget.userModel?.photoURL.isNotEmpty == true
                    ? NetworkImage(widget.userModel!.photoURL) as ImageProvider
                    : null),
                child: (selectedImage == null && (widget.userModel?.photoURL == null || widget.userModel?.photoURL.isEmpty == true))
                    ? Icon(
                  Icons.camera_alt,
                  size: 35,
                  color: AppColors.primaryColor,
                )
                    : null,
              ),
            ),
            const SizedBox(height: 25),

            _buildTextField(
              controller: nameController,
              hint: "Full Name",
              icon: Icons.person,
            ),

            const SizedBox(height: 15),

            _buildTextField(
              controller: phoneController,
              hint: "Phone Number",
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 15),

            CustomDropdown(
              value: selectedGovernorate,
              label: AppLocalizations.of(context)!.governorate,
              items: AppConstants.egyptGovernorates,
              onChanged: (value) {
                setState(() {
                  selectedGovernorate = value;
                });
              },
            ),
            const SizedBox(height: 15),

            _buildTextField(
              controller: addressController,
              hint: "Address",
              icon: Icons.home,
              maxLines: 2,
            ),

            const SizedBox(height: 15),

            CustomFormField(
              controller: locationController,
              hint: AppLocalizations.of(context)!.location,
              readOnly: true,
              onTap: getLocation,
              suffixIcon: const Icon(Icons.my_location),
            ),

            const SizedBox(height: 30),

            BlocConsumer<InfoCubit, InfoState>(
              listener: (context, state) {
                if (state is InfoLoaded) {
                  context.read<ManageCubit>().updateUserModel(state.userModel);
                  getIt<NavigationService>().showToast("Profile Updated");
                  Navigator.pop(context);
                }

                if (state is InfoError) {
                  getIt<NavigationService>().showToast(state.error);
                }
              },
              builder: (context, state) {
                return GradientButton(
                  onPressed: (state is InfoLoading)
                      ? null
                      : () async {
                          if (nameController.text.isEmpty ||
                              phoneController.text.isEmpty ||
                              addressController.text.isEmpty ||
                              locationController.text.isEmpty ||
                              selectedGovernorate == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  AppLocalizations.of(context)!.enterAllData,
                                ),
                              ),
                            );
                            return;
                          }

                          await context.read<InfoCubit>().updateUserInfo(
                            selectedImage?.path ?? "",
                            nameController.text,
                            phoneController.text,
                            addressController.text,
                            locationController.text,
                            selectedGovernorate ?? "",
                          );
                        },
                  text: (state is InfoLoading)
                      ? AppLocalizations.of(context)!.loading
                      : AppLocalizations.of(context)!.save,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return CustomFormField(
      controller: controller,
      hint: hint,
      prefixIcon: Icon(icon),
      maxLines: maxLines,
      textInputType: keyboardType,
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.primaryColor),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
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
