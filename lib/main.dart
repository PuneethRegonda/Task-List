import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/todo_bloc.dart';
import 'todo_list_repository.dart';
import 'utils/fontStyles.dart';
import 'view/task_list_view.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: TextTheme(title: FontStyles.normalTextStyle)),
      title: "Tasks List",
      home: BlocProvider(
        create: (context) => TaskBloc(TaskListRepositoryFromMemory()),
        child: Scaffold(
          appBar: AppBar(title: Text("Task List"),centerTitle: true,),
          resizeToAvoidBottomInset: false,
          body: MyTaskListApp(),
        ),
      ),
    ));
