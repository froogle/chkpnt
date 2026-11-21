import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/main/main_screen.dart';
import 'screens/wishlist/wishlist_screen.dart';
import 'screens/backlog/backlog_screen.dart';
import 'screens/collection/collection_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'styles/styles.dart';

// Global navigator key for accessing navigation state from anywhere
final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const ProviderScope(retry: _neverRetry, child: MyApp()));
}

Duration? _neverRetry(int retryCount, Object error) => null;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'ChkPnt',
      theme: retroBacklogTheme,
      darkTheme: retroBacklogDarkTheme,
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
      routes: {
        '/main': (context) => const MainScreen(),
        '/wishlist': (context) => const WishlistScreen(),
        '/backlog': (context) => const BacklogScreen(),
        '/collection': (context) => const CollectionScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
