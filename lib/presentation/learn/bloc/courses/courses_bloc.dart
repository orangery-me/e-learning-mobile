import 'package:bloc/bloc.dart';
import 'package:e_learning_mobile/data/models/course_model.dart';
import 'package:equatable/equatable.dart';

part 'courses_event.dart';
part 'courses_state.dart';

class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  CoursesBloc() : super(CoursesState()) {
    on<CoursesEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
