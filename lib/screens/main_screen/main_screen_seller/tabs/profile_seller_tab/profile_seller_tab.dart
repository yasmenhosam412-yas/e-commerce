import 'package:boo/controllers/manage_cubit/manage_cubit.dart';
import 'package:boo/controllers/locale_cubit.dart';
import 'package:boo/core/services/get_init.dart';
import 'package:boo/core/services/navigation_service.dart';
import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/l10n/app_localizations.dart';
import 'package:boo/screens/authentication/auth_screen.dart';
import 'package:boo/screens/main_screen/main_screen_seller/seller_creation_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../main_screen_buyer/tabs/profile_tab/info_screen.dart';

class ProfileSellerTab extends StatefulWidget {
  const ProfileSellerTab({super.key});

  @override
  State<ProfileSellerTab> createState() => _ProfileSellerTabState();
}

class _ProfileSellerTabState extends State<ProfileSellerTab> {
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
                final hasStore = state.hasStore ?? false;
                final store = state.createStoreModel;
                final user = state.userModel;

                return Column(
                  children: [
                    if (hasStore && store?.selectedImage.isNotEmpty == true)
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(store!.selectedImage),
                      )
                    else if (user?.photoURL.isNotEmpty == true)
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(user!.photoURL),
                      )
                    else
                      CircleAvatar(
                        backgroundColor: AppColors.primaryColor.withValues(
                          alpha: 0.24,
                        ),
                        radius: 40,
                        child: const Icon(
                          Icons.person,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    const SizedBox(height: 12),
                    Text(
                      hasStore
                          ? (store?.selectedName ?? "")
                          : (user?.displayName ?? ""),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hasStore
                          ? (store?.selectedEmail ?? "")
                          : (user?.email ?? ""),
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
            icon: Icons.store_outlined,
            title: AppLocalizations.of(context)!.myStore,
            onTap: () {
              getIt<NavigationService>().navigatePush(
                const SellerCreationScreen(),
              );
            },
          ),
          _profileItem(
            icon: Icons.person_outline,
            title: AppLocalizations.of(context)!.myInfo,
            onTap: () {
              final state = context.read<ManageCubit>().state;
              if (state is ManageLoaded) {
                getIt<NavigationService>().navigatePush(
                  InfoScreen(userModel: state.userModel),
                );
              }
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
                const AuthScreen(),
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
