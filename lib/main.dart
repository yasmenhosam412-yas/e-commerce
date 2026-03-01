import 'package:boo/controllers/auth_cubit/auth_cubit.dart';
import 'package:boo/controllers/buyer_cubits/cart_cubit/cart_cubit.dart';
import 'package:boo/controllers/buyer_cubits/home_cubit/home_cubit.dart';
import 'package:boo/controllers/buyer_cubits/sell_cubit/sell_cubit.dart';
import 'package:boo/controllers/manage_cubit/manage_cubit.dart';
import 'package:boo/controllers/stores_cubit/dashboard_cubit/dashboard_cubit.dart';
import 'package:boo/controllers/stores_cubit/store_creation_cubit/store_creation_cubit.dart';
import 'package:boo/core/services/navigation_service.dart';
import 'package:boo/core/utils/app_theme.dart';
import 'package:boo/screens/main_screen/loading_screen.dart';
import 'package:boo/screens/on_boarding/on_boarding_screen.dart';
import 'package:boo/services/auth_service.dart';
import 'package:boo/services/buyer_service/cart_service.dart';
import 'package:boo/services/buyer_service/fav_service.dart';
import 'package:boo/services/buyer_service/home_service.dart';
import 'package:boo/services/buyer_service/sell_servcie.dart';
import 'package:boo/services/store_creation_service.dart';
import 'package:boo/services/store_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'controllers/buyer_cubits/fav_cubit/fav_cubit.dart';
import 'core/services/get_init.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp
  ]);
  setupLocator();
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
        BlocProvider(
          create: (context) => HomeCubit(HomeService())..getFeaturedPicks(),
        ),
        BlocProvider(create: (context) => FavCubit(FavService())),
        BlocProvider(
          create: (context) =>
              ManageCubit(StoreCreationService(), authService: AuthService()),
        ),
        BlocProvider(create: (context) => SellCubit(SellService())..getSell()),
        BlocProvider(create: (context) => CartCubit(CartService())),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

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
      supportedLocales: const [Locale('en'), Locale('ar')],
      home: (FirebaseAuth.instance.currentUser?.uid != null)
          ? LoadingScreen()
          : OnBoardingScreen(),
    );
  }
}
