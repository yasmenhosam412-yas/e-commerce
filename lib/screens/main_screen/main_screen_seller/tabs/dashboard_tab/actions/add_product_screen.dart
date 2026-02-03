import 'dart:io';
import 'package:boo/controllers/stores_cubit/dashboard_cubit/dashboard_cubit.dart';
import 'package:boo/controllers/stores_cubit/dashboard_cubit/dashboard_state.dart';
import 'package:boo/core/services/get_init.dart';
import 'package:boo/core/services/navigation_service.dart';
import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/core/widgets/custom_form_field.dart';
import 'package:boo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _catController = TextEditingController();
  final _quantityController = TextEditingController();
  final _sizeController = TextEditingController();
  final List<String> _sizes = [];

  File? _productImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context);

    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _productImage = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(AppLocalizations.of(context)!.gallery),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(AppLocalizations.of(context)!.camera),
              onTap: () => _pickImage(ImageSource.camera),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(AppLocalizations.of(context)!.addProduct),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _showImageSourceSheet,
                child: Center(
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: _productImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              _productImage!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo_outlined,
                                size: 30,
                                color: AppColors.primaryColor,
                              ),
                              SizedBox(height: 8),
                              Text(
                                AppLocalizations.of(context)!.addProductImage,
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(
                                      color: AppColors.primaryColor,
                                      fontSize: 16,
                                    ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              CustomFormField(
                controller: _nameController,
                hint: AppLocalizations.of(context)!.productName,
              ),
              const SizedBox(height: 16),
              CustomFormField(
                controller: _descController,
                hint: AppLocalizations.of(context)!.productDescription,
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              CustomFormField(
                controller: _priceController,
                hint: AppLocalizations.of(context)!.productPrice,
                maxLines: 1,
                textInputType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              CustomFormField(
                controller: _catController,
                hint: AppLocalizations.of(context)!.productCategory,
                maxLines: 1,
              ),
              const SizedBox(height: 16),
              CustomFormField(
                controller: _quantityController,
                hint: AppLocalizations.of(context)!.productQuantity,
                maxLines: 1,
                textInputType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomFormField(
                      controller: _sizeController,
                      hint: AppLocalizations.of(context)!.enterSize,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_sizeController.text.isNotEmpty &&
                          !_sizes.contains(_sizeController.text.trim())) {
                        setState(() {
                          _sizes.add(_sizeController.text.trim());
                          _sizeController.clear();
                        });
                      }
                    },
                    child: const Icon(Icons.add),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Wrap(
                spacing: 8,
                children: _sizes
                    .map(
                      (size) => Chip(
                        backgroundColor: AppColors.whiteColor,
                        label: Text(size),
                        deleteIcon: const Icon(Icons.close),
                        onDeleted: () {
                          setState(() {
                            _sizes.remove(size);
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              BlocConsumer<DashboardCubit, DashboardState>(
                listener: (context, state) {
                  if (state.isLoaded == true) {
                    getIt<NavigationService>().showToast(
                      AppLocalizations.of(context)!.productAdded,
                    );

                    setState(() {
                      _productImage = null;
                      _sizes.clear();
                    });
                    _nameController.clear();
                    _descController.clear();
                    _priceController.clear();
                    _catController.clear();
                    _quantityController.clear();
                  }

                  if (state.error != "") {
                    getIt<NavigationService>().showToast(state.error);
                  }
                },
                builder: (context, state) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (state.isLoading == true)
                          ? null
                          : () {
                              if (_productImage != null &&
                                  _nameController.text.isNotEmpty &&
                                  _descController.text.isNotEmpty &&
                                  _priceController.text.isNotEmpty &&
                                  _catController.text.isNotEmpty &&
                                  _sizes.isNotEmpty &&
                                  _quantityController.text.isNotEmpty) {
                                print(_productImage?.path);
                                context.read<DashboardCubit>().addProduct(
                                  _productImage!.path,
                                  _nameController.text,
                                  _descController.text,
                                  _priceController.text,
                                  _catController.text,
                                  _quantityController.text,
                                  _sizes,
                                );
                              } else {
                                getIt<NavigationService>().showToast(
                                  AppLocalizations.of(context)!.enterAllData,
                                );
                                return;
                              }
                            },
                      child: Text(
                        (state.isLoading == true)
                            ? AppLocalizations.of(context)!.loading
                            : AppLocalizations.of(context)!.addProduct,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
