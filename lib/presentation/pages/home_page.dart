import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../data/models/task_model.dart";
import "../bloc/home_bloc.dart";
import "../widgets/add_tasks.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _tasksController = TextEditingController();
  final Map<int, Timer> _taskTimers = {};
  // Store temporary state changes
  Set<int> temporarilyUnchecked = {};

  _addTasks() {
    showDialog(
      context: (context),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: AddTasks(
            tasksController: _tasksController,
            cancel: () {
              Navigator.pop(context);
            },
            add: () {
              context.read<HomeBloc>().add(
                CreateEvent(
                  taskModel: TaskModel(
                    taskName: _tasksController.text.trim(),
                    isCompleted: false,
                    dateTime: DateTime.now(),
                  ),
                ),
              );
              Navigator.pop(context);
              _tasksController.clear();
            },
          ),
        );
      },
    );
  }

  _updateTask({required TaskModel task, required int index}) {
    _tasksController.text = task.taskName;
    showDialog(
      context: (context),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: AddTasks(
            tasksController: _tasksController,
            cancel: () {
              Navigator.pop(context);
              _tasksController.clear();
            },
            add: () {
              context.read<HomeBloc>().add(
                EditEvent(
                  index: index,
                  taskName: _tasksController.text.trim(),
                  dateTime: DateTime.now(),
                ),
              );
              Navigator.pop(context);
              _tasksController.clear();
            },
          ),
        );
      },
    );
  }

  // _deleteTask(int index)async{
  //   if (!mounted) return; // ⛔️ Don't continue if widget is disposed
  //   context.read<HomeBloc>().add(UpdateEvent(index: index));
  // }

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(LoadEvent());
  }

  @override
  void dispose() {
    _tasksController.dispose();
    for (var timer in _taskTimers.values) {
      timer.cancel();
    }
    temporarilyUnchecked.clear();
    _taskTimers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is HomeSuccessState) {
            final tasks = state.tasks;
            final reversedTasks =
            tasks.reversed.toList(); // reverse for display
           if(state.tasks.isEmpty){
             return Center(
               child:Text("You don't have any tasks",
                 style:Theme.of(context).textTheme.titleMedium,
               )
             );
           }
            return ListView.builder(
              itemCount: reversedTasks.length,
              itemBuilder: (context, index) {
                final task = reversedTasks[index];
                final originalIndex =
                    tasks.length - 1 - index; // reverse index mapping
                return _itemOfTask(task, originalIndex); // pass original index!
              },
            );
          } else if (state is HomeErrorState) {
            return Center(child: Text("Error occurred",
              style:Theme.of(context).textTheme.titleMedium,));
          } else if (state is HomeLoadingState) {
            return Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          } else {
            return Center(child: Text("Error occurred",
              style:Theme.of(context).textTheme.titleMedium,),);
          }
        },
      ),
      backgroundColor: Color(0xFF0D4673),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTasks();
        },
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        child: Icon(Icons.edit),
      ),
    );
  }

  Widget _itemOfTask(TaskModel task, int index) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      padding: EdgeInsets.fromLTRB(1, 20, 8, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Checkbox(
                  value:
                  temporarilyUnchecked.contains(index)
                      ? true
                      : task.isCompleted,
                  onChanged: (value) async {
                    if (value == true) {
                      temporarilyUnchecked.add(index);
                      setState(() {});
                      _taskTimers[index]?.cancel();
                      _taskTimers[index] = Timer(Duration(seconds: 2), () {
                        if (!mounted) return;
                        temporarilyUnchecked.remove(index);
                        context.read<HomeBloc>().add(UpdateEvent(index: index));
                      });
                    } else {
                      temporarilyUnchecked.remove(index);
                      setState(() {});
                      _taskTimers[index]
                          ?.cancel(); // cancel delete if unchecked
                    }
                  },
                  checkColor: Colors.white,
                  activeColor: Colors.green,
                  side: BorderSide(color: Colors.grey),
                ),
                Expanded(
                  child: SelectableText(
                    task.taskName,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  _updateTask(task: task, index: index);
                },
                icon: Icon(Icons.edit, color: Color(0xFF0D4673)),
              ),
              Text(
                "${task.dateTime}".substring(0, 10),
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
