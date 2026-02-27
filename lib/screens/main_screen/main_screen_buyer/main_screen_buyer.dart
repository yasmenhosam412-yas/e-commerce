import 'package:boo/core/services/navigation_service.dart';
import 'package:boo/core/utils/app_colors.dart';
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
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryColor,
        shape: CircleBorder(),
        onPressed: () {
          getIt<NavigationService>().navigatePush(SellSomething());
        },
        label: Icon(Icons.add, color: Colors.white),
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
    return SizedBox(
      height: 80,
      child: Stack(
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 80),
            painter: BottomNavPainter(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home, 0),
              _navItem(Icons.favorite, 1),
              _navItem(Icons.shopping_bag, 2),
              _navItem(Icons.person, 3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, int index) {
    final bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 26,
            color: isSelected ? AppColors.whiteColor : Colors.grey,
          ),
          const SizedBox(height: 4),
          Container(
            height: 4,
            width: isSelected ? 25 : 0,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
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
