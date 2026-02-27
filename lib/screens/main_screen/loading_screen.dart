import 'package:boo/controllers/manage_cubit/manage_cubit.dart';
import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/core/utils/app_images.dart';
import 'package:boo/core/utils/app_padding.dart';
import 'package:boo/l10n/app_localizations.dart';
import 'package:boo/screens/authentication/widgets/gredient_button.dart';
import 'package:boo/screens/main_screen/main_screen_seller/main_screen_seller.dart';
import 'package:boo/screens/main_screen/main_screen_seller/seller_creation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import 'main_screen_buyer/main_screen_buyer.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ManageCubit>().userTypeAndStore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ManageCubit, ManageState>(
        builder: (context, state) {
          if (state is ManageLoading) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 180,
                    child: Lottie.asset(
                      AppImages.loading2,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    AppLocalizations.of(context)!.loading2,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(
                    width: 120,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.white24,
                      color: AppColors.primaryColor,
                      minHeight: 4,
                    ),
                  ),
                ],
              ),
            );
          }
          if (state is ManageLoaded) {
            if (state.userType == "seller" && state.hasStore == true) {
              return MainScreenSeller();
            } else if (state.userType == "seller" && state.hasStore == false) {
              return SellerCreationScreen();
            } else {
              return MainScreenBuyer();
            }
          }
          if (state is ManageError) {
            return Padding(
              padding: const EdgeInsets.all(AppPadding.medium),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 180,
                    child: Lottie.asset(AppImages.error, fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    state.error,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  GradientButton(
                    text: AppLocalizations.of(context)!.retry,
                    onPressed: () {
                      context.read<ManageCubit>().userTypeAndStore();
                    },
                  ),
                ],
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
