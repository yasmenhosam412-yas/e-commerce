import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import 'gredient_button.dart';
import '../../../core/utils/app_padding.dart';
import '../../../core/widgets/custom_form_field.dart';

class ForgotPasswordWidget extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ForgotPasswordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        padding: EdgeInsets.all(AppPadding.large),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: Offset(0, -10),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),

                Text(
                  AppLocalizations.of(context)!.forgotPasswordTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),

                SizedBox(height: AppPadding.medium),
                Text(
                  AppLocalizations.of(context)!.forgotPasswordDescription,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),

                SizedBox(height: AppPadding.xxlarge),
                CustomFormField(
                  controller: emailController,
                  label: AppLocalizations.of(context)!.email,
                  hint: AppLocalizations.of(context)!.enterEmail,
                  prefixIcon: Icon(Icons.alternate_email),
                  textInputType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.emailRequired;
                    }
                    final emailRegex = RegExp(r'\S+@\S+\.\S+');
                    if (!emailRegex.hasMatch(value)) {
                      return AppLocalizations.of(context)!.emailInvalid;
                    }
                    return null;
                  },
                ),

                SizedBox(height: AppPadding.xxlarge),

                GradientButton(
                  text: AppLocalizations.of(context)!.sendResetLink,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.of(context).pop();
                    }
                  },
                ),

                SizedBox(height: AppPadding.large),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
