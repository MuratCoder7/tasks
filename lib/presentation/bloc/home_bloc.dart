import "package:flutter/foundation.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../core/services/hive_service.dart";
import "../../data/models/completed_task_model.dart";
import "../../data/models/task_model.dart";

part "home_state.dart";
part "home_event.dart";

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitialState()) {
    on<CreateEvent>(_onCreateEvent);
    on<LoadEvent>(_onLoadEvent);
    on<UpdateEvent>(_onUpdateEvent);
    on<EditEvent>(_onEditEvent);
  }

  final _hiveService = HiveService();
  List<TaskModel> tasks = [];
  // final List<CompletedTaskModel> completedTasks = [];

  // CREATE A NEW TASK
  _onCreateEvent(CreateEvent event, Emitter<HomeState> emit) async {
    final newTask = event.taskModel;
    emit(HomeLoadingState());
    try {
      if (newTask.taskName.isNotEmpty) {
        await _hiveService.createTasks(task: newTask);
        // Reload the updated task list
        tasks = await _hiveService.loadTasks();
        await Future.delayed(Duration(seconds: 1), () async{
        });
        return emit(HomeSuccessState(tasks: tasks));
      } else {
        // Just load tasks without creating new one
        tasks = await _hiveService.loadTasks();
        return emit(HomeSuccessState(tasks: tasks));
      }
    } catch (e) {
      return emit(HomeErrorState("Unexpected error happened"));
    }
  }

  // LOAD ALL TASKS
  _onLoadEvent(LoadEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    tasks = await _hiveService.loadTasks();
    try {
      return emit(HomeSuccessState(tasks: tasks));
    } catch (_) {
      return emit(HomeErrorState("Unexpected error happened"));
    }
  }
  // FINISH A TASK
  _onUpdateEvent(UpdateEvent event, Emitter<HomeState> emit) async {
    final index = event.index;
    try {
      await _hiveService.createCompletedTasks(
        completedTask: CompletedTaskModel(
          taskName: tasks[index].taskName,
          isCompleted: true,
          dateTime:tasks[index].dateTime,
        ),
      );
      await _hiveService.deleteTask(index);
      tasks = await _hiveService.loadTasks();
      return emit(HomeSuccessState(tasks: tasks));
    } catch (_) {
      return emit(HomeErrorState("Unexpected error happened"));
    }
  }

  // UPDATE A TASK
  _onEditEvent(EditEvent event, Emitter<HomeState> emit) async {
    final index = event.index;
    final taskName = event.taskName;
    final dateTime = event.dateTime;
    emit(HomeLoadingState());
    try {
      await _hiveService.updateTask(index: index, newTaskName: taskName, newTime: dateTime);
      tasks = await _hiveService.loadTasks();
      return emit(HomeSuccessState(tasks: tasks));
    } catch (_) {
      return emit(HomeErrorState("Unexpected error happened"));
    }
  }
}
