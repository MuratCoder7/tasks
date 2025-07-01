import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../data/models/completed_task_model.dart";
import "../bloc/completed_tasks_bloc.dart";


class CompletedTasksPage extends StatefulWidget {
  const CompletedTasksPage({super.key});

  @override
  State<CompletedTasksPage> createState() => _CompletedTasksPageState();
}

class _CompletedTasksPageState extends State<CompletedTasksPage> {
  final Map<int, Timer> _taskTimers = {};
  // Store temporary state changes
  Set<int> temporarilyUnchecked = {};

  // _uncheckCompletedTasks(int index) async {
  //   if (!mounted) return; // ⛔️ Don't continue if widget is disposed
  //   context.read<CompletedTasksBloc>().add(
  //     UpdateCompletedTasksEvent(index: index),
  //   );
  // }

  _deleteCompletedTasks(int index) async {
    if (!mounted) return; // ⛔️ Don't continue if widget is disposed
    context.read<CompletedTasksBloc>().add(
      DeleteCompletedTasksEvent(index: index),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<CompletedTasksBloc>().add(LoadCompletedTasksEvent());
  }

  @override
  void dispose() {
    for (var timer in _taskTimers.values) {
      timer.cancel();
      temporarilyUnchecked.clear();
    }
    _taskTimers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF4CB050),
      body: BlocConsumer<CompletedTasksBloc, CompletedTasksState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is CompletedTasksLoadingState) {
            return Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          } else if (state is CompletedTasksSuccessState) {
            if (state.completedTasks.isEmpty) {
              return Center(
                child: Text("You don't have any completed tasks",
                style:Theme.of(context).textTheme.titleMedium,
                ),
              );
            }
            return Column(
              children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(20,50,20,4),
                  child: Text("These tasks are completed ✅",
                    style:Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.completedTasks.length,
                    itemBuilder: (context, index) {
                      return _itemOfCompletedTask(state.completedTasks[index], index);
                    },
                  ),
                ),
              ],
            );
          }else if (state is CompletedTasksErrorState){
            return Center(child: Text("Error occurred",
              style:Theme.of(context).textTheme.titleMedium,));
          }
          return Center(child: Text("Error occurred",
            style:Theme.of(context).textTheme.titleMedium,));
        },
      ),
    );
  }

  Widget _itemOfCompletedTask(CompletedTaskModel task, int index) {
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
                      ? false
                      : task.isCompleted,
                  onChanged: (value) async {
                    if (value == false) {
                      temporarilyUnchecked.add(index);
                      setState(() {});

                      _taskTimers[index]?.cancel();
                      _taskTimers[index] = Timer(Duration(seconds: 2), () {
                        if (!mounted) return;
                        temporarilyUnchecked.remove(index);
                        context.read<CompletedTasksBloc>().add(
                          UpdateCompletedTasksEvent(index: index),
                        );
                      });
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
                onPressed: () async {
                  if (!mounted) return; // ✅ Check again after delay
                  await _deleteCompletedTasks(index);
                },
                icon: Icon(Icons.delete, color: Colors.red),
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
