import 'package:boo/core/models/create_store_model.dart';
import 'package:boo/core/models/products_model.dart';
import 'package:boo/core/services/navigation_service.dart';
import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/core/utils/app_padding.dart';
import 'package:boo/l10n/app_localizations.dart';
import 'package:boo/screens/main_screen/main_screen_buyer/details/shop_details.dart';
import 'package:boo/screens/main_screen/main_screen_buyer/tabs/home_tab/widgets/mixed_list.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../../controllers/buyer_cubits/home_cubit/home_cubit.dart';
import '../../../../../../core/services/get_init.dart';
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
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getFeaturedPicks();
    context.read<HomeCubit>().getAds();
    context.read<HomeCubit>().getStores();
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
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state.ads?.isNotEmpty == true) {
                      return CarouselSlider(
                        items: state.ads?.map((banner) {
                          return GestureDetector(
                            onTap: () {
                              getIt<NavigationService>().navigatePush(
                                ShopDetails(
                                  shopId: banner['storeId'],
                                  shopName: banner['storeName'],
                                  shopImage: banner['storeImage'],
                                  category: banner['storeCategory'],
                                ),
                              );
                            },
                            child: BannerItem(banner: banner),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          autoPlay: true,
                          enableInfiniteScroll: false,
                          aspectRatio: 2.5,
                          enlargeCenterPage: true,
                        ),
                      );
                    }
                    if (state.isLoadingAds == true) {
                      return Skeletonizer(
                        child: CarouselSlider(
                          items: [],
                          options: CarouselOptions(
                            autoPlay: true,
                            enableInfiniteScroll: false,
                            aspectRatio: 2.5,
                            enlargeCenterPage: true,
                          ),
                        ),
                      );
                    }
                    return Center(child: Text(state.errorAds ?? ""));
                  },
                ),
                Text(
                  AppLocalizations.of(context)!.shops,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state.stores?.isNotEmpty == true) {
                      return ShopListWidget(stores: state.stores ?? []);
                    }
                    if (state.isLoadingS == true) {
                      return Skeletonizer(
                        child: ShopListWidget(
                          stores: List.generate(
                            5,
                            (index) => CreateStoreModel(
                              selectedName: '',
                              selectedDesc: '',
                              selectedCat: '',
                              selectedPhone: '',
                              selectedEmail: '',
                              selectedAddress: '',
                              selectedFees: '',
                              selectedDelivery: '',
                              selectedImage: '',
                            ),
                          ),
                        ),
                      );
                    }
                    return Center(
                      child: Text(
                        state.errorS ?? "",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: AppPadding.large),
                Text(
                  AppLocalizations.of(context)!.samples,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state.featuredProducts?.isNotEmpty == true) {
                      return FeaturedPickList(
                        products: state.featuredProducts ?? [],
                      );
                    }
                    if (state.isLoadingF == true) {
                      return Skeletonizer(
                        child: FeaturedPickList(
                          products: List.generate(
                            5,
                            (index) => ProductsModel(
                              id: 0,
                              image: "",
                              name: "",
                              desc: "",
                              price: 0,
                              category: "",
                              quantity: 0,
                              sizes: [],
                              images: [],
                              attributes: {},
                            ),
                          ),
                        ),
                      );
                    }
                    return Center(
                      child: Text(
                        state.errorF ?? "",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    );
                  },
                ),
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
