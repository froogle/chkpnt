import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/main/main_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/wishlist/wishlist_screen.dart';
import 'screens/backlog/backlog_screen.dart';
import 'styles/styles.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChkPnt',
      theme: retroBacklogTheme,
      darkTheme: retroBacklogDarkTheme,
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
      routes: {
        '/main': (context) => const MainScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/wishlist': (context) => const WishlistScreen(),
        '/backlog': (context) => const BacklogScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
