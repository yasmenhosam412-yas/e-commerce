import 'package:flutter/material.dart';

import '../../../core/services/get_init.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_padding.dart';
import '../../../core/widgets/custom_form_field.dart';
import '../../../l10n/app_localizations.dart';
import '../widgets/forget_password_widget.dart';
import '../widgets/gredient_button.dart';
import '../widgets/social_buttons.dart';

class LoginTab extends StatelessWidget {
  const LoginTab({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppPadding.large),
      decoration: BoxDecoration(
        // color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBlack.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomFormField(
              controller: emailController,
              label: AppLocalizations.of(context)!.email,
              hint: AppLocalizations.of(context)!.enterEmail,
              prefixIcon: Icon(Icons.alternate_email),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.emailRequired;
                }
                if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                  return AppLocalizations.of(context)!.emailInvalid;
                }
                return null;
              },
            ),
            SizedBox(height: AppPadding.large),
            CustomFormField(
              controller: passwordController,
              label: AppLocalizations.of(context)!.password,
              hint: AppLocalizations.of(context)!.enterPassword,
              prefixIcon: Icon(Icons.lock_outline),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.passwordRequired;
                }
                if (value.length < 6) {
                  return AppLocalizations.of(context)!.passwordMin;
                }
                return null;
              },
            ),

            SizedBox(height: AppPadding.large),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  getIt<NavigationService>().showCustomBottomDialog(
                    content: ForgotPasswordWidget(),
                  );
                },
                child: Text(
                  AppLocalizations.of(context)!.forgotPasswordTitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            SizedBox(height: AppPadding.xxlarge),
            GradientButton(
              text: AppLocalizations.of(context)!.authLogin,
              onPressed: () {
                if (formKey.currentState!.validate()) {}
              },
            ),
            SizedBox(height: AppPadding.large),
            const SocialAuthButtons(),
          ],
        ),
      ),
    );
  }
}
