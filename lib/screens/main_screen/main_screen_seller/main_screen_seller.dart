import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/screens/main_screen/main_screen_seller/tabs/dashboard_tab/dashboard_tab.dart';
import 'package:boo/screens/main_screen/main_screen_seller/tabs/orders_tab/orders_tab.dart';
import 'package:boo/screens/main_screen/main_screen_seller/tabs/profile_seller_tab/profile_seller_tab.dart';
import 'package:boo/screens/main_screen/main_screen_seller/tabs/statics_tab/statics_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MainScreenSeller extends StatefulWidget {
  const MainScreenSeller({super.key});

  @override
  State<MainScreenSeller> createState() => _MainScreenSellerState();
}

class _MainScreenSellerState extends State<MainScreenSeller> {
  int _currentIndex = 0;
  FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
  late List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = [
      DashboardTab(),
      OrdersTab(),
      StaticsTab(),
      ProfileSellerTab(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
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
              _navItem(Icons.dashboard_outlined, 0),
              _navItem(Icons.border_all_rounded, 1),
              _navItem(Icons.stacked_bar_chart_sharp, 2),
              _navItem(Icons.person_outline_sharp, 3),
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
