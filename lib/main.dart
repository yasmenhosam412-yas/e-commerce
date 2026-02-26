import 'package:boo/controllers/auth_cubit/auth_cubit.dart';
import 'package:boo/controllers/buyer_cubits/home_cubit/home_cubit.dart';
import 'package:boo/controllers/fav_cubit/fav_cubit.dart';
import 'package:boo/controllers/stores_cubit/dashboard_cubit/dashboard_cubit.dart';
import 'package:boo/controllers/stores_cubit/store_creation_cubit/store_creation_cubit.dart';
import 'package:boo/core/services/navigation_service.dart';
import 'package:boo/core/utils/app_theme.dart';
import 'package:boo/screens/main_screen/main_screen_buyer/main_screen_buyer.dart';
import 'package:boo/screens/main_screen/main_screen_seller/main_screen_seller.dart';
import 'package:boo/screens/on_boarding/on_boarding_screen.dart';
import 'package:boo/services/auth_service.dart';
import 'package:boo/services/buyer_service/fav_service.dart';
import 'package:boo/services/buyer_service/home_service.dart';
import 'package:boo/services/store_creation_service.dart';
import 'package:boo/services/store_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'core/services/get_init.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setupLocator();

  FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
  final userType = await flutterSecureStorage.read(key: "userType");
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(
            authService: AuthService(),
            flutterSecureStorage: FlutterSecureStorage(),
          ),
        ),
        BlocProvider(
          create: (context) => StoreCreationCubit(
            flutterSecureStorage: FlutterSecureStorage(),
            storeCreationService: StoreCreationService(),
          ),
        ),
        BlocProvider(create: (context) => DashboardCubit(StoreService())),
        BlocProvider(create: (context) => HomeCubit(HomeService())),
        BlocProvider(create: (context) => FavCubit(FavService())..getAllFavourites()),
      ],
      child: MainApp(userType: userType),
    ),
  );
}

class MainApp extends StatelessWidget {
  final String? userType;

  const MainApp({super.key, this.userType});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: getIt<NavigationService>().navigatorKey,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // locale: Locale("ar"),
      supportedLocales: const [Locale('en'), Locale('ar')],
      home: (FirebaseAuth.instance.currentUser?.uid != null && userType != null)
          ? (userType == "buyer")
                ? MainScreenBuyer()
                : MainScreenSeller()
          : OnBoardingScreen(),
    );
  }
}
