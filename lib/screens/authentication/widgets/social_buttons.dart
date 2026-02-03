import 'package:boo/controllers/auth_cubit/auth_cubit.dart';
import 'package:boo/core/services/get_init.dart';
import 'package:boo/core/services/navigation_service.dart';
import 'package:boo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_images.dart';
import '../../main_screen/main_screen_buyer/main_screen_buyer.dart';
import '../../main_screen/main_screen_seller/main_screen_seller.dart';

class SocialAuthButtons extends StatelessWidget {
  final String userType;

  const SocialAuthButtons({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(thickness: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                AppLocalizations.of(context)!.orContinueWith,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.primaryColor),
              ),
            ),
            Expanded(child: Divider(thickness: 1)),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildGoogle(context),
            const SizedBox(width: 16),
            _buildFacebook(context),
          ],
        ),
      ],
    );
  }

  Widget _buildGoogle(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: _listener,
      builder: (context, state) {
        return _socialButton(
          icon: AppImages.google,
          onTap: () {
          },
        );
      },
    );
  }

  Widget _buildFacebook(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: _listener,
      builder: (context, state) {
        return _socialButton(
          icon: AppImages.facebook,
          onTap: () {
          },
        );
      },
    );
  }

  void _listener(BuildContext context, AuthState state) {
    if (state is AuthSocialLoaded && state.isLoaded == true) {
      if (state.userType == "seller") {
        getIt<NavigationService>().navigatePushReplace(MainScreenSeller());
      } else {
        getIt<NavigationService>().navigatePushReplace(MainScreenBuyer());
      }
    }

    if (state is AuthError) {
      getIt<NavigationService>().showToast(state.error);
    }
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
