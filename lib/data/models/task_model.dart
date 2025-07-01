
import 'package:hive/hive.dart';
part "task_model.g.dart";

@HiveType(typeId: 0)
class TaskModel extends HiveObject{

  @HiveField(0)
  String taskName;
  @HiveField(1)
  bool isCompleted;
  @HiveField(2)
  DateTime dateTime;


  TaskModel({
    required this.taskName,
    required this.isCompleted,
    required this.dateTime,
  });

  @override
  String toString(){
    return "$taskName --$dateTime";
  }
}