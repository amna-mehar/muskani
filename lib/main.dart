import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'presentation/screens/splash_screen.dart';

void main() => runApp(const ShopEaseApp());

class ShopEaseApp extends StatelessWidget {
  const ShopEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopEase',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const SplashScreen(),
    );
  }
}
