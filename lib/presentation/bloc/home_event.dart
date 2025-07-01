
part of "home_bloc.dart";

@immutable
abstract class HomeEvent{}

// CREATE A NEW TASK
class CreateEvent extends HomeEvent{
  final TaskModel taskModel;
  CreateEvent({required this.taskModel});
}

// UPDATE A TASK
class UpdateEvent extends HomeEvent{
  final int index;
  UpdateEvent({required this.index});
}

// EDIT A TASK
class EditEvent extends HomeEvent{
  final int index;
  final String taskName;
  final DateTime dateTime;
  EditEvent({required this.index,required this.taskName,required this.dateTime});
}

// LOAD TASKS
class LoadEvent extends HomeEvent{}

// DELETE A TASK
class DeleteEvent extends HomeEvent{}
