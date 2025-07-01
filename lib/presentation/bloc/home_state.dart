
part of "home_bloc.dart";

@immutable
abstract class HomeState{}

final class HomeInitialState extends HomeState{}



final class HomeLoadingState extends HomeState{

}



final class HomeSuccessState extends HomeState{
  final List<TaskModel> tasks;
  HomeSuccessState({
    required this.tasks
  });
}


final class HomeErrorState extends HomeState{
  final String errorMessage;
  HomeErrorState(this.errorMessage);
}
