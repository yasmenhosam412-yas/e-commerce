import 'package:boo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_padding.dart';
import '../../../core/widgets/custom_form_field.dart';
import '../widgets/gredient_button.dart';
import '../widgets/social_buttons.dart';

class SignupTab extends StatelessWidget {
  const SignupTab({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
  });

  final TextEditingController nameController;
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
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            CustomFormField(
              controller: nameController,
              label: AppLocalizations.of(context)!.fullName,
              hint: AppLocalizations.of(context)!.enterName,
              prefixIcon: Icon(Icons.person_outline),
              validator: (value) {
                if (value == null || value.isEmpty) return AppLocalizations.of(context)!.nameRequired;
                if (value.length < 3) return AppLocalizations.of(context)!.nameMinChars;
                return null;
              },
            ),
            SizedBox(height: AppPadding.large),
            CustomFormField(
              controller: emailController,
              label: AppLocalizations.of(context)!.email,
              hint: AppLocalizations.of(context)!.enterEmail,
              prefixIcon: Icon(Icons.alternate_email),
              validator: (value) {
                if (value == null || value.isEmpty) return AppLocalizations.of(context)!.emailRequired;
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
                if (value == null || value.isEmpty) return AppLocalizations.of(context)!.passwordRequired;
                if (value.length < 6) {
                  return AppLocalizations.of(context)!.passwordMin;
                }
                return null;
              },
            ),
            SizedBox(height: AppPadding.xxlarge),
            GradientButton(
              text: AppLocalizations.of(context)!.createAccount,
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
