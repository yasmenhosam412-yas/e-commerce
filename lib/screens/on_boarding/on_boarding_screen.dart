import 'package:boo/core/services/get_init.dart';
import 'package:boo/core/services/navigation_service.dart';
import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/core/utils/app_images.dart';
import 'package:boo/screens/authentication/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/models/onboarding_model.dart';
import '../../l10n/app_localizations.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _firstBuild = true;

  late final List<OnboardingModel> _dataList;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _firstBuild = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _dataList = [
      OnboardingModel(
        title: AppLocalizations.of(context)!.onboardingTitle1,
        subtitle: AppLocalizations.of(context)!.onboardingSubtitle1,
        description: AppLocalizations.of(context)!.onboardingDescription1,
        image: AppImages.board1,
      ),
      OnboardingModel(
        title: AppLocalizations.of(context)!.onboardingTitle2,
        subtitle: AppLocalizations.of(context)!.onboardingSubtitle2,
        description: AppLocalizations.of(context)!.onboardingDescription2,
        image: AppImages.board2,
      ),
      OnboardingModel(
        title: AppLocalizations.of(context)!.onboardingTitle3,
        subtitle: AppLocalizations.of(context)!.onboardingSubtitle3,
        description: AppLocalizations.of(context)!.onboardingDescription3,
        image: AppImages.board3,
      ),
    ];
  }

  bool _isVisible(int index) {
    return _firstBuild || _currentPage == index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _dataList.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final data = _dataList[index];
                  final visible = _isVisible(index);

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 40,
                    ),
                    child: Column(
                      children: [
                        AnimatedSlide(
                          duration: const Duration(milliseconds: 800),
                          offset: visible
                              ? Offset.zero
                              : const Offset(0.0, 0.3),
                          curve: Curves.easeOut,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 800),
                            opacity: visible ? 1 : 0,
                            child: SvgPicture.asset(
                              data.image,
                              height:
                              MediaQuery.sizeOf(context).width * 0.8,
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        AnimatedSlide(
                          duration: const Duration(milliseconds: 800),
                          offset: visible
                              ? Offset.zero
                              : const Offset(0.0, 0.3),
                          curve: Curves.easeOut,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 800),
                            opacity: visible ? 1 : 0,
                            child: Column(
                              children: [
                                Text(
                                  data.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  data.subtitle,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                    color: AppColors.primaryColor
                                        .withValues(alpha: 0.8),
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  data.description,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                    color: AppColors.primaryColor
                                        .withValues(alpha: 0.7),
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _dataList.length,
                    (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: _currentPage == index ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppColors.primaryColor
                        : AppColors.primaryColor.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage < _dataList.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    } else {
                      getIt<NavigationService>().navigatePushReplace(
                        AuthScreen(),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _currentPage == _dataList.length - 1
                        ? AppLocalizations.of(context)!.getStarted
                        : AppLocalizations.of(context)!.next,
                    style:
                    const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
