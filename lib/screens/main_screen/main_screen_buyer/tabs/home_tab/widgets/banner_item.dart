import 'package:flutter/material.dart';
import '../../../../../../../core/widgets/cached_image_widget.dart';
import 'banner_badge.dart';

class BannerItem extends StatelessWidget {
  final Map<String, dynamic> banner;

  const BannerItem({super.key, required this.banner});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: CachedImageWidget(imagePath: banner['image']),
        ),
        Align(
          alignment: getAlign(banner['position']),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: BannerBadgeWidget(banner: banner),
          ),
        ),
      ],
    );
  }

  AlignmentGeometry getAlign(String banner) {
    switch (banner) {
      case "topLeft":
        {
          return AlignmentGeometry.topLeft;
        }
      case "topRight":
        {
          return AlignmentGeometry.topRight;
        }
      case "bottomLeft":
        {
          return AlignmentGeometry.bottomLeft;
        }
      case "bottomRight":
        {
          return AlignmentGeometry.bottomRight;
        }
      default:
        {
          return AlignmentGeometry.topLeft;
        }
    }
  }
}
