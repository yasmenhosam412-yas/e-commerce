import 'package:boo/core/utils/app_padding.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/utils/app_colors.dart';
import '../../../../../../l10n/app_localizations.dart';

class BudgetFilter extends StatefulWidget {
  const BudgetFilter({
    super.key,
    required this.onRangeChanged,
  });

  final void Function(double min, double max) onRangeChanged;

  @override
  State<BudgetFilter> createState() => _BudgetFilterState();
}

class _BudgetFilterState extends State<BudgetFilter> {
  double minBudget = 0;
  double maxBudget = 10000;

  RangeValues rangeValues = const RangeValues(0, 10000);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.userBalance,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppPadding.small),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RangeSlider(
              values: rangeValues,
              min: minBudget,
              max: maxBudget,
              divisions: 10,
              activeColor: AppColors.primaryColor,
              labels: RangeLabels(
                rangeValues.start.toStringAsFixed(0),
                rangeValues.end.toStringAsFixed(0),
              ),
              onChanged: (values) {
                setState(() {
                  rangeValues = values;
                });
                widget.onRangeChanged(values.start, values.end);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Min: ${rangeValues.start.toStringAsFixed(0)} ${AppLocalizations.of(context)!.currency}",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
                Text(
                  "Max: ${rangeValues.end.toStringAsFixed(0)} ${AppLocalizations.of(context)!.currency}",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
