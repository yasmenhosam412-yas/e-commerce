import 'package:boo/controllers/manage_cubit/manage_cubit.dart';
import 'package:boo/controllers/locale_cubit.dart';
import 'package:boo/core/models/user_model.dart';
import 'package:boo/core/services/navigation_service.dart';
import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/l10n/app_localizations.dart';
import 'package:boo/screens/on_boarding/on_boarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/get_init.dart';
import 'info_screen.dart';
import 'orders_screen.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile"), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          BlocBuilder<ManageCubit, ManageState>(
            builder: (context, state) {
              if (state is ManageLoaded) {
                return Column(
                  children: [
                    (state.userModel?.photoURL.isNotEmpty == true)
                        ? CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(
                              state.userModel?.photoURL ?? "",
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor: AppColors.primaryColor.withValues(
                              alpha: 0.24,
                            ),
                            radius: 40,
                            child: Icon(
                              Icons.person,
                              color: AppColors.whiteColor,
                            ),
                          ),
                    const SizedBox(height: 12),
                    Text(
                      state.userModel?.displayName ?? "",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      state.userModel?.email ?? "",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),

          const SizedBox(height: 24),

          _profileItem(
            icon: Icons.local_shipping_outlined,
            title: AppLocalizations.of(context)!.myOrders,
            onTap: () {
              getIt<NavigationService>().navigatePush(
                BlocBuilder<ManageCubit, ManageState>(
                  builder: (context, state) {
                    if (state is ManageLoaded) {
                      return OrdersScreen(
                        userModel:
                            state.userModel ??
                            UserModel(
                              uid: "",
                              email: "",
                              displayName: "",
                              photoURL: "",
                              userType: "",
                              phone: "",
                              address: "",
                              location: "",
                              governorate: "",
                            ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              );
            },
          ),
          _profileItem(
            icon: Icons.data_array,
            title: AppLocalizations.of(context)!.myInfo,
            onTap: () {
              getIt<NavigationService>().navigatePush(
                BlocBuilder<ManageCubit, ManageState>(
                  builder: (context, state) {
                    if (state is ManageLoaded) {
                      return InfoScreen(userModel: state.userModel);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              );
            },
          ),

          BlocBuilder<LocaleCubit, Locale>(
            builder: (context, locale) {
              return _profileItem(
                icon: Icons.language,
                title: locale.languageCode == 'en' ? "العربية" : "English",
                onTap: () {
                  context.read<LocaleCubit>().toggleLanguage();
                },
              );
            },
          ),

          const Divider(height: 32),

          _profileItem(
            icon: Icons.logout,
            title: AppLocalizations.of(context)!.signout,
            color: Colors.red,
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              getIt<NavigationService>().navigatePushRemoveUntil(
                const OnBoardingScreen(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _profileItem({
    required IconData icon,
    required String title,
    Color color = Colors.black,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
