part of 'enrollment_bloc.dart';

final class EnrollmentState extends Equatable {
  final List<EnrollmentDto> enrollments;
  final EnrollmentDto? selectedEnrollment;
  final bool isLoading;
  final String? errorMessage;

  const EnrollmentState({
    this.enrollments = const [],
    this.selectedEnrollment,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        enrollments,
        selectedEnrollment,
        isLoading,
        errorMessage,
      ];

  EnrollmentState copyWith({
    List<EnrollmentDto>? enrollments,
    EnrollmentDto? selectedEnrollment,
    bool? isLoading,
    String? errorMessage,
  }) {
    return EnrollmentState(
      enrollments: enrollments ?? this.enrollments,
      selectedEnrollment: selectedEnrollment ?? this.selectedEnrollment,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
