import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';

class SizeSelector extends StatefulWidget {
  final List<String> sizes;
  final ValueChanged<String>? onSizeSelected;

  const SizeSelector({super.key, required this.sizes, this.onSizeSelected});

  @override
  State<SizeSelector> createState() => _SizeSelectorState();
}

class _SizeSelectorState extends State<SizeSelector> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.onSizeSelected != null && widget.sizes.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onSizeSelected!(widget.sizes[currentIndex]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: List.generate(widget.sizes.length, (index) {
        final isSelected = currentIndex == index;
        return ChoiceChip(
          label: Text(
            widget.sizes[index],
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isSelected ? Colors.white : AppColors.primaryColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          selected: isSelected,
          backgroundColor: AppColors.whiteColor,
          selectedColor: AppColors.primaryColor,
          showCheckmark: false,
          side: BorderSide(
            color: isSelected ? AppColors.primaryColor : Colors.grey.shade300,
          ),
          onSelected: (selected) {
            if (!isSelected) {
              setState(() {
                currentIndex = index;
              });
              if (widget.onSizeSelected != null) {
                widget.onSizeSelected!(widget.sizes[index]);
              }
            }
          },
        );
      }),
    );
  }
}
