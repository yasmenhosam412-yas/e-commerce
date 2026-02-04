import 'package:flutter/material.dart';

class BannerBadgeWidget extends StatelessWidget {
  final Map<String, dynamic> banner;

  const BannerBadgeWidget({super.key, required this.banner});

  @override
  Widget build(BuildContext context) {
    final String hexColor = banner['badgeColor']?.toString() ?? 'FF0000FF';
    Color bgColor;

    try {
      String formattedHex = hexColor.length == 8 ? hexColor : 'FF$hexColor';
      bgColor = Color(int.parse(formattedHex, radix: 16));
    } catch (e) {
      bgColor = Colors.red;
    }

    final String text = banner['badgeText']?.toString() ?? 'NEW';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
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
