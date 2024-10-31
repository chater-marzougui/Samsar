import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:samsar/screens/bottom_navigator.dart';
import 'package:samsar/screens/main_screens/home.dart';
import 'package:samsar/screens/user_control/login.dart';
import 'package:samsar/screens/user_control/signup.dart';
import 'package:samsar/values/app_preferences.dart';
import 'package:samsar/values/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/l10n.dart';
import 'firebase_options.dart';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final appPreferences = AppPreferences(prefs);
  await appPreferences.initDefaults();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp(appPreferences: appPreferences));
}

class MyApp extends StatefulWidget {
  final AppPreferences appPreferences;

  const MyApp({required this.appPreferences, super.key});

  static MyAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<MyAppState>();
  }

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = Locale('en');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void updateThemeMode(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final savedLocale = widget.appPreferences.getPreferredLanguage(); // Assuming this method exists in AppPreferences
    setState(() {
      _locale = Locale(savedLocale);
    });
  }

  Future<void> _loadThemeMode() async {
    final themeMode = widget.appPreferences.getThemeMode();
    setState(() {
      _themeMode = themeMode == 'dark' ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Samsar',
      locale: _locale,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', 'EN'),
        Locale('fr', 'FR'),
        Locale('ar', 'AR'),
      ],
      // builder: (context, child) {
      //   return Directionality(
      //     textDirection: TextDirection.ltr,
      //     child: child!,
      //   );
      // },
      themeMode: _themeMode,
      theme: _lightTheme(),
      darkTheme: _darkTheme(),
      initialRoute: AppRoutes.authWrapper,
      onGenerateRoute: Routes.generateRoute,
      routes: {
        AppRoutes.homePage: (context) => HomePage(),
        AppRoutes.login: (context) => LoginScreen(),
        AppRoutes.signup: (context) => SignupScreen(),
        AppRoutes.home: (context) => HomeScreen(),
      },
    );
  }

  ThemeData _lightTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: Colors.blueAccent,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(color: Colors.black87, fontSize: 57),
        displayMedium: TextStyle(color: Colors.black87, fontSize: 45),
        displaySmall: TextStyle(color: Colors.black87, fontSize: 36),
        headlineLarge: TextStyle(color: Colors.black87, fontSize: 32),
        headlineMedium: TextStyle(color: Colors.black87, fontSize: 28),
        headlineSmall: TextStyle(color: Colors.black87, fontSize: 24),
        titleLarge: TextStyle(color: Colors.black87, fontSize: 22),
        titleMedium: TextStyle(color: Colors.black87, fontSize: 16),
        titleSmall: TextStyle(color: Colors.black87, fontSize: 14),
        bodyLarge: TextStyle(color: Colors.black87, fontSize: 20),
        bodyMedium: TextStyle(color: Colors.black87, fontSize: 18),
        bodySmall: TextStyle(color: Colors.black87, fontSize: 15),
        labelLarge: TextStyle(color: Colors.black87, fontSize: 14),
        labelMedium: TextStyle(color: Colors.black87, fontSize: 12),
        labelSmall: TextStyle(color: Colors.black87, fontSize: 10),
      ),
      scaffoldBackgroundColor: Colors.white,
      cardColor: Colors.white70,
      dialogBackgroundColor: Colors.white,
      dividerColor: Colors.grey[300],
      iconTheme: IconThemeData(color: Colors.black87),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.white70),
          textStyle: WidgetStateProperty.all(TextStyle(color: Colors.blueAccent, fontSize: 16)),
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.blueAccent,
        textTheme: ButtonTextTheme.primary,
      ),
      colorScheme: ColorScheme.light(
        primary: Colors.blueAccent,
        secondary: Colors.blueAccent[700]!,
        surface: Colors.white,
        tertiary: Colors.grey[600],
        error: Colors.red[700]!,
      ),
    );
  }

  ThemeData _darkTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: Colors.blueAccent,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(color: Colors.white70, fontSize: 57),
        displayMedium: TextStyle(color: Colors.white70, fontSize: 45),
        displaySmall: TextStyle(color: Colors.white70, fontSize: 36),
        headlineLarge: TextStyle(color: Colors.white70, fontSize: 32),
        headlineMedium: TextStyle(color: Colors.white70, fontSize: 28),
        headlineSmall: TextStyle(color: Colors.white70, fontSize: 24),
        titleLarge: TextStyle(color: Colors.white70, fontSize: 22),
        titleMedium: TextStyle(color: Colors.white70, fontSize: 16),
        titleSmall: TextStyle(color: Colors.white70, fontSize: 14),
        bodyLarge: TextStyle(color: Colors.white70, fontSize: 20),
        bodyMedium: TextStyle(color: Colors.white70, fontSize: 18),
        bodySmall: TextStyle(color: Colors.white70, fontSize: 15),
        labelLarge: TextStyle(color: Colors.white70, fontSize: 14),
        labelMedium: TextStyle(color: Colors.white70, fontSize: 12),
        labelSmall: TextStyle(color: Colors.white70, fontSize: 10),
      ),
      scaffoldBackgroundColor: Colors.grey[900],
      cardColor: Colors.grey[800],
      dialogBackgroundColor: Colors.grey[850],
      dividerColor: Colors.grey[700],
      canvasColor: Colors.grey[900],
      iconTheme: IconThemeData(color: Colors.white70),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation: WidgetStatePropertyAll(5),
          backgroundColor: WidgetStateProperty.all(Colors.grey[800]),
          textStyle: WidgetStateProperty.all(TextStyle(color: Colors.blueAccent, fontSize: 16)),
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.blueAccent,
        textTheme: ButtonTextTheme.primary,
      ),
      colorScheme: ColorScheme.dark(
        primary: Colors.blueAccent,
        secondary: Colors.blueAccent[400]!,
        tertiary: Colors.grey[300],
        surface: Colors.grey[800]!,
        error: Colors.red[300]!,
      ),
    );
  }
}