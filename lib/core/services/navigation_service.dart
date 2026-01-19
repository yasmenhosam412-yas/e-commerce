import 'package:boo/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class NavigationService {
  late final GlobalKey<NavigatorState> navigatorKey;

  NavigationService() {
    navigatorKey = GlobalKey<NavigatorState>();
  }

  Future<dynamic> navigatePush(Widget widget) {
    return navigatorKey.currentState!.push(
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  Future<dynamic> navigatePushReplace(Widget widget) {
    return navigatorKey.currentState!.pushReplacement(
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  Future<void> showCustomDialog(Widget widget) async {
    showAdaptiveDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return widget;
      },
    );
  }

  Future<void> showCustomBottomDialog({required Widget content}) {
    return showModalBottomSheet(
      context: navigatorKey.currentContext!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => content,
    );
  }

  Future<void> showSnackBar(Widget widget) async {
    ScaffoldMessenger.of(navigatorKey.currentContext!).clearSnackBars();
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        content: widget,
        backgroundColor: AppColors.primaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
