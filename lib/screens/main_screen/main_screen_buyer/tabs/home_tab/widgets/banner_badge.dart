import 'package:flutter/material.dart';

import '../../../../../../../core/models/banner_model.dart';
import '../../../../../../../l10n/app_localizations.dart';

class BannerBadgeWidget extends StatelessWidget {
  final BannerModel banner;

  const BannerBadgeWidget({super.key, required this.banner});

  @override
  Widget build(BuildContext context) {
    late final String text;
    late final Color color;

    if (banner.isNewShop) {
      text = AppLocalizations.of(context)!.neww;
      color = Colors.green;
    } else if (banner.hasDiscount) {
      text = AppLocalizations.of(context)!.discount;
      color = Colors.red;
    } else if (banner.isBestSelling) {
      text = AppLocalizations.of(context)!.bestSeller;
      color = Colors.orange;
    } else {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
