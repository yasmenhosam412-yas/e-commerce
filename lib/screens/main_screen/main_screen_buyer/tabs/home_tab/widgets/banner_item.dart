import 'package:flutter/material.dart';
import '../../../../../../../core/models/banner_model.dart';
import '../../../../../../../core/widgets/cached_image_widget.dart';
import 'banner_badge.dart';

class BannerItem extends StatelessWidget {
  final BannerModel banner;

  const BannerItem({super.key, required this.banner});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: CachedImageWidget(imagePath: banner.image),
        ),
        if (banner.hasBadge)
          Positioned(
            top: 12,
            left: 12,
            child: BannerBadgeWidget(banner: banner),
          ),
      ],
    );
  }
}
