import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:e_learning_mobile/data/datasources/enrollment/enrollment_datasource.dart';
import 'package:e_learning_mobile/data/dtos/enrollment/enrollment_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'enrollment_event.dart';
part 'enrollment_state.dart';

@injectable
class EnrollmentBloc extends Bloc<EnrollmentEvent, EnrollmentState> {
  final EnrollmentDatasource datasource;

  EnrollmentBloc({required this.datasource}) : super(EnrollmentState()) {
    on<LoadEnrollmentsByUserId>(
        (event, emit) => loadEnrollmentsByUserId(event, emit));
    on<GetEnrollmentById>((event, emit) => getEnrollmentById(event, emit));
  }

  Future<void> loadEnrollmentsByUserId(
      LoadEnrollmentsByUserId event, Emitter<EnrollmentState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final enrollments = await datasource.getEnrollmentsByUserId(event.userId);
      emit(state.copyWith(
        enrollments: enrollments,
        isLoading: false,
      ));
    } catch (e) {
      log('Error loading enrollments by userId: $e');
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> getEnrollmentById(
      GetEnrollmentById event, Emitter<EnrollmentState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final enrollment = await datasource.getEnrollmentById(event.enrollmentId);
      emit(state.copyWith(
        selectedEnrollment: enrollment,
        isLoading: false,
      ));
    } catch (e) {
      log('Error getting enrollment by id: $e');
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
