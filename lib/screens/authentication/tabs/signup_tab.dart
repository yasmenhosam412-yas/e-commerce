import 'package:boo/core/services/get_init.dart';
import 'package:boo/core/services/navigation_service.dart';
import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/l10n/app_localizations.dart';
import 'package:boo/screens/main_screen/main_screen_buyer/main_screen_buyer.dart';
import 'package:boo/screens/main_screen/main_screen_seller/main_screen_seller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../controllers/auth_cubit/auth_cubit.dart';
import '../../../core/utils/app_padding.dart';
import '../../../core/widgets/custom_form_field.dart';
import '../widgets/gredient_button.dart';

class SignupTab extends StatefulWidget {
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
  State<SignupTab> createState() => _SignupTabState();
}

class _SignupTabState extends State<SignupTab> {
  bool isBuyerSelected = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppPadding.large),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
      child: Form(
        key: widget.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            CustomFormField(
              controller: widget.nameController,
              label: AppLocalizations.of(context)!.fullName,
              hint: AppLocalizations.of(context)!.enterName,
              prefixIcon: Icon(Icons.person_outline),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.nameRequired;
                }
                if (value.length < 3) {
                  return AppLocalizations.of(context)!.nameMinChars;
                }
                return null;
              },
            ),
            SizedBox(height: AppPadding.large),
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
            SizedBox(height: AppPadding.xxlarge),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: (isBuyerSelected)
                          ? AppColors.primaryColor
                          : AppColors.whiteColor,

                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppPadding.large),
                      ),
                      side: BorderSide(color: AppColors.primaryColor, width: 2),
                    ),
                    onPressed: () {
                      setState(() {
                        isBuyerSelected = true;
                      });
                    },
                    child: Text(
                      AppLocalizations.of(context)!.buyer,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: (isBuyerSelected)
                            ? AppColors.whiteColor
                            : AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppPadding.large),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: (!isBuyerSelected)
                          ? AppColors.primaryColor
                          : AppColors.whiteColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppPadding.large),
                      ),
                      side: BorderSide(color: AppColors.primaryColor, width: 2),
                    ),
                    onPressed: () {
                      setState(() {
                        isBuyerSelected = false;
                      });
                    },
                    child: Text(
                      AppLocalizations.of(context)!.seller,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: (!isBuyerSelected)
                            ? AppColors.whiteColor
                            : AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppPadding.xxlarge),
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthLoaded) {
                  if (isBuyerSelected) {
                    getIt<NavigationService>().navigatePushReplace(
                      MainScreenBuyer(),
                    );
                  } else {
                    getIt<NavigationService>().navigatePushReplace(
                      MainScreenSeller(),
                    );
                  }
                }

                if (state is AuthError) {
                  getIt<NavigationService>().showToast(state.error);
                }
              },
              builder: (context, state) {
                return GradientButton(
                  text: (state is AuthLoading)
                      ? AppLocalizations.of(context)!.loading
                      : AppLocalizations.of(context)!.authSignup,
                  onPressed: (state is AuthLoading)
                      ? null
                      : () {
                          if (widget.formKey.currentState!.validate()) {
                            context.read<AuthCubit>().signupWithEmail(
                              widget.emailController.text,
                              widget.passwordController.text,
                              isBuyerSelected ? "buyer" : "seller",
                              widget.nameController.text,
                            );
                          }
                        },
                );
              },
            ),
            SizedBox(height: AppPadding.large),
            // SocialAuthButtons(
            //   onGoogleTap: () async {
            //     final socialService = SignSocialService();
            //     final result = await socialService.signInWithGoogle(
            //       userType: isBuyerSelected ? "buyer" : "seller",
            //       isLogin: false,
            //     );
            //
            //     if (result.success == true) {
            //       if (isBuyerSelected) {
            //         getIt<NavigationService>().navigatePushReplace(
            //           MainScreenBuyer(),
            //         );
            //       } else {
            //         getIt<NavigationService>().navigatePushReplace(
            //           MainScreenSeller(),
            //         );
            //       }
            //     } else {
            //       // getIt<NavigationService>().showToast(
            //       // result?.message ?? "",
            //       // );
            //     }
            //   },
            //   onFacebookTap: () async {
            //     final socialService = SignSocialService();
            //     final result = await socialService.signInWithFacebook(
            //       userType: isBuyerSelected ? "buyer" : "seller",
            //       isLogin: false,
            //     );
            //
            //     if (result.success == true) {
            //       if (isBuyerSelected) {
            //         getIt<NavigationService>().navigatePushReplace(
            //           MainScreenBuyer(),
            //         );
            //       } else {
            //         getIt<NavigationService>().navigatePushReplace(
            //           MainScreenSeller(),
            //         );
            //       }
            //     } else {
            //
            //     }
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
