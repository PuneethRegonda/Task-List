part of 'task_bloc.dart';

abstract class TaskState extends Equatable {
  const TaskState();
}

class InitialTaskState extends TaskState {
  const InitialTaskState();
  @override
  List<Object> get props => [];
}

class AddedToListState extends TaskState {
  final Task task;
  final List<Task> taskList;
  const AddedToListState(this.task, this.taskList);
  @override
  List<Object> get props => [task, taskList];
}

class LoadedTaskState extends TaskState {
  final Task loadedTask;
  final List<Task> taskList;
  const LoadedTaskState(this.loadedTask, this.taskList);
  @override
  List<Object> get props => [loadedTask, taskList];
}

class CompletedTaskState extends TaskState {
  final List<Task> taskList;
  const CompletedTaskState(this.taskList);
  @override
  List<Object> get props => [taskList];
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);
  @override
  List<Object> get props => [message];
}

class ProcessingEventState extends TaskState {
  final List<Task> taskList;
  const ProcessingEventState(this.taskList);
  @override
  List<Object> get props => [];
}
