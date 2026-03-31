import '../models/task.dart';

class DBService {
  static List<Task> tasks = [];

  static List<Task> getTasks() {
    return tasks;
  }

  static Future<void> addTask(Task task) async {
    await Future.delayed(Duration(seconds: 2));
    tasks.add(task);
  }

  static void deleteTask(int index) {
    tasks.removeAt(index);
  }

  static void updateTask(int index, Task task) {
    tasks[index] = task;
  }
}
