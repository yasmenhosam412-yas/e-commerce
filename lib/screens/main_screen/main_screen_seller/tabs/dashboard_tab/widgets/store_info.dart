import 'dart:io';

import 'package:boo/core/services/navigation_service.dart';
import 'package:boo/core/widgets/cached_image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../core/services/get_init.dart';
import '../../../../../../core/utils/app_colors.dart';
import '../../../../../../core/utils/app_padding.dart';
import '../../../../../../core/widgets/custom_form_field.dart';
import '../../../../../../l10n/app_localizations.dart';

class StoreInfo extends StatefulWidget {
  final Function(String name, String category, String desc, String image)
  onClick;
  final String name;
  final String category;
  final String desc;
  final String image;

  const StoreInfo({
    super.key,
    required this.onClick,
    required this.name,
    required this.category,
    required this.desc,
    required this.image,
  });

  @override
  State<StoreInfo> createState() => _StoreInfoState();
}

class _StoreInfoState extends State<StoreInfo> {
  late TextEditingController storeName;
  late TextEditingController storeCategory;
  late TextEditingController storeDesc;
  File? selectedImage;
  GlobalKey<FormState> globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    storeName = TextEditingController(text: widget.name);
    storeCategory = TextEditingController(text: widget.category);
    storeDesc = TextEditingController(text: widget.desc);
    if (widget.image.isNotEmpty) {
      selectedImage = File(widget.image);
    }
  }

  @override
  void dispose() {
    super.dispose();
    storeName.dispose();
    storeCategory.dispose();
    storeDesc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setModalState) {
        return SingleChildScrollView(
          child: Form(
            key: globalKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)!.title1,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(height: AppPadding.medium),

                GestureDetector(
                  onTap: () => _pickImage((file) {
                    setModalState(() {
                      selectedImage = file;
                    });
                  }),
                  child: selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: (widget.image.startsWith('http') == true)
                              ? SizedBox(
                                  width: 105,
                                  height : 105,
                                  child: CachedImageWidget(
                                    imagePath: widget.image,
                                  ),
                                )
                              : Image.file(
                                  selectedImage!,
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                ),
                        )
                      : Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.add_a_photo,
                            color: Colors.grey[600],
                          ),
                        ),
                ),
                SizedBox(height: AppPadding.large),

                CustomFormField(
                  controller: storeName,
                  hint: AppLocalizations.of(context)!.storeName,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppLocalizations.of(context)!.requiredField;
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppPadding.medium),
                CustomFormField(
                  controller: storeDesc,
                  hint: AppLocalizations.of(context)!.storeDesc,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppLocalizations.of(context)!.requiredField;
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppPadding.medium),
                CustomFormField(
                  controller: storeCategory,
                  hint: AppLocalizations.of(context)!.storeCategory,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppLocalizations.of(context)!.requiredField;
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppPadding.xxlarge),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedImage?.path == null) {
                        getIt<NavigationService>().showToast(
                          AppLocalizations.of(context)!.imageRequired,
                        );
                        return;
                      }
                      if (globalKey.currentState!.validate()) {
                        widget.onClick(
                          storeName.text,
                          storeCategory.text,
                          storeDesc.text,
                          selectedImage!.path,
                        );
                      }
                    },
                    child: Text(
                      AppLocalizations.of(context)!.save,
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: AppPadding.xxlarge),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage(Function(File) onImageSelected) async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
      imageQuality: 80,
    );
    if (image != null) {
      final file = File(image.path);
      onImageSelected(file);
    }
  }
}
