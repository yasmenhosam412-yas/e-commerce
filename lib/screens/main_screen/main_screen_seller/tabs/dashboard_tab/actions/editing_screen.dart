import 'package:boo/controllers/stores_cubit/dashboard_cubit/dashboard_cubit.dart';
import 'package:boo/controllers/stores_cubit/dashboard_cubit/dashboard_state.dart';
import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/core/utils/app_padding.dart';
import 'package:boo/core/widgets/cached_image_widget.dart';
import 'package:boo/l10n/app_localizations.dart';
import 'package:boo/screens/main_screen/main_screen_seller/tabs/dashboard_tab/actions/add_collection_screen.dart';
import 'package:boo/screens/main_screen/main_screen_seller/tabs/dashboard_tab/actions/add_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditingScreen extends StatefulWidget {
  const EditingScreen({super.key});

  @override
  State<EditingScreen> createState() => _EditingScreenState();
}

class _EditingScreenState extends State<EditingScreen> {
  @override
  Widget build(BuildContext context) {
    final List<String> editingItems = [
      AppLocalizations.of(context)!.products,
      AppLocalizations.of(context)!.collections,
      AppLocalizations.of(context)!.ads,
      AppLocalizations.of(context)!.coupons,
      AppLocalizations.of(context)!.discounts,
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(AppLocalizations.of(context)!.editing),
        backgroundColor: AppColors.primaryColor,
      ),
      body: SafeArea(
        child: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            final products = state.products ?? [];
            final collections = state.collections ?? [];
            final ads = state.ads ?? [];
            final discounts = state.discounts ?? [];
            final coupons = state.coupons ?? [];

            return ListView(
              padding: const EdgeInsets.all(AppPadding.medium),
              children: [
                ExpansionTile(
                  title: Text(
                    AppLocalizations.of(context)!.options,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                  initiallyExpanded: true,
                  children: editingItems.map((item) {
                    return ListTile(
                      title: Text(
                        item,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      onTap: () {
                        if (item == AppLocalizations.of(context)!.products) {
                          context.read<DashboardCubit>().getProducts();
                        } else if (item ==
                            AppLocalizations.of(context)!.collections) {
                          context.read<DashboardCubit>().getCollection();
                        } else if (item == AppLocalizations.of(context)!.ads) {
                          context.read<DashboardCubit>().getAds();
                        } else if (item ==
                            AppLocalizations.of(context)!.coupons) {
                          context.read<DashboardCubit>().getCoupons();
                        } else if (item ==
                            AppLocalizations.of(context)!.discounts) {
                          context.read<DashboardCubit>().getDiscount();
                        }
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: AppPadding.large),

                if (products.isNotEmpty) ...[
                  Text(
                    AppLocalizations.of(context)!.products,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppPadding.medium),
                  ...products.map(
                    (product) => ListTile(
                      leading: SizedBox(
                        width: 50,
                        height: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppPadding.medium,
                          ),
                          child: CachedImageWidget(imagePath: product.image),
                        ),
                      ),
                      title: Text(
                        product.name,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.black),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: AppColors.primaryColor,
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return AddProductScreen(
                                    productsModel: product,
                                  );
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: AppColors.whiteColor,
                                  title: Text(
                                    AppLocalizations.of(context)!.deleteProduct,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: Colors.black),
                                  ),
                                  content: Text(
                                    "${AppLocalizations.of(context)!.deleteConfirmation} ${product.name}?",
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: Colors.black),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        AppLocalizations.of(context)!.cancel,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context
                                            .read<DashboardCubit>()
                                            .deleteProduct(
                                              product.id.toString(),
                                            );
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!.delete,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else if (collections.isNotEmpty) ...[
                  Text(
                    AppLocalizations.of(context)!.collections,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppPadding.medium),
                  ...collections.map(
                    (collection) => ListTile(
                      title: Text(
                        collection['name'],
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.black),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: AppColors.primaryColor,
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return AddCollectionScreen(
                                    collection: collection,
                                  );
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: AppColors.whiteColor,
                                  title: Text(
                                    AppLocalizations.of(context)!.deleteProduct,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: Colors.black),
                                  ),
                                  content: Text(
                                    "${AppLocalizations.of(context)!.deleteConfirmation} ${collection['name']}?",
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: Colors.black),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        AppLocalizations.of(context)!.cancel,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context
                                            .read<DashboardCubit>()
                                            .deleteCollection(collection['id']);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!.delete,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else if (ads.isNotEmpty) ...[
                  Text(
                    AppLocalizations.of(context)!.ads,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppPadding.medium),
                  ...ads.map(
                    (ad) => ListTile(
                      title: Text(
                        ad['badgeText'],
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.black),
                      ),
                      leading: SizedBox(
                        width: 50,
                        height: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppPadding.medium,
                          ),
                          child: CachedImageWidget(imagePath: ad['image']),
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: AppColors.whiteColor,
                                  title: Text(
                                    AppLocalizations.of(context)!.deleteProduct,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: Colors.black),
                                  ),
                                  content: Text(
                                    "${AppLocalizations.of(context)!.deleteConfirmation} ${ad['badgeText']}?",
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: Colors.black),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        AppLocalizations.of(context)!.cancel,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context
                                            .read<DashboardCubit>()
                                            .deleteAds(ad['id']);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!.delete,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else if (discounts.isNotEmpty) ...[
                  Text(
                    AppLocalizations.of(context)!.discounts,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppPadding.medium),
                  ...discounts.map(
                    (disc) => ListTile(
                      title: Text(
                        disc.name,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.black),
                      ),
                      subtitle: Text(
                        disc.value,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.black),
                      ),

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: AppColors.whiteColor,
                                  title: Text(
                                    AppLocalizations.of(context)!.deleteProduct,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: Colors.black),
                                  ),
                                  content: Text(
                                    "${AppLocalizations.of(context)!.deleteConfirmation} ${disc.name}?",
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: Colors.black),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        AppLocalizations.of(context)!.cancel,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context
                                            .read<DashboardCubit>()
                                            .deleteDiscount(disc.id);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!.delete,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else if (coupons.isNotEmpty) ...[
                  Text(
                    AppLocalizations.of(context)!.coupons,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppPadding.medium),
                  ...coupons.map(
                    (cou) => ListTile(
                      title: Text(
                        cou['code'],
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.black),
                      ),
                      subtitle: Text(
                        cou['type'] + cou['value'],
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.black),
                      ),

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: AppColors.whiteColor,
                                  title: Text(
                                    AppLocalizations.of(context)!.deleteProduct,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: Colors.black),
                                  ),
                                  content: Text(
                                    "${AppLocalizations.of(context)!.deleteConfirmation} ${cou['code']}?",
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: Colors.black),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        AppLocalizations.of(context)!.cancel,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context
                                            .read<DashboardCubit>()
                                            .deleteCoupon(cou['id']);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!.delete,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.noAnyData,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
