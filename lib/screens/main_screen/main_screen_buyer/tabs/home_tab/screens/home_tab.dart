import 'package:boo/controllers/buyer_cubits/sell_cubit/sell_cubit.dart';
import 'package:boo/core/models/create_store_model.dart';
import 'package:boo/core/models/products_model.dart';
import 'package:boo/core/models/user_product_model.dart';
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
  List<ProductsModel> products = [];
  List<UserProductModel> userProducts = [];

  List<ProductsModel> filteredProducts = [];
  List<UserProductModel> filteredUserProducts = [];

  double selectedMinBudget = 0;
  double selectedMaxBudget = 10000;

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getFeaturedPicks();
    context.read<HomeCubit>().getAds();
    context.read<HomeCubit>().getStores();

    final homeState = context.read<HomeCubit>().state;
    if (homeState.featuredProducts != null) {
      products = homeState.featuredProducts!;
    }
    final sellState = context.read<SellCubit>().state;
    if (sellState is SellLoaded) {
      userProducts = sellState.userProducts;
    }
    _filterByBudget();
  }

  void _filterByBudget() {
    setState(() {
      filteredProducts = products.where((p) {
        final effectivePrice = p.newPrice ?? p.price;
        return effectivePrice >= selectedMinBudget &&
            effectivePrice <= selectedMaxBudget;
      }).toList();

      filteredUserProducts = userProducts.where((p) {
        final price = double.tryParse(p.price) ?? 0;
        return price >= selectedMinBudget && price <= selectedMaxBudget;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state.featuredProducts != null) {
              products = state.featuredProducts!;
              _filterByBudget();
            }
          },
        ),
        BlocListener<SellCubit, SellState>(
          listener: (context, state) {
            if (state is SellLoaded) {
              userProducts = state.userProducts;
              _filterByBudget();
            }
          },
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppPadding.medium),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppPadding.large),
                  BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      if (state.ads?.isNotEmpty == true) {
                        return CarouselSlider(
                          items: state.ads!.map((banner) {
                            return GestureDetector(
                              onTap: () {
                                getIt<NavigationService>().navigatePush(
                                  ShopDetails(
                                    shopId: banner['storeId'],
                                    createStoreModel: CreateStoreModel.fromJson(banner['store']),
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
                            items: const [],
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
                  const SizedBox(height: AppPadding.medium),
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
                        return ShopListWidget(stores: state.stores!);
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
                                selectedImage: 'https://picsum.photos/400/300',
                              ),
                            ),
                          ),
                        );
                      }
                      return Center(
                        child: Text(
                          state.errorS ?? "",
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: AppColors.primaryColor),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AppPadding.large),
                  Text(
                    AppLocalizations.of(context)!.samples,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      if (state.isLoadingF == true && products.isEmpty) {
                        return Skeletonizer(
                          child: FeaturedPickList(
                            products: List.generate(
                              5,
                              (index) => ProductsModel(
                                id: 0,
                                image: "https://picsum.photos/400/300",
                                name: "",
                                desc: "",
                                price: 0,
                                category: "",
                                quantity: 0,
                                sizes: const [],
                                images: const [],
                                attributes: const {},
                                createStoreModel: CreateStoreModel(
                                  selectedName: '',
                                  selectedDesc: '',
                                  selectedCat: '',
                                  selectedPhone: '',
                                  selectedEmail: '',
                                  selectedAddress: '',
                                  selectedFees: '',
                                  selectedDelivery: '',
                                  selectedImage:
                                      'https://picsum.photos/400/300',
                                ),
                                storeId: '',
                              ),
                            ),
                          ),
                        );
                      }
                      return FeaturedPickList(
                        products: state.featuredProducts ?? [],
                      );
                    },
                  ),
                  const SizedBox(height: AppPadding.large),
                  Text(
                    AppLocalizations.of(context)!.usersWantToSell,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  WantToSellList(),
                  const SizedBox(height: AppPadding.large),
                  BudgetFilter(
                    onRangeChanged: (min, max) {
                      selectedMinBudget = min;
                      selectedMaxBudget = max;
                      _filterByBudget();
                    },
                  ),
                  BlocBuilder<SellCubit, SellState>(
                    builder: (context, state) {
                      return MixedList(
                        productsModel: filteredProducts,
                        userProductsModel: filteredUserProducts,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
