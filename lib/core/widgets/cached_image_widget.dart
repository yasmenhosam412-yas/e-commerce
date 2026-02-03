import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class CachedImageWidget extends StatelessWidget {
  final String imagePath;

  const CachedImageWidget({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imagePath,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (_, __) => const Center(
        child: CircularProgressIndicator(color: AppColors.primaryColor),
      ),
      errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
    );
  }
}
