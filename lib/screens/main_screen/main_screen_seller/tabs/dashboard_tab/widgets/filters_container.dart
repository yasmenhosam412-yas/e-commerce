import 'package:boo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/utils/app_colors.dart';

class FiltersContainer extends StatefulWidget {
  final TextEditingController search;

  final List<String> discounts;
  final List<String> collections;

  final String searchQuery;
  final String? selectedDiscount;
  final String? selectedCollection;
  final bool filterFeatured;

  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onDiscountChanged;
  final ValueChanged<String?> onCollectionChanged;
  final ValueChanged<bool> onFeaturedChanged;

  const FiltersContainer({
    super.key,
    required this.search,
    required this.discounts,
    required this.collections,
    required this.searchQuery,
    required this.selectedDiscount,
    required this.selectedCollection,
    required this.filterFeatured,
    required this.onSearchChanged,
    required this.onDiscountChanged,
    required this.onCollectionChanged,
    required this.onFeaturedChanged,
  });

  @override
  State<FiltersContainer> createState() => _FiltersContainerState();
}

class _FiltersContainerState extends State<FiltersContainer> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(18),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.filters_title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey[700],
                  ),
                ],
              ),
            ),
          ),

          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.primaryColor),
                    controller: widget.search,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(
                        context,
                      )!.search_placeholder,
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: const Color(0xffF3F4F8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: widget.onSearchChanged,
                  ),

                  const SizedBox(height: 14),

                  DropdownButtonFormField<String>(
                    value: widget.selectedDiscount,
                    dropdownColor: AppColors.whiteColor,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.discount,
                      filled: true,
                      fillColor: const Color(0xffF3F4F8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: [null, ...widget.discounts].map((d) {
                      return DropdownMenuItem(
                        value: d,
                        child: Text(
                          d ?? AppLocalizations.of(context)!.all_label,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: AppColors.primaryColor),
                        ),
                      );
                    }).toList(),
                    onChanged: widget.onDiscountChanged,
                  ),

                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: widget.selectedCollection,
                    dropdownColor: AppColors.whiteColor,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.collection_label,
                      filled: true,
                      fillColor: const Color(0xffF3F4F8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: [null, ...widget.collections].map((c) {
                      return DropdownMenuItem(
                        value: c,
                        child: Text(
                          c ?? AppLocalizations.of(context)!.all_label,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: AppColors.primaryColor),
                        ),
                      );
                    }).toList(),
                    onChanged: widget.onCollectionChanged,
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Checkbox(
                        value: widget.filterFeatured,
                        activeColor: AppColors.primaryColor,
                        onChanged: (v) => widget.onFeaturedChanged(v ?? false),
                      ),
                      Text(
                        AppLocalizations.of(context)!.show_featured_only,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }
}
