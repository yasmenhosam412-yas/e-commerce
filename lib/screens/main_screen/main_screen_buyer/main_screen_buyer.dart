import 'package:boo/core/services/navigation_service.dart';
import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/core/utils/app_padding.dart';
import 'package:boo/screens/main_screen/main_screen_buyer/tabs/cart_tab/cart_tab.dart';
import 'package:boo/screens/main_screen/main_screen_buyer/tabs/fav_tab/fav_tab.dart';
import 'package:boo/screens/main_screen/main_screen_buyer/tabs/home_tab/screens/home_tab.dart';
import 'package:boo/screens/main_screen/main_screen_buyer/tabs/profile_tab/profile_tab.dart';
import 'package:boo/screens/main_screen/main_screen_buyer/tabs/sell_something.dart';
import 'package:flutter/material.dart';

import '../../../core/services/get_init.dart';

class MainScreenBuyer extends StatefulWidget {
  const MainScreenBuyer({super.key});

  @override
  State<MainScreenBuyer> createState() => _MainScreenBuyerState();
}

class _MainScreenBuyerState extends State<MainScreenBuyer> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeTab(),
    FavTab(),
    CartTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _screens[_currentIndex],

      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(
          side: BorderSide(
            color: AppColors.whiteColor,
            width: AppPadding.small,
          ),
        ),
        backgroundColor: AppColors.redColor,
        onPressed: () {
          getIt<NavigationService>().navigatePush(SellSomething());
        },
        child: const Icon(Icons.add, color: AppColors.whiteColor),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: AppColors.primaryColor,
      shape: const AutomaticNotchedShape(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(AppPadding.xxxlarge),
            topLeft: Radius.circular(AppPadding.xxxlarge),
          ),
        ),
      ),
      notchMargin: 8,
      child: SizedBox(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.home, 0),
            _navItem(Icons.favorite, 1),
            const SizedBox(width: 40),
            _navItem(Icons.shopping_bag, 2),
            _navItem(Icons.person, 3),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, int index) {
    final bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Icon(
        icon,
        size: 26,
        color: isSelected ? Colors.white : Colors.white70,
      ),
    );
  }
}

class BottomNavPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppColors.primaryColor
      ..style = PaintingStyle.fill;

    final Path path = Path();

    path.moveTo(0, 20);
    path.quadraticBezierTo(size.width * 0.25, 0, size.width * 0.5, 0);
    path.quadraticBezierTo(size.width * 0.75, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawShadow(path, Colors.black26, 8, true);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
