import 'package:boo/core/models/action_model.dart';
import 'package:boo/core/services/navigation_service.dart';
import 'package:boo/core/utils/app_padding.dart';
import 'package:boo/core/widgets/custom_elevated_button.dart';
import 'package:boo/l10n/app_localizations.dart';
import 'package:boo/screens/main_screen/main_screen_seller/tabs/dashboard_tab/actions/add_coupon_screen.dart';
import 'package:boo/screens/main_screen/main_screen_seller/tabs/dashboard_tab/actions/add_discount_screen.dart';
import 'package:boo/screens/main_screen/main_screen_seller/tabs/dashboard_tab/actions/add_product_screen.dart';
import 'package:boo/screens/main_screen/main_screen_seller/tabs/dashboard_tab/actions/create_ads_screen.dart';
import 'package:boo/screens/main_screen/main_screen_seller/tabs/dashboard_tab/actions/manage_products_screen.dart';
import 'package:flutter/material.dart';
import '../../../../../core/services/get_init.dart';
import 'actions/add_collection_screen.dart';

class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  late List<ActionModel> actions;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    actions = [
      ActionModel(
        title: AppLocalizations.of(context)!.addProduct,
        color: Colors.green,
        onTab: () {
          getIt<NavigationService>().navigatePush(AddProductScreen());
        },
      ),
      ActionModel(
        title: AppLocalizations.of(context)!.addCollection,
        color: Colors.blue,
        onTab: () {
          getIt<NavigationService>().navigatePush(AddCollectionScreen());
        },
      ),
      ActionModel(
        title: AppLocalizations.of(context)!.viewProducts,
        color: Colors.pink,
        onTab: () {
          getIt<NavigationService>().navigatePush(ManageProductsScreen());
        },
      ),
      ActionModel(
        title: AppLocalizations.of(context)!.addAds,
        color: Colors.amber,
        onTab: () {
          getIt<NavigationService>().navigatePush(CreateAdsScreen());
        },
      ),
      ActionModel(
        title: AppLocalizations.of(context)!.addDiscount,
        color: Colors.deepOrange,
        onTab: () {
          getIt<NavigationService>().navigatePush(AddDiscountScreen());
        },
      ),
      ActionModel(
        title: AppLocalizations.of(context)!.addCoupon,
        color: Colors.red,
        onTab: () {
          getIt<NavigationService>().navigatePush(AddCouponScreen());
        },
      ),
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: AppPadding.medium,
            mainAxisSpacing: AppPadding.medium,
            childAspectRatio: 0.9,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];

            return CustomElevatedButton(
              onPressed: action.onTab,
              accentColor: action.color,
              child: Center(
                child: Text(
                  action.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
