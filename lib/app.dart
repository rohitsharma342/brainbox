import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'config/routes.dart';

class BrainboxApp extends StatelessWidget {
  const BrainboxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brainbox',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}