import 'dart:io';

import 'package:boo/controllers/buyer_cubits/sell_cubit/sell_cubit.dart';
import 'package:boo/controllers/manage_cubit/manage_cubit.dart';
import 'package:boo/core/models/user_product_model.dart';
import 'package:boo/core/services/navigation_service.dart';
import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/core/utils/app_padding.dart';
import 'package:boo/core/widgets/custom_form_field.dart';
import 'package:boo/l10n/app_localizations.dart';
import 'package:boo/screens/authentication/widgets/gredient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/services/get_init.dart';
import '../../../../core/widgets/cached_image_widget.dart';

class SellSomething extends StatefulWidget {
  const SellSomething({super.key});

  @override
  State<SellSomething> createState() => _SellSomethingState();
}

class _SellSomethingState extends State<SellSomething> {
  final ImagePicker _picker = ImagePicker();

  final List<File> _pickedImages = [];
  final List<String> _existingImages = [];
  late TextEditingController nameController;
  late TextEditingController descController;
  late TextEditingController categoryController;
  late TextEditingController sizeController;
  late TextEditingController priceController;
  late TextEditingController contactNumberController;

  bool isUsed = true;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    descController = TextEditingController();
    sizeController = TextEditingController();
    priceController = TextEditingController();
    categoryController = TextEditingController();
    contactNumberController = TextEditingController();
  }

  Future<void> _pickImages() async {
    final files = await _picker.pickMultiImage(imageQuality: 80);

    if (files.isNotEmpty) {
      setState(() {
        _pickedImages.addAll(files.map((e) => File(e.path)));
        _existingImages.clear();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    descController.dispose();
    categoryController.dispose();
    priceController.dispose();
    sizeController.dispose();
    contactNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(AppLocalizations.of(context)!.sellSomething),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.medium),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppPadding.large,
            children: [
              GestureDetector(
                onTap: _pickImages,
                child: SizedBox(
                  height: 250,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _pickedImages.isNotEmpty
                        ? _pickedImages.length
                        : _existingImages.length + 1,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      if (_pickedImages.isEmpty &&
                          index == _existingImages.length) {
                        return _addImageBox();
                      }

                      final image = _pickedImages.isNotEmpty
                          ? Image.file(_pickedImages[index], fit: BoxFit.cover)
                          : CachedImageWidget(
                              imagePath: _existingImages[index],
                            );

                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              height: 250,
                              width: 250,
                              child: image,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _pickedImages.isNotEmpty
                                      ? _pickedImages.removeAt(index)
                                      : _existingImages.removeAt(index);
                                });
                              },
                              child: const CircleAvatar(
                                radius: 12,
                                backgroundColor: AppColors.whiteColor,
                                child: Icon(
                                  Icons.close,
                                  size: 14,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              CustomFormField(
                controller: nameController,
                hint: AppLocalizations.of(context)!.productName,
              ),
              CustomFormField(
                controller: descController,
                hint: AppLocalizations.of(context)!.productDescription,
                maxLines: 4,
              ),
              CustomFormField(
                controller: categoryController,
                hint: AppLocalizations.of(context)!.productCategory,
              ),
              CustomFormField(
                controller: sizeController,
                hint: AppLocalizations.of(context)!.enterSize,
              ),
              CustomFormField(
                controller: priceController,
                hint: AppLocalizations.of(context)!.productPrice,
                textInputType: TextInputType.number,
              ),
              CustomFormField(
                controller: contactNumberController,
                hint: AppLocalizations.of(context)!.contactNumber,
                textInputType: TextInputType.phone,
              ),
              Text(
                AppLocalizations.of(context)!.productStatus,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.primaryColor),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.065,
                child: Row(
                  children: [
                    Expanded(
                      child: RadioListTile<bool>(
                        value: true,
                        groupValue: isUsed,
                        activeColor: AppColors.primaryColor,
                        onChanged: (value) {
                          setState(() {
                            isUsed = value!;
                          });
                        },
                        title: Text(AppLocalizations.of(context)!.userP),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        value: false,
                        groupValue: isUsed,
                        activeColor: AppColors.primaryColor,
                        onChanged: (value) {
                          setState(() {
                            isUsed = value!;
                          });
                        },
                        title: Text(AppLocalizations.of(context)!.newP),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppPadding.medium),
              BlocConsumer<SellCubit, SellState>(
                listener: (context, state) {
                  if (state is SellLoaded) {
                    Navigator.pop(context);
                  }
                  if (state is SellError) {
                    getIt<NavigationService>().showToast(state.error);
                  }
                },
                builder: (context, state) {
                  return GradientButton(
                    text: (state is SellLoading)
                        ? AppLocalizations.of(context)!.loading
                        : AppLocalizations.of(context)!.showInSell,
                    onPressed: (state is SellLoading)
                        ? null
                        : () async {
                            if (nameController.text.isEmpty ||
                                descController.text.isEmpty ||
                                categoryController.text.isEmpty ||
                                sizeController.text.isEmpty ||
                                priceController.text.isEmpty ||
                                contactNumberController.text.isEmpty ||
                                _pickedImages.isEmpty) {
                              getIt<NavigationService>().showToast(
                                AppLocalizations.of(context)!.enterAllData,
                              );
                              return;
                            } else {
                              final user =
                                  context.read<ManageCubit>().state
                                      as ManageLoaded;

                              await context.read<SellCubit>().sellSomething(
                                UserProductModel(
                                  id: "",
                                  name: nameController.text,
                                  desc: descController.text,
                                  category: categoryController.text,
                                  size: sizeController.text,
                                  price: priceController.text,
                                  contactNumber: contactNumberController.text,
                                  status: isUsed ? "Used" : "New",
                                  userName: user.userModel?.displayName ?? "",
                                  userImage: user.userModel?.photoURL ?? "",
                                  images: _pickedImages
                                      .map((e) => e.path)
                                      .toList(),
                                ),
                              );
                            }
                          },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addImageBox() {
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.add_a_photo),
    );
  }
}
