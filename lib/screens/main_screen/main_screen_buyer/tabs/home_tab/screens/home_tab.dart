import 'package:boo/core/models/banner_model.dart';
import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/core/utils/app_padding.dart';
import 'package:boo/l10n/app_localizations.dart';
import 'package:boo/screens/main_screen/main_screen_buyer/tabs/home_tab/widgets/mixed_list.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../widgets/banner_item.dart';
import '../widgets/feature_pick_list.dart';
import '../widgets/shop_list_widget.dart';
import '../widgets/user_budget_selector.dart';
import '../widgets/want_to_sell_list.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final List<BannerModel> banners = [
    BannerModel(
      isNewShop: true,
      hasDiscount: false,
      isBestSelling: false,
      isUserAllow: false,
      image:
          "https://tse1.mm.bing.net/th/id/OIP.79xrm2hm2KK2zC1DQsoz-wHaEK?rs=1&pid=ImgDetMain&o=7&rm=3",
    ),
    BannerModel(
      isNewShop: false,
      hasDiscount: true,
      isBestSelling: false,
      isUserAllow: true,
      image:
          "https://images.vexels.com/media/users/3/194701/list/aa72abca784117244de372b5e9926988-online-shopping-slider-template.jpg",
    ),
    BannerModel(
      isNewShop: false,
      hasDiscount: false,
      isBestSelling: true,
      isUserAllow: true,
      image:
          "https://images.vexels.com/media/users/3/194698/raw/34d9aa618f832510ce7290b4f183484a-shop-online-slider-template.jpg",
    ),
  ];

  late final List<BannerModel> allowedBanners;
  int currentIndex = -1;

  @override
  void initState() {
    super.initState();
    allowedBanners = banners.where((b) => b.isUserAllow).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.medium),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppPadding.medium,
              children: [
                SizedBox(height: AppPadding.large),
                CarouselSlider(
                  items: allowedBanners.map((banner) {
                    return BannerItem(banner: banner);
                  }).toList(),
                  options: CarouselOptions(
                    autoPlay: true,
                    enableInfiniteScroll: allowedBanners.length > 1,
                    aspectRatio: 2.5,
                    enlargeCenterPage: true,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.shops,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                ShopListWidget(),
                SizedBox(height: AppPadding.large),
                Text(
                  AppLocalizations.of(context)!.samples,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                FeaturedPickList(),
                SizedBox(height: AppPadding.large),
                Text(
                  AppLocalizations.of(context)!.usersWantToSell,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                WantToSellList(),
                SizedBox(height: AppPadding.large),
                BudgetFilter(),
                MixedList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
