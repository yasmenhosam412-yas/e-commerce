import 'package:boo/controllers/stores_cubit/dashboard_cubit/dashboard_cubit.dart';
import 'package:boo/controllers/stores_cubit/dashboard_cubit/dashboard_state.dart';
import 'package:boo/core/models/products_model.dart';
import 'package:boo/core/services/navigation_service.dart';
import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/core/utils/app_padding.dart';
import 'package:boo/l10n/app_localizations.dart';
import 'package:boo/screens/main_screen/main_screen_seller/tabs/dashboard_tab/widgets/filters_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/services/get_init.dart';
import '../../../../../../core/widgets/custom_drop_down.dart';
import '../widgets/item_card.dart';

class ManageProductsScreen extends StatefulWidget {
  const ManageProductsScreen({super.key});

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  final Map<int, bool> _featuredOverrides = {};

  final Map<int, String?> _productDiscounts = {};
  final Map<int, String?> _productCollections = {};

  List<ProductsModel> _lastProducts = [];

  static const String noneDiscount = "No Discount";
  static const String noneCollection = "No Collection";

  String _searchQuery = "";
  String? _selectedDiscount;
  String? _selectedCollection;
  bool _filterFeatured = false;

  late TextEditingController search;

  @override
  void initState() {
    super.initState();
    search = TextEditingController();
    context.read<DashboardCubit>().getProducts();
    context.read<DashboardCubit>().getDiscount();
    context.read<DashboardCubit>().getCollection();
  }

  bool _isFeaturedNow(ProductsModel product) =>
      _featuredOverrides[product.id] ?? (product.isFeatured ?? false);

  int _totalFeaturedAfterChange(int productId, bool newValue) {
    int total = 0;
    for (final p in _lastProducts) {
      if (p.id == productId) {
        if (newValue) total++;
      } else {
        if (_featuredOverrides[p.id] ?? (p.isFeatured ?? false)) total++;
      }
    }
    return total;
  }

  void _toggleFeatured(ProductsModel product) {
    final current = _isFeaturedNow(product);
    final newValue = !current;

    if (newValue) {
      final total = _totalFeaturedAfterChange(product.id, true);
      if (total > 3) {
        getIt<NavigationService>().showToast(
          AppLocalizations.of(context)!.max_featured_products,
        );
        return;
      }
    }

    setState(() {
      _featuredOverrides[product.id] = newValue;
    });
  }

  void _setDiscount(int productId, String? value) {
    setState(() {
      _productDiscounts[productId] = (value == null || value == noneDiscount)
          ? null
          : value;
    });
  }

  void _setCollection(int productId, String? value) {
    setState(() {
      _productCollections[productId] =
          (value == null || value == noneCollection) ? null : value;
    });
  }

  String resolveDiscount(ProductsModel product) =>
      _productDiscounts[product.id] ?? product.discount ?? noneDiscount;

  String resolveCollection(ProductsModel product) =>
      _productCollections[product.id] ??
      product.collectionName ??
      noneCollection;

  void _openProductActions(
    ProductsModel product,
    List<String> discounts,
    List<String> collections,
  ) {
    final productId = product.id;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final isFeatured = _isFeaturedNow(product);

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.featured,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      Checkbox(
                        value: isFeatured,
                        activeColor: AppColors.primaryColor,
                        onChanged: (_) {
                          _toggleFeatured(product);
                          setModalState(() {});
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  CustomDropdown(
                    value: resolveDiscount(product),
                    label: AppLocalizations.of(context)!.discountValue,
                    items: discounts,
                    onChanged: (v) {
                      _setDiscount(productId, v);
                      setModalState(() {});
                    },
                  ),

                  const SizedBox(height: 12),

                  CustomDropdown(
                    value: resolveCollection(product),
                    label: AppLocalizations.of(context)!.collectionName,
                    items: collections,
                    onChanged: (v) {
                      _setCollection(productId, v);
                      setModalState(() {});
                    },
                  ),

                  SizedBox(height: AppPadding.xlarge),

                  BlocConsumer<DashboardCubit, DashboardState>(
                    listener: (context, state) {
                      if (state.isLoaded) {
                        getIt<NavigationService>().showToast(
                          AppLocalizations.of(context)!.products_saved_success,
                        );
                        Navigator.pop(context);
                      }
                      if (state.error != "") {
                        getIt<NavigationService>().showToast(state.error);
                      }
                    },
                    builder: (context, state) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: state.isLoading
                              ? null
                              : () {
                                  context.read<DashboardCubit>().updateProduct(
                                    productId: productId.toString(),
                                    discount: _productDiscounts[product.id],
                                    collectionName:
                                        _productCollections[product.id],
                                    isFeatured: _isFeaturedNow(product),
                                    newPrice: _calc(
                                      product.price,
                                      _productDiscounts[product.id],
                                    ),
                                  );
                                },
                          child: Text(
                            state.isLoading
                                ? AppLocalizations.of(context)!.loading
                                : AppLocalizations.of(context)!.save,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        automaticallyImplyLeading: false,
        title: Text(AppLocalizations.of(context)!.viewProducts),
        centerTitle: true,
      ),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          final products = state.products ?? [];
          _lastProducts = products;

          final List<String> discounts = [
            noneDiscount,
            ...?state.discounts?.map((e) => e.value.toString()),
          ];

          final List<String> collections = [
            noneCollection,
            ...?state.collections?.map((e) => e["name"].toString()),
          ];

          final filteredProducts = products.where((p) {
            final matchesSearch = p.name.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            );
            final productDiscount = _productDiscounts[p.id] ?? p.discount;
            final productCollection =
                _productCollections[p.id] ?? p.collectionName;
            final productFeatured =
                _featuredOverrides[p.id] ?? (p.isFeatured ?? false);

            final matchesDiscount =
                _selectedDiscount == null ||
                productDiscount == _selectedDiscount;
            final matchesCollection =
                _selectedCollection == null ||
                productCollection == _selectedCollection;
            final matchesFeatured = !_filterFeatured || productFeatured;

            return matchesSearch &&
                matchesDiscount &&
                matchesCollection &&
                matchesFeatured;
          }).toList();

          if (state.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }

          return Column(
            children: [
              FiltersContainer(
                search: search,
                discounts: discounts,
                collections: collections,
                searchQuery: _searchQuery,
                selectedDiscount: _selectedDiscount,
                selectedCollection: _selectedCollection,
                filterFeatured: _filterFeatured,
                onSearchChanged: (v) => setState(() => _searchQuery = v),
                onDiscountChanged: (v) => setState(() => _selectedDiscount = v),
                onCollectionChanged: (v) =>
                    setState(() => _selectedCollection = v),
                onFeaturedChanged: (v) => setState(() => _filterFeatured = v),
              ),

              if (filteredProducts.isNotEmpty)
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                    itemCount: filteredProducts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: .6,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                        ),
                    itemBuilder: (_, i) {
                      final product = filteredProducts[i];
                      return ItemCard(
                        product: product,
                        discount:
                            _productDiscounts[product.id] ?? product.discount,
                        collection:
                            _productCollections[product.id] ??
                            product.collectionName,
                        isFeatured: _isFeaturedNow(product),
                        onProductClick: () => _openProductActions(
                          product,
                          discounts,
                          collections,
                        ),
                      );
                    },
                  ),
                )
              else
                Center(
                  child: Text(
                    AppLocalizations.of(context)!.nothing,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  double _calc(double price, String? selectedDiscount) {
    if (selectedDiscount == null || selectedDiscount.isEmpty) return price;
    final discountString = selectedDiscount.replaceAll('%', '');
    final discountValue = double.tryParse(discountString);
    if (discountValue == null) return price;
    return price - (price * discountValue / 100);
  }
}
