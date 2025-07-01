
import 'package:hive/hive.dart';
part  'completed_task_model.g.dart';

@HiveType(typeId: 1)
class CompletedTaskModel extends HiveObject{
  @HiveField(0)
  String taskName;
  @HiveField(1)
  bool isCompleted;
  @HiveField(2)
  DateTime dateTime;


  CompletedTaskModel({
    required this.taskName,
    required this.isCompleted,
    required this.dateTime,
  });

  @override
  String toString(){
    return "$taskName --$dateTime";
  }
}