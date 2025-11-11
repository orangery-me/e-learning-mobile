part of 'enrollment_bloc.dart';

sealed class EnrollmentEvent extends Equatable {
  const EnrollmentEvent();

  @override
  List<Object> get props => [];
}

class LoadEnrollmentsByUserId extends EnrollmentEvent {
  final String userId;

  const LoadEnrollmentsByUserId(this.userId);

  @override
  List<Object> get props => [userId];
}

class GetEnrollmentById extends EnrollmentEvent {
  final String enrollmentId;

  const GetEnrollmentById(this.enrollmentId);

  @override
  List<Object> get props => [enrollmentId];
}
