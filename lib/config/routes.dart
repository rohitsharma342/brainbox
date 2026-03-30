import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/task_detail_screen.dart';
import '../screens/task_creation_screen.dart';
import '../screens/notifications_screen.dart';
import '../models/task_model.dart';

class AppRoutes {
  static const String splash = '/';
  static const String dashboard = '/dashboard';
  static const String taskDetail = '/task-detail';
  static const String taskCreation = '/task-creation';
  static const String notifications = '/notifications';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _buildPageRoute(const SplashScreen(), settings);
      case dashboard:
        return _buildPageRoute(const DashboardScreen(), settings);
      case taskDetail:
        final task = settings.arguments as TaskModel;
        return _buildPageRoute(TaskDetailScreen(task: task), settings);
      case taskCreation:
        return _buildPageRoute(const TaskCreationScreen(), settings);
      case notifications:
        return _buildPageRoute(const NotificationsScreen(), settings);
      default:
        return _buildPageRoute(const SplashScreen(), settings);
    }
  }

  static PageRouteBuilder _buildPageRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}