
part of "completed_tasks_bloc.dart";

@immutable
abstract class CompletedTasksState{
}


final class CompletedTasksInitialState extends CompletedTasksState{}
//
final class CompletedTasksLoadingState extends CompletedTasksState{}

//
final class CompletedTasksSuccessState extends CompletedTasksState{
  final List<CompletedTaskModel> completedTasks;
  CompletedTasksSuccessState({required this.completedTasks});
}
final class CompletedTasksErrorState extends CompletedTasksState{}