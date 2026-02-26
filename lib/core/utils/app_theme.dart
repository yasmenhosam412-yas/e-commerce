import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/core/utils/app_padding.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.whiteColor,
    primaryColor: AppColors.primaryColor,
    fontFamily: "ABeeZee",
    iconTheme: IconThemeData(color: AppColors.whiteColor),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.whiteColor,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: AppColors.whiteColor),
    ),

    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white, fontSize: 22),
      bodyMedium: TextStyle(color: Colors.white, fontSize: 20),
      bodySmall: TextStyle(color: Colors.white, fontSize: 18),
      titleLarge: TextStyle(color: Colors.white, fontSize: 22),
      titleMedium: TextStyle(color: Colors.white, fontSize: 20),
      titleSmall: TextStyle(color: Colors.white, fontSize: 18),
      labelLarge: TextStyle(color: Colors.white, fontSize: 22),
      labelMedium: TextStyle(color: Colors.white, fontSize: 20),
      labelSmall: TextStyle(color: Colors.white, fontSize: 18),
      headlineSmall: TextStyle(color: Colors.white, fontSize: 18),
      headlineMedium: TextStyle(color: Colors.white, fontSize: 20),
      headlineLarge: TextStyle(color: Colors.white, fontSize: 22),
      displaySmall: TextStyle(color: Colors.white, fontSize: 18),
      displayLarge: TextStyle(color: Colors.white, fontSize: 22),
      displayMedium: TextStyle(color: Colors.white, fontSize: 20),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(AppColors.primaryColor),
        foregroundColor: WidgetStatePropertyAll(AppColors.whiteColor),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppPadding.medium),
          ),
        ),
        elevation: WidgetStatePropertyAll(0),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(AppColors.primaryColor),
        foregroundColor: WidgetStatePropertyAll(AppColors.whiteColor),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppPadding.medium),
          ),
        ),
      ),
    ),

    cardColor: AppColors.whiteColor,

    dividerColor: CupertinoColors.systemGrey5,
    hintColor: CupertinoColors.systemGrey,

    tabBarTheme: TabBarThemeData(
      labelColor: AppColors.whiteColor,
      unselectedLabelColor: Colors.black54,
      indicator: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(AppPadding.medium),
      ),
      dividerColor: Colors.transparent,
    ),

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primaryColor,
      selectionColor: AppColors.primaryColor.withValues(alpha: 0.3),
      selectionHandleColor: AppColors.primaryColor,
    ),

    bottomAppBarTheme: BottomAppBarThemeData(color: AppColors.whiteColor),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.whiteColor,
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        // backgroundColor: WidgetStatePropertyAll(AppColors.whiteColor),
        // foregroundColor: WidgetStatePropertyAll(AppColors.primaryColor),
        iconColor: WidgetStatePropertyAll(AppColors.darkBlack),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.whiteColor,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBlack,
    primaryColor: AppColors.primaryColor,
    fontFamily: "ABeeZee",

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkBlack,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: AppColors.whiteColor),
    ),

    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.black, fontSize: 22),
      bodyMedium: TextStyle(color: Colors.black, fontSize: 20),
      bodySmall: TextStyle(color: Colors.black, fontSize: 18),
      titleLarge: TextStyle(color: Colors.black, fontSize: 22),
      titleMedium: TextStyle(color: Colors.black, fontSize: 20),
      titleSmall: TextStyle(color: Colors.black, fontSize: 18),
      labelLarge: TextStyle(color: Colors.black, fontSize: 22),
      labelMedium: TextStyle(color: Colors.black, fontSize: 20),
      labelSmall: TextStyle(color: Colors.black, fontSize: 18),
      headlineSmall: TextStyle(color: Colors.black, fontSize: 18),
      headlineMedium: TextStyle(color: Colors.black, fontSize: 20),
      headlineLarge: TextStyle(color: Colors.black, fontSize: 22),
      displaySmall: TextStyle(color: Colors.black, fontSize: 18),
      displayLarge: TextStyle(color: Colors.black, fontSize: 22),
      displayMedium: TextStyle(color: Colors.black, fontSize: 20),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(AppColors.primaryColor),
        foregroundColor: WidgetStatePropertyAll(AppColors.whiteColor),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppPadding.medium),
          ),
        ),
        elevation: WidgetStatePropertyAll(0),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(AppColors.primaryColor),
        foregroundColor: WidgetStatePropertyAll(AppColors.whiteColor),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppPadding.medium),
          ),
        ),
      ),
    ),

    cardColor: AppColors.grey500,
    dividerColor: CupertinoColors.systemGrey5,
    hintColor: CupertinoColors.systemGrey,
    iconTheme: IconThemeData(color: AppColors.darkBlack),
    tabBarTheme: TabBarThemeData(
      labelColor: AppColors.whiteColor,
      unselectedLabelColor: Colors.grey[400],
      indicator: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(AppPadding.medium),
      ),
      dividerColor: Colors.transparent,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primaryColor,
      selectionColor: AppColors.primaryColor.withValues(alpha: 0.3),
      selectionHandleColor: AppColors.primaryColor,
    ),
    bottomAppBarTheme: BottomAppBarThemeData(color: AppColors.darkBlack),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.darkBlack,
    ),

    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        // backgroundColor: WidgetStatePropertyAll(AppColors.darkBlack),
        // foregroundColor: WidgetStatePropertyAll(AppColors.primaryColor),
        iconColor: WidgetStatePropertyAll(AppColors.darkBlack),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.darkBlack,
    ),
  );
}
