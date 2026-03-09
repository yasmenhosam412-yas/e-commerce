import 'package:boo/core/utils/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:boo/core/utils/app_colors.dart';

class CustomDropdown extends StatelessWidget {
  final String? value;
  final String label;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.label,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      dropdownColor: Colors.white,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(color: AppColors.primaryColor),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 1),
          borderRadius: BorderRadius.circular(AppPadding.medium),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 1),
          borderRadius: BorderRadius.circular(AppPadding.medium),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 1),
          borderRadius: BorderRadius.circular(AppPadding.medium),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 1),
          borderRadius: BorderRadius.circular(AppPadding.medium),
        ),
      ),
      style: Theme.of(
        context,
      ).textTheme.labelLarge?.copyWith(color: AppColors.primaryColor),
      items: items
          .map(
            (item) => DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: AppColors.primaryColor),
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
