import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../models/todo.dart';
import '../services/date_time_service.dart';
import '../task_list_repository.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskListRepository taskListRepository;

  TaskBloc(this.taskListRepository);

  @override
  TaskState get initialState => InitialTaskState();

  @override
  Stream<TaskState> mapEventToState(
    TaskEvent event,
  ) async* {

    yield ProcessingEventState(taskListRepository.getTaskList());
    
    if (event is AddTaskEvent) {
      Task newTask = Task(
          dateTime: DateTimeServiceProvider.strToDateTime(event.dateTime),
          name: event.name,
          description: event.description);
      List<Task> updatedTaskList = taskListRepository.addTaskList(newTask);
      print(updatedTaskList.length);
      yield AddedToListState(newTask, updatedTaskList);
    } else if (event is LoadTaskEvent) {
      try {
        // delete and load the deleted
        Task deletedTask = taskListRepository.deleteandloadTask(event.index);
        List<Task> updatedTaskList = taskListRepository.getTaskList();
        yield LoadedTaskState(deletedTask, updatedTaskList);
      } on TaskNotFoundError {
        yield TaskError('someThing bad happened, Unable to Edit');
      }
    } else if (event is CompleteTaskEvent) {
      try {
        List<Task> updatedTaskList =
            taskListRepository.completeTask(event.index);
        // if (updatedTaskList.isEmpty) yield InitialTaskState();
        yield CompletedTaskState(updatedTaskList);
      } on TaskNotFoundError {
        yield TaskError("Sorry, Unable to Delete Task");
      }
    } else {
      yield TaskError("Unkown Event occured !!");
    }
  }
}
