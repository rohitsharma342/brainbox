import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';
import '../config/routes.dart';
import '../controllers/notification_controller.dart';
import '../controllers/task_controller.dart';
import '../models/notification_model.dart';
import '../widgets/notification_tile.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onNotificationTap(NotificationModel notification) {
    context.read<NotificationController>().markAsRead(notification.id);

    if (notification.taskId != null) {
      final task = context.read<TaskController>().getTaskById(notification.taskId!);
      if (task != null) {
        Navigator.pushNamed(
          context,
          AppRoutes.taskDetail,
          arguments: task,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Consumer<NotificationController>(
            builder: (context, controller, _) {
              if (controller.unreadCount > 0) {
                return TextButton.icon(
                  onPressed: () => controller.markAllAsRead(),
                  icon: const Icon(Icons.done_all, size: 18),
                  label: const Text('Mark all read'),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Consumer<NotificationController>(
          builder: (context, controller, _) {
            if (controller.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryColor),
              );
            }

            if (controller.notifications.isEmpty) {
              return _buildEmptyState();
            }

            return _buildNotificationsList(controller);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none,
              size: 64,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'You\'re all caught up!',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(NotificationController controller) {
    final notifications = controller.notifications;
    final unreadNotifications = notifications.where((n) => !n.isRead).toList();
    final readNotifications = notifications.where((n) => n.isRead).toList();

    return CustomScrollView(
      slivers: [
        if (unreadNotifications.isNotEmpty) ...[          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: _buildSectionHeader('New', unreadNotifications.length),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final notification = unreadNotifications[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: NotificationTile(
                      notification: notification,
                      onTap: () => _onNotificationTap(notification),
                    ),
                  );
                },
                childCount: unreadNotifications.length,
              ),
            ),
          ),
        ],
        if (readNotifications.isNotEmpty) ...[          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: _buildSectionHeader('Earlier', readNotifications.length),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final notification = readNotifications[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: NotificationTile(
                      notification: notification,
                      onTap: () => _onNotificationTap(notification),
                    ),
                  );
                },
                childCount: readNotifications.length,
              ),
            ),
          ),
        ],
        const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
      ],
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}