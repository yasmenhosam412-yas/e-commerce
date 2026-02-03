import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/core/utils/app_padding.dart';
import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType? textInputType;
  final String? label;
  final String? hint;
  final String? Function(String? value)? validator;
  final String? Function(String? value)? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final int? maxLines;
  final bool? readOnly;
  final VoidCallback? onTap;

  const CustomFormField({
    super.key,
    required this.controller,
    this.textInputType,
    this.hint,
    this.validator,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.maxLines,
    this.onChanged,
    this.readOnly,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      validator: validator,
      obscureText: obscureText,
      readOnly: readOnly ?? false,
      onTap: onTap ?? () {},
      maxLines: maxLines ?? 1,
      onChanged: onChanged,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: AppColors.darkBlack,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppPadding.medium,
          vertical: AppPadding.medium,
        ),
        hintText: hint,
        labelText: label,
        hintStyle: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(color: Colors.grey.shade500),
        labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: Colors.grey.shade700,
          fontSize: 16,
        ),
        floatingLabelStyle: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(color: AppColors.primaryColor),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red),
        ),

        errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }
}
