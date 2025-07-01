
part of "completed_tasks_bloc.dart";

@immutable
abstract class CompletedTasksEvent{}

// LOAD COMPLETED TASKS
final class LoadCompletedTasksEvent extends CompletedTasksEvent{
}


// DELETE COMPLETED TASK
final class DeleteCompletedTasksEvent extends CompletedTasksEvent{
  final int index;
  DeleteCompletedTasksEvent({required this.index});
}

// UNCHECK
final class UpdateCompletedTasksEvent extends CompletedTasksEvent{
  final int index;
  UpdateCompletedTasksEvent({required this.index});
}