import 'package:boo/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  Future<dynamic> navigatePushRemoveUntil(Widget widget) {
    return navigatorKey.currentState!.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => widget),
      (route) => false,
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
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          10,
          10,
          10,
          MediaQuery.of(context).viewInsets.bottom,
        ),
        child: content,
      ),
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

  Future<void> showToast(String text) async {
    Fluttertoast.showToast(msg: text, backgroundColor: AppColors.primaryColor);
  }
}
