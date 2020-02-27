part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();
}

class AddTaskEvent extends TaskEvent {
  final String dateTime;
  final String name;
  final String description;

  AddTaskEvent(this.dateTime, this.name, this.description);
  @override
  List<Object> get props => [dateTime, name, description];
}


class LoadTaskEvent extends TaskEvent {
  final int index;
  LoadTaskEvent(this.index);
  @override
  List<Object> get props => [];
}

class CompleteTaskEvent extends TaskEvent {
  final int index;
  CompleteTaskEvent(this.index);
  @override
  List<Object> get props => [index];
}


// class DeleteTaskEvent extends TaskEvent {
//   final int index;
//   DeleteTaskEvent(this.index);
//   @override
//   List<Object> get props => [index];
// }
