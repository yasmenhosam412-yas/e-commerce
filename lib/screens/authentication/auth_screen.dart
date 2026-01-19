import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/core/utils/app_images.dart';
import 'package:boo/core/utils/app_padding.dart';
import 'package:boo/l10n/app_localizations.dart';
import 'package:boo/screens/authentication/tabs/login_tab.dart';
import 'package:boo/screens/authentication/tabs/signup_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  GlobalKey<FormState> loginKey = GlobalKey();
  GlobalKey<FormState> signupKey = GlobalKey();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppPadding.large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              SvgPicture.asset(AppImages.auth, height: 220),

              SizedBox(height: 30),

              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.grey200,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelColor: AppColors.whiteColor,
                  unselectedLabelColor: AppColors.darkBlack,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  tabs: [
                    Tab(text: AppLocalizations.of(context)!.authLogin),
                    Tab(text: AppLocalizations.of(context)!.authSignup),
                  ],
                ),
              ),

              SizedBox(height: 30),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    LoginTab(
                      emailController: emailController,
                      passwordController: passwordController,
                      formKey: loginKey,
                    ),
                    SignupTab(
                      emailController: emailController,
                      passwordController: passwordController,
                      nameController: nameController,
                      formKey: signupKey,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
