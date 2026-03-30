import 'package:flutter/foundation.dart';
import '../models/task_model.dart';
import '../data/static_data.dart';

class TaskController extends ChangeNotifier {
  List<TaskModel> _tasks = [];
  String _searchQuery = '';
  TaskStatus? _statusFilter;
  TaskPriority? _priorityFilter;
  bool _isLoading = false;
  String? _error;

  List<TaskModel> get tasks => _tasks;
  String get searchQuery => _searchQuery;
  TaskStatus? get statusFilter => _statusFilter;
  TaskPriority? get priorityFilter => _priorityFilter;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<TaskModel> get filteredTasks {
    return _tasks.where((task) {
      final matchesSearch = task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          task.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus = _statusFilter == null || task.status == _statusFilter;
      final matchesPriority = _priorityFilter == null || task.priority == _priorityFilter;
      return matchesSearch && matchesStatus && matchesPriority;
    }).toList();
  }

  int get completedTasksCount => _tasks.where((t) => t.status == TaskStatus.completed).length;
  int get pendingTasksCount => _tasks.where((t) => t.status == TaskStatus.pending).length;
  int get inProgressTasksCount => _tasks.where((t) => t.status == TaskStatus.inProgress).length;
  int get totalTasksCount => _tasks.length;

  Map<String, int> get tasksByPriority {
    return {
      'Low': _tasks.where((t) => t.priority == TaskPriority.low).length,
      'Medium': _tasks.where((t) => t.priority == TaskPriority.medium).length,
      'High': _tasks.where((t) => t.priority == TaskPriority.high).length,
      'Urgent': _tasks.where((t) => t.priority == TaskPriority.urgent).length,
    };
  }

  Future<void> loadTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _tasks = StaticData.getTasks();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load tasks. Please try again.';
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setStatusFilter(TaskStatus? status) {
    _statusFilter = status;
    notifyListeners();
  }

  void setPriorityFilter(TaskPriority? priority) {
    _priorityFilter = priority;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _statusFilter = null;
    _priorityFilter = null;
    notifyListeners();
  }

  Future<bool> addTask(TaskModel task) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      _tasks.add(task);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to add task. Please try again.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateTask(TaskModel updatedTask) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
      if (index != -1) {
        _tasks[index] = updatedTask.copyWith(updatedAt: DateTime.now());
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = 'Failed to update task. Please try again.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteTask(String taskId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      _tasks.removeWhere((t) => t.id == taskId);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to delete task. Please try again.';
      notifyListeners();
      return false;
    }
  }

  TaskModel? getTaskById(String id) {
    try {
      return _tasks.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }
}