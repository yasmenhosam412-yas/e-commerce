import 'dart:io';

import 'package:boo/controllers/stores_cubit/dashboard_cubit/dashboard_state.dart';
import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/core/utils/app_padding.dart';
import 'package:boo/core/widgets/custom_form_field.dart';
import 'package:boo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../controllers/stores_cubit/dashboard_cubit/dashboard_cubit.dart';

enum BadgePosition { topLeft, topRight, bottomLeft, bottomRight }

class CreateAdsScreen extends StatefulWidget {
  const CreateAdsScreen({super.key});

  @override
  State<CreateAdsScreen> createState() => _CreateAdsScreenState();
}

class _CreateAdsScreenState extends State<CreateAdsScreen> {
  File? _image;

  final TextEditingController _badgeController = TextEditingController();

  Color _badgeColor = AppColors.primaryColor;
  Color _badgeTextColor = Colors.white;

  BadgePosition _badgePosition = BadgePosition.topLeft;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  void _pickColor({
    required Color currentColor,
    required ValueChanged<Color> onSelected,
  }) {
    Color tempColor = currentColor;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          "Pick color",
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: AppColors.whiteColor),
        ),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: currentColor,
            onColorChanged: (c) => tempColor = c,
            enableAlpha: true,
            displayThumbColor: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              onSelected(tempColor);
              Navigator.pop(context);
            },
            child: const Text("Done"),
          ),
        ],
      ),
    );
  }

  Positioned _buildBadge() {
    double? top;
    double? bottom;
    double? left;
    double? right;

    switch (_badgePosition) {
      case BadgePosition.topLeft:
        top = 12;
        left = 12;
        break;
      case BadgePosition.topRight:
        top = 12;
        right = 12;
        break;
      case BadgePosition.bottomLeft:
        bottom = 12;
        left = 12;
        break;
      case BadgePosition.bottomRight:
        bottom = 12;
        right = 12;
        break;
    }

    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: _badgeColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          _badgeController.text.isEmpty ? "Badge" : _badgeController.text,
          style: TextStyle(color: _badgeTextColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildAdPreview() {
    return GestureDetector(
      onTap: _pickImage,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              _image != null
                  ? Image.file(
                      _image!,
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 220,
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Icon(Icons.add_photo_alternate, size: 50),
                      ),
                    ),
              _buildBadge(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPositionSelector() {
    return Wrap(
      spacing: 8,
      children: BadgePosition.values.map((position) {
        final selected = _badgePosition == position;
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: ChoiceChip(
            showCheckmark: false,
            backgroundColor: AppColors.whiteColor,
            selectedColor: AppColors.primaryColor,
            label: Text(
              position.name,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: (!selected) ? AppColors.primaryColor : Colors.white,
              ),
            ),
            selected: selected,
            onSelected: (_) {
              setState(() => _badgePosition = position);
            },
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Ad"),
        backgroundColor: AppColors.primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAdPreview(),

            const SizedBox(height: 24),

            CustomFormField(
              controller: _badgeController,
              hint: "Badge Text",
              onChanged: (_) {
                setState(() {});
                return null;
              },
            ),

            const SizedBox(height: 16),

            Text(
              "Badge Position",
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: AppColors.primaryColor),
            ),
            const SizedBox(height: 8),
            _buildPositionSelector(),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickColor(
                      currentColor: _badgeColor,
                      onSelected: (c) => setState(() => _badgeColor = c),
                    ),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          "Badge Color",
                          style: TextStyle(color: AppColors.whiteColor),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickColor(
                      currentColor: _badgeTextColor,
                      onSelected: (c) => setState(() => _badgeTextColor = c),
                    ),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Center(
                        child: Text(
                          "Text Color",
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(color: AppColors.whiteColor),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: AppPadding.xxlarge),

            BlocConsumer<DashboardCubit, DashboardState>(
              listener: (context, state) {
                if (state.isLoaded) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.saved),
                    ),
                  );

                  _badgeController.clear();
                }
                if (state.error != "") {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.error)));
                }
              },
              builder: (context, state) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (state.isLoading)
                        ? null
                        : () async {
                            if (_image == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppLocalizations.of(context)!.selectImage,
                                  ),
                                ),
                              );
                              return;
                            }

                            if (_badgeController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppLocalizations.of(context)!.enterBadge,
                                  ),
                                ),
                              );
                              return;
                            }

                            String positionStr = _badgePosition.name;

                            await context.read<DashboardCubit>().addAds(
                              _image!,
                              _badgeController.text,
                              positionStr,
                              _badgeColor.toHexString(),
                              _badgeTextColor.toHexString(),
                            );
                          },
                    child: Text(
                      (state.isLoading)
                          ? AppLocalizations.of(context)!.loading
                          : AppLocalizations.of(context)!.save,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
