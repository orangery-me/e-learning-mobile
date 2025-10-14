part of 'home_bloc.dart';

class HomeState extends Equatable {
  final bool isLoading;
  final List<String> randomCategories;
  final List<String>? allCategories;
  final String? errorMessage;

  const HomeState({
    this.isLoading = false,
    this.randomCategories = const [],
    this.allCategories,
    this.errorMessage,
  });

  @override
  List<Object?> get props =>
      [isLoading, randomCategories, allCategories, errorMessage];

  HomeState copyWith({
    bool? isLoading,
    List<String>? randomCategories,
    List<String>? allCategories,
    String? errorMessage,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      randomCategories: randomCategories ?? this.randomCategories,
      allCategories: allCategories ?? this.allCategories,
      errorMessage: errorMessage,
    );
  }
}
