import 'package:flutter/material.dart';

class BannerBadgeWidget extends StatelessWidget {
  final Map<String, dynamic> banner;

  const BannerBadgeWidget({super.key, required this.banner});

  @override
  Widget build(BuildContext context) {
    final String hexColor = banner['badgeColor']?.toString() ?? 'FF0000FF';
    final String hexTextColor = banner['textColor']?.toString() ?? 'FF0000FF';
    Color bgColor;
    Color textColor;

    try {
      String formattedHex = hexColor.length == 8 ? hexColor : 'FF$hexColor';
      String formattedTextHex = hexTextColor.length == 8
          ? hexTextColor
          : 'FF$hexTextColor';
      bgColor = Color(int.parse(formattedHex, radix: 16));
      textColor = Color(int.parse(formattedTextHex, radix: 16));
    } catch (e) {
      bgColor = Colors.red;
      textColor = Colors.red;
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
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
