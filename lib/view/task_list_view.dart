import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/task_bloc.dart';
import '../models/task.dart';
import '../services/date_time_service.dart';
import '../utils/fontStyles.dart';

class MyTaskListApp extends StatefulWidget {
  @override
  _MyTaskListAppState createState() => _MyTaskListAppState();
}

class _MyTaskListAppState extends State<MyTaskListApp> {
  TextEditingController dateTimeTxtcontroller = TextEditingController(),
      nameTxtController = TextEditingController(),
      descriptiontxtConroller = TextEditingController();

  @override
  void dispose() {
    dateTimeTxtcontroller.dispose();
    nameTxtController.dispose();
    descriptiontxtConroller.dispose();
    super.dispose();
  }

  Widget _buildNoListFound() {
    return Flexible(
      flex: 1,
      child: Text(
        "Assign Tasks and become Productive",
        style: FontStyles.normalTextStyle,
      ),
    );
  }

  Widget _headerText() {
    return Text(
      "TODO LIST",
      style: FontStyles.normalTextStyle,
    );
  }

  Widget buildTaskList(BuildContext context, List<Task> taskList) {
    return Flexible(
      flex: 1,
      child: ListView.builder(
          itemCount: taskList.length,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0)
              return Column(
                children: <Widget>[
                  _headerText(),
                  buildDismissibleCard(taskList, index, context)
                ],
              );
            return buildDismissibleCard(taskList, index, context);
          }),
    );
  }

  Widget buildDismissibleCard(
      List<Task> taskList, int index, BuildContext context) {
    return Dismissible(
      direction: DismissDirection.horizontal,
      onDismissed: (direction) {
        final taskbloc = BlocProvider.of<TaskBloc>(context);
        taskbloc.add(CompleteTaskEvent(index));
      },
      background: Container(
        color: Colors.green,
      ),
      key: UniqueKey(),
      child: ListTile(
        onTap: () {
          final taskbloc = BlocProvider.of<TaskBloc>(context);
          taskbloc.add(LoadTaskEvent(index));
        },
        leading: Text(taskList[index].name),
        title: Text(
          DateTimeServiceProvider.dateTimetoStr(taskList[index].dateTime),
          style: DateTimeServiceProvider.isDelayed(taskList[index].dateTime)
              ? FontStyles.normalTextStyle
              : FontStyles.taskDeadLineStyle,
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.check_circle_outline,
            color: Colors.green,
          ),
          onPressed: () {
            final taskbloc = BlocProvider.of<TaskBloc>(context);
            taskbloc.add(CompleteTaskEvent(index));
          },
        ),
      ),
    );
  }

  Widget buildTextForm(BuildContext context,
      {String name = "",
      String desc = "",
      DateTime datetime,
      String buttonTitle = "ADD"}) {
    return Flexible(
      flex: 1,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Text("Deadline:"),
            title: DateTimeField(
              controller: dateTimeTxtcontroller,
              format: DateFormat("yyyy-MM-dd"),
              decoration: const InputDecoration(
                border: const OutlineInputBorder(),
              ),
              onShowPicker: (context, currentValue) {
                return showDatePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2200));
              },
            ),
          ),
          ListTile(
            leading: Text("Task:"),
            title: TextField(
              controller: nameTxtController,
              decoration: const InputDecoration(
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          ListTile(
            leading: Text("Description:"),
            title: TextField(
              controller: descriptiontxtConroller,
              maxLines: 5,
              decoration: const InputDecoration(
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          RaisedButton(
              textTheme: ButtonTextTheme.primary,
              color: Theme.of(context).primaryColor,
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * (80 / 100),
                  child: Text(
                    buttonTitle,
                    textAlign: TextAlign.center,
                  )),
              onPressed: () {
                final bloc = BlocProvider.of<TaskBloc>(context);
                bloc.add(AddTaskEvent(
                    dateTimeTxtcontroller.text,
                    nameTxtController.text,
                    descriptiontxtConroller.text ?? DateTime.now().toString()));
              }),
        ],
      ),
    );
  }

  void resetControllerResources() {
    dateTimeTxtcontroller.clear();
    nameTxtController.clear();
    descriptiontxtConroller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskBloc, TaskState>(listener: (context, state) {
      if (state is InitialTaskState) {
        resetControllerResources();
        Scaffold.of(context).showSnackBar(SnackBar(
            duration: const Duration(milliseconds: 500),
            content: Text(
              "Great Add your Tasks become more productive.",
            )));
      } else if (state is LoadedTaskState) {
        resetControllerResources();
        dateTimeTxtcontroller.text =
            DateTimeServiceProvider.dateTimetoStr(state.loadedTask.dateTime);
        nameTxtController.text = state.loadedTask.name ?? "";
        descriptiontxtConroller.text = state.loadedTask.description ?? "";
        Scaffold.of(context).showSnackBar(SnackBar(
            duration: const Duration(milliseconds: 500),
            content: Text("Loaded the Task for Editing")));
      } else if (state is TaskError) {
        resetControllerResources();
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text(state.message)));
      } else if (state is CompletedTaskState) {
        resetControllerResources();
        Scaffold.of(context).showSnackBar(SnackBar(
            duration: const Duration(milliseconds: 500),
            content: Text("Congradulations over Task Completion")));
      } else if (state is AddedToListState) {
        
        Scaffold.of(context).showSnackBar(SnackBar(
            duration: const Duration(milliseconds: 500),
            content: Text(
                "${state.task.name} is Successfully added DeadLine ${DateTimeServiceProvider.dateTimetoStr(state.task.dateTime)}")));
      } else {

      }
    }, child: BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is InitialTaskState)
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[buildTextForm(context), _buildNoListFound()],
          );
        else if (state is ProcessingEventState)
          return Column(
            children: <Widget>[
              buildTextForm(context),
              buildTaskList(context, state.taskList)
            ],
          );
        else if (state is AddedToListState)
          return Column(
            children: <Widget>[
              buildTextForm(context),
              buildTaskList(context, state.taskList),
            ],
          );
        else if (state is LoadedTaskState) {
          return Column(
            children: <Widget>[
              buildTextForm(context,
                  name: state.loadedTask.name,
                  datetime: state.loadedTask.dateTime,
                  buttonTitle: "SAVE",
                  desc: state.loadedTask.description),
              buildTaskList(context, state.taskList)
            ],
          );
        } else if (state is CompletedTaskState) {
          return Column(
            children: <Widget>[
              buildTextForm(context),
              buildTaskList(context, state.taskList)
            ],
          );
        } else if (state is TaskError) {
          return Column(
            children: <Widget>[
              Center(child: Text(state.message)),
            ],
          );
        } else {
          return Container();
        }
      },
    ));
  }
}
