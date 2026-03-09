import 'dart:io';

import 'package:boo/controllers/stores_cubit/dashboard_cubit/dashboard_cubit.dart';
import 'package:boo/controllers/stores_cubit/dashboard_cubit/dashboard_state.dart';
import 'package:boo/core/models/create_store_model.dart';
import 'package:boo/core/models/products_model.dart';
import 'package:boo/core/services/get_init.dart';
import 'package:boo/core/services/navigation_service.dart';
import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/core/widgets/cached_image_widget.dart';
import 'package:boo/core/widgets/custom_form_field.dart';
import 'package:boo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddProductScreen extends StatefulWidget {
  final ProductsModel? productsModel;
  final CreateStoreModel? createStoreModel;

  const AddProductScreen({
    super.key,
    this.productsModel,
    this.createStoreModel,
  });

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

  final _attributeNameController = TextEditingController();
  final _attributeValueController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  final List<File> _pickedImages = [];
  List<String> _existingImages = [];

  Map<String, List<String>> _attributes = {};

  bool get isEditing => widget.productsModel != null;
  final List<String> _sizes = [];

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      final p = widget.productsModel!;
      _nameController.text = p.name;
      _descController.text = p.desc;
      _priceController.text = p.price.toString();
      _catController.text = p.category;
      _quantityController.text = p.quantity.toString();
      _existingImages = List.from(p.images);
      _attributes = Map.from(p.attributes);
      _sizes.addAll(widget.productsModel!.sizes);
    }
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

  void _addAttributeValue() {
    final name = _attributeNameController.text.trim();
    final value = _attributeValueController.text.trim();

    if (name.isEmpty || value.isEmpty) return;

    setState(() {
      _attributes.putIfAbsent(name, () => []);
      if (!_attributes[name]!.contains(value)) {
        _attributes[name]!.add(value);
      }
      _attributeValueController.clear();
    });
  }

  void _submit() {
    final hasImages = _pickedImages.isNotEmpty || _existingImages.isNotEmpty;

    if (!hasImages ||
        _nameController.text.isEmpty ||
        _descController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _catController.text.isEmpty ||
        _quantityController.text.isEmpty) {
      getIt<NavigationService>().showToast(
        AppLocalizations.of(context)!.enterAllData,
      );
      return;
    }

    if (isEditing) {
      context.read<DashboardCubit>().updateProduct(
        productId: widget.productsModel!.id.toString(),
        images: _pickedImages.map((e) => e.path).toList(),
        name: _nameController.text,
        desc: _descController.text,
        price: double.parse(_priceController.text),
        category: _catController.text,
        quantity: int.parse(_quantityController.text),
        attributes: _attributes,
        isFeatured: widget.productsModel!.isFeatured,
        sizes: _sizes,
      );
    } else {
      context.read<DashboardCubit>().addProduct(
        images: _pickedImages.map((e) => e.path).toList(),
        name: _nameController.text,
        desc: _descController.text,
        price: _priceController.text,
        category: _catController.text,
        quantity: _quantityController.text,
        attributes: _attributes,
        sizes: _sizes,
        store:
            widget.createStoreModel ??
            CreateStoreModel(
              selectedName: "",
              selectedDesc: "",
              selectedCat: "",
              selectedPhone: "",
              selectedEmail: "",
              selectedAddress: "",
              selectedFees: "",
              selectedDelivery: "",
              selectedImage: "",
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: Text(
          isEditing
              ? AppLocalizations.of(context)!.editProduct
              : AppLocalizations.of(context)!.addProduct,
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                textInputType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              CustomFormField(
                controller: _catController,
                hint: AppLocalizations.of(context)!.productCategory,
              ),
              const SizedBox(height: 16),
              CustomFormField(
                controller: _quantityController,
                hint: AppLocalizations.of(context)!.productQuantity,
                textInputType: TextInputType.number,
              ),
              const SizedBox(height: 24),
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
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.attributes,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              CustomFormField(
                controller: _attributeNameController,
                hint: AppLocalizations.of(context)!.attributeName,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: CustomFormField(
                      controller: _attributeValueController,
                      hint: AppLocalizations.of(context)!.attributeValue,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addAttributeValue,
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Column(
                children: _attributes.entries.map((e) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.key,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: e.value
                            .map(
                              (v) => Chip(
                                color: const WidgetStatePropertyAll(
                                  AppColors.whiteColor,
                                ),
                                label: Text(v),
                                onDeleted: () {
                                  setState(() {
                                    e.value.remove(v);
                                    if (e.value.isEmpty) {
                                      _attributes.remove(e.key);
                                    }
                                  });
                                },
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 8),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              BlocConsumer<DashboardCubit, DashboardState>(
                listener: (context, state) {
                  if (state.isLoaded == true) {
                    getIt<NavigationService>().showToast(
                      isEditing
                          ? AppLocalizations.of(context)!.productUpdated
                          : AppLocalizations.of(context)!.productAdded,
                    );
                    if (isEditing) {
                      Navigator.pop(context);
                    } else {
                      _nameController.clear();
                      _descController.clear();
                      _priceController.clear();
                      _catController.clear();
                      _quantityController.clear();
                      _pickedImages.clear();
                      _existingImages.clear();
                      setState(() {
                        _attributes.clear();
                        _sizes.clear();
                      });
                    }
                  }
                  if (state.error.isNotEmpty) {
                    getIt<NavigationService>().showToast(state.error);
                  }
                },
                builder: (context, state) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state.isLoading ? null : _submit,
                      child: state.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: AppColors.whiteColor,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              isEditing
                                  ? AppLocalizations.of(context)!.editProduct
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
