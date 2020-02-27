import 'models/todo.dart';

abstract class TaskListRepository {
  List<Task> addTaskList(Task newTask);
  List<Task> completeTask(int index);
  Task deleteandloadTask(int index);
  List<Task> getTaskList();
}

class TaskListRepositoryFromMemory implements TaskListRepository {
  List<Task> todoListFromMemory = [];
  @override
  List<Task> addTaskList(Task newTask) {
    this.todoListFromMemory.add(newTask);
    this
        .todoListFromMemory
        .sort((Task t1, Task t2) => t1.dateTime.compareTo(t2.dateTime));
    return this.todoListFromMemory;
  }

  @override
  Task deleteandloadTask(int index) {
    try {
      return this.todoListFromMemory.removeAt(index);
    } catch (e) {
      throw TaskNotFoundError();
    }
  }

  @override
  List<Task> completeTask(int index) {
    try {
      this.todoListFromMemory.removeAt(index);
      return this.todoListFromMemory;
    } catch (e) {
      print(e);
      throw TaskNotFoundError();
    }
  }

  @override
  List<Task> getTaskList() {
    return this.todoListFromMemory;
  }
}

class TaskNotFoundError extends Error {}
