import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/services/hive_service.dart';
import '../../data/models/completed_task_model.dart';
import '../../data/models/task_model.dart';


part "completed_tasks_event.dart";
part "completed_tasks_state.dart";

class CompletedTasksBloc extends Bloc<CompletedTasksEvent,CompletedTasksState>{

  CompletedTasksBloc():super(CompletedTasksInitialState()){
    on<LoadCompletedTasksEvent>(_onLoadCompletedTasksEvent);
    on<DeleteCompletedTasksEvent>(_onDeleteCompletedTasksEvent);
    on<UpdateCompletedTasksEvent>(_onUpdateCompletedTasksEvent);
  }


  List<CompletedTaskModel> completedTasks = [];
  final _hiveService = HiveService();


  // LOAD ALL TASKS
  _onLoadCompletedTasksEvent(LoadCompletedTasksEvent event,Emitter<CompletedTasksState> emit)async{
    emit(CompletedTasksLoadingState());
    try{
      await Future.delayed(Duration(seconds:1));
      completedTasks = await _hiveService.loadCompletedTasks();
      return emit(CompletedTasksSuccessState(completedTasks: completedTasks));
    }catch(_){
      return emit(CompletedTasksErrorState());
    }
  }

  // DELETE A TASK
  _onDeleteCompletedTasksEvent(DeleteCompletedTasksEvent event,Emitter<CompletedTasksState> emit)async{
    final index = event.index;
    emit(CompletedTasksLoadingState());
    try{
      await Future.delayed(Duration(seconds:1));
      await _hiveService.deleteCompletedTask(index: index);
      completedTasks = await _hiveService.loadCompletedTasks();
      return emit(CompletedTasksSuccessState(completedTasks: completedTasks));
    }catch(_){
      return emit(CompletedTasksErrorState());
    }
  }

  // UNCHECK A TASK
  _onUpdateCompletedTasksEvent(UpdateCompletedTasksEvent event,Emitter<CompletedTasksState>emit)async{
    final index = event.index;
    try{
      await _hiveService.createTasks(task: TaskModel(taskName: completedTasks[index].taskName, isCompleted: false, dateTime: completedTasks[index].dateTime));
      await _hiveService.deleteCompletedTask(index: index);
      completedTasks = await _hiveService.loadCompletedTasks();
      return emit(CompletedTasksSuccessState(completedTasks: completedTasks));
    }catch(_){
      return emit(CompletedTasksErrorState());
    }
  }

}