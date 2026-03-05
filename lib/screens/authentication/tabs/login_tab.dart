import 'package:boo/controllers/auth_cubit/auth_cubit.dart';
import 'package:boo/screens/main_screen/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/services/get_init.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_padding.dart';
import '../../../core/widgets/custom_form_field.dart';
import '../../../l10n/app_localizations.dart';
import '../widgets/forget_password_widget.dart';
import '../widgets/gredient_button.dart';

class LoginTab extends StatefulWidget {
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
  State<LoginTab> createState() => _LoginTabState();
}

class _LoginTabState extends State<LoginTab> {
  bool isBuyerSelected = true;
  FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppPadding.large),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomFormField(
              controller: widget.emailController,
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
              controller: widget.passwordController,
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
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthLoaded) {
                  getIt<NavigationService>().navigatePushReplace(
                    LoadingScreen(),
                  );
                }

                if (state is AuthError) {
                  getIt<NavigationService>().showToast(state.error);
                }
              },
              builder: (context, state) {
                return GradientButton(
                  text: (state is AuthLoading)
                      ? AppLocalizations.of(context)!.loading
                      : AppLocalizations.of(context)!.authLogin,
                  onPressed: (state is AuthLoading)
                      ? null
                      : () {
                          if (widget.formKey.currentState!.validate()) {
                            context.read<AuthCubit>().signInWithEmail(
                              widget.emailController.text,
                              widget.passwordController.text,
                            );
                          }
                        },
                );
              },
            ),
            SizedBox(height: AppPadding.large),
          ],
        ),
      ),
    );
  }
}
