import 'dart:developer' as dev;
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:e_learning_mobile/data/datasources/course/course_datasource.dart';
import 'package:injectable/injectable.dart';

part 'home_event.dart';
part 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final CourseDatasource courseDatasource;

  HomeBloc({required this.courseDatasource}) : super(const HomeState()) {
    on<LoadHomeData>((event, emit) => loadHomeData(event, emit));
    on<LoadRandomCategoryCourses>(
        (event, emit) => loadRandomCategoryCourses(event, emit));
  }

  Future<void> loadHomeData(LoadHomeData event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      // Load categories first
      final categories = await courseDatasource.fetchCategories();

      // Select random categories
      final random = Random();
      final shuffled = List<String>.from(categories)..shuffle(random);
      final randomCategories = shuffled.take(3).toList();

      emit(state.copyWith(
        randomCategories: randomCategories,
        isLoading: false,
      ));
    } catch (e) {
      dev.log(e.toString());
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> loadRandomCategoryCourses(
      LoadRandomCategoryCourses event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      // Load categories and select random ones
      final categories = await courseDatasource.fetchCategories();
      final random = Random();
      final shuffled = List<String>.from(categories)..shuffle(random);
      final randomCategories = shuffled.take(event.count).toList();

      emit(state.copyWith(
        randomCategories: randomCategories,
        isLoading: false,
      ));
    } catch (e) {
      dev.log(e.toString());
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }
}
