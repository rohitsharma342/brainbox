import '../models/task_model.dart';
import '../models/notification_model.dart';

class StaticData {
  static List<TaskModel> getTasks() {
    final now = DateTime.now();
    return [
      TaskModel(
        id: '1',
        title: 'Complete Project Proposal',
        description: 'Draft and finalize the project proposal for the new client presentation. Include budget estimates and timeline.',
        dueDate: now.add(const Duration(days: 2)),
        priority: TaskPriority.high,
        status: TaskStatus.inProgress,
        createdAt: now.subtract(const Duration(days: 3)),
      ),
      TaskModel(
        id: '2',
        title: 'Review Team Performance',
        description: 'Conduct quarterly performance reviews for all team members. Prepare feedback documents.',
        dueDate: now.add(const Duration(days: 5)),
        priority: TaskPriority.medium,
        status: TaskStatus.pending,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      TaskModel(
        id: '3',
        title: 'Update Documentation',
        description: 'Update the API documentation with new endpoints and parameters.',
        dueDate: now.add(const Duration(days: 1)),
        priority: TaskPriority.urgent,
        status: TaskStatus.pending,
        createdAt: now.subtract(const Duration(hours: 5)),
      ),
      TaskModel(
        id: '4',
        title: 'Team Meeting Notes',
        description: 'Compile and distribute meeting notes from the weekly standup.',
        dueDate: now.subtract(const Duration(days: 1)),
        priority: TaskPriority.low,
        status: TaskStatus.completed,
        createdAt: now.subtract(const Duration(days: 7)),
      ),
      TaskModel(
        id: '5',
        title: 'Client Presentation',
        description: 'Prepare slides and demo for upcoming client presentation on product features.',
        dueDate: now.add(const Duration(days: 7)),
        priority: TaskPriority.high,
        status: TaskStatus.pending,
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      TaskModel(
        id: '6',
        title: 'Code Review Session',
        description: 'Review pull requests from the development team and provide feedback.',
        dueDate: now.add(const Duration(days: 3)),
        priority: TaskPriority.medium,
        status: TaskStatus.inProgress,
        createdAt: now.subtract(const Duration(hours: 12)),
      ),
      TaskModel(
        id: '7',
        title: 'Budget Planning',
        description: 'Create next quarter budget forecast and resource allocation plan.',
        dueDate: now.add(const Duration(days: 10)),
        priority: TaskPriority.high,
        status: TaskStatus.pending,
        createdAt: now,
      ),
      TaskModel(
        id: '8',
        title: 'Server Maintenance',
        description: 'Schedule and execute routine server maintenance and updates.',
        dueDate: now.add(const Duration(days: 4)),
        priority: TaskPriority.medium,
        status: TaskStatus.pending,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
    ];
  }

  static List<NotificationModel> getNotifications() {
    final now = DateTime.now();
    return [
      NotificationModel(
        id: 'n1',
        title: 'Task Due Soon',
        message: 'Update Documentation is due tomorrow. Make sure to complete it on time.',
        type: NotificationType.taskDue,
        taskId: '3',
        createdAt: now.subtract(const Duration(hours: 1)),
        isRead: false,
      ),
      NotificationModel(
        id: 'n2',
        title: 'Task Completed',
        message: 'Great job! Team Meeting Notes has been marked as completed.',
        type: NotificationType.taskCompleted,
        taskId: '4',
        createdAt: now.subtract(const Duration(hours: 3)),
        isRead: false,
      ),
      NotificationModel(
        id: 'n3',
        title: 'Reminder',
        message: 'Complete Project Proposal is in progress. Keep up the good work!',
        type: NotificationType.taskReminder,
        taskId: '1',
        createdAt: now.subtract(const Duration(hours: 6)),
        isRead: true,
      ),
      NotificationModel(
        id: 'n4',
        title: 'System Update',
        message: 'Brainbox has been updated with new features and improvements.',
        type: NotificationType.systemUpdate,
        createdAt: now.subtract(const Duration(days: 1)),
        isRead: true,
      ),
      NotificationModel(
        id: 'n5',
        title: 'Task Due This Week',
        message: 'Client Presentation is due in 7 days. Start preparing early!',
        type: NotificationType.taskDue,
        taskId: '5',
        createdAt: now.subtract(const Duration(hours: 12)),
        isRead: false,
      ),
      NotificationModel(
        id: 'n6',
        title: 'High Priority Task',
        message: 'Budget Planning has been added with high priority.',
        type: NotificationType.taskReminder,
        taskId: '7',
        createdAt: now.subtract(const Duration(hours: 2)),
        isRead: false,
      ),
    ];
  }
}