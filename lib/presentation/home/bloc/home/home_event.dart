part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadHomeData extends HomeEvent {
  const LoadHomeData();
}

class LoadRandomCategoryCourses extends HomeEvent {
  final int count;

  const LoadRandomCategoryCourses({this.count = 3});

  @override
  List<Object> get props => [count];
}
