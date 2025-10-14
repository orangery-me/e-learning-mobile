part of 'home_bloc.dart';

class HomeState extends Equatable {
  final bool isLoading;
  final List<String> randomCategories;
  final String? errorMessage;

  const HomeState({
    this.isLoading = false,
    this.randomCategories = const [],
    this.errorMessage,
  });

  @override
  List<Object?> get props => [isLoading, randomCategories, errorMessage];

  HomeState copyWith({
    bool? isLoading,
    List<String>? randomCategories,
    String? errorMessage,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      randomCategories: randomCategories ?? this.randomCategories,
      errorMessage: errorMessage,
    );
  }
}
