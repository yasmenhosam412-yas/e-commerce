import 'package:boo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_images.dart';
import '../../../core/utils/app_padding.dart';

class SocialAuthButtons extends StatelessWidget {
  const SocialAuthButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(thickness: 1, color: AppColors.grey300)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                AppLocalizations.of(context)!.orContinueWith,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.grey500),
              ),
            ),
            Expanded(child: Divider(thickness: 1, color: AppColors.grey300)),
          ],
        ),
        SizedBox(height: AppPadding.large),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _socialButton(icon: AppImages.google, onTap: () {}),
            SizedBox(width: 16),
            _socialButton(icon: AppImages.facebook, onTap: () {}),
          ],
        ),
      ],
    );
  }

  Widget _socialButton({required String icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.grey300),
        ),
        child: Center(child: Image.asset(icon, height: 32)),
      ),
    );
  }
}
