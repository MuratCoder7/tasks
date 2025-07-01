

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/models/completed_task_model.dart';
import '../../data/models/task_model.dart';

class HiveService{
  static Box<TaskModel>? _box;
  static Box<CompletedTaskModel>? _completedTaskBox;

  static Future<void> init()async{
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    Hive.registerAdapter(TaskModelAdapter());
    Hive.registerAdapter(CompletedTaskModelAdapter());
    _box = await Hive.openBox<TaskModel>("my_task");
    _completedTaskBox = await Hive.openBox<CompletedTaskModel>("my_completed_task");
  }


  // TASKS ____________________________________________________________________

  // CREATE TASKS
  Future<void> createTasks({required TaskModel task})async{
    await _box?.add(task);
  }

  // LOAD TASKS
  Future<List<TaskModel>> loadTasks()async{
    List<TaskModel> allTasks = [];
    for(int i = 0; i<_box!.length; i++){
      var task = _box!.getAt(i);
      allTasks.add(task!);
    }
    return allTasks;
  }

  // UPDATE A TASK
  Future<void> updateTask({required int index,
    required String newTaskName,
    required DateTime newTime,
  })async{
    var task = _box!.getAt(index);
    if(task !=null){
      task.taskName = newTaskName;
      task.dateTime = newTime;
      task.save();  // ✅ This updates the fields in Hive directly
    }
  }

  // DELETE A TASK
  Future<void> deleteTask(int index)async{
    await _box!.deleteAt(index);
  }

  // ___________________________________________________________________________

// COMPLETED TASKS _____________________________________________________________

  // CREATE A NEW COMPLETED TASK
  Future<void> createCompletedTasks({required CompletedTaskModel completedTask})async{
    await _completedTaskBox?.add(completedTask);
  }

  // LOAD COMPLETED TASKS
  Future<List<CompletedTaskModel>> loadCompletedTasks()async{
    List<CompletedTaskModel> completedTasks = [];
    for(int i = 0; i<_completedTaskBox!.length; i++){
      var task = _completedTaskBox!.getAt(i);
      completedTasks.add(task!);
    }
    return completedTasks;
  }

  // DELETE A COMPLETED TASK
  Future<void> deleteCompletedTask({required int index})async{
    await _completedTaskBox!.deleteAt(index);
  }

}