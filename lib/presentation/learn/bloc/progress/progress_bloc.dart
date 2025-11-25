import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:e_learning_mobile/data/datasources/progress/progress_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'progress_event.dart';
part 'progress_state.dart';

@injectable
class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  ProgressBloc() : super(ProgressInitial()) {
    on<LoadCurrentProgress>((event, emit) => _loadCurrentItem(event, emit));
  }

  Future<void> _loadCurrentItem(
      LoadCurrentProgress event, Emitter<ProgressState> emit) async {
    try {
      emit(ProgressLoading());
      log('Loading progress for lectureId: ${event.enrollmentId}');
      // mock data
      final progress = ProgressDto(
        id: '11bc53ac-3acd-4365-be9c-0a732bc3ec28',
        completionDate: DateTime.now(),
        createdAt: DateTime.now(),
        isCompleted: false,
        updatedAt: DateTime.now(),
        lastViewedAt: DateTime.now(),
        enrollmentId: '11bc53ac-3acd-4365-be9c-0a732bc3ec28',
        lectureId: '2c262526-7ee8-4d89-8d93-429d8b908c2f',
        // lectureId: '438d01b6-feba-4a47-9f4b-5610e10bdfbf',
        sectionId: 'a1f7d3d1-1b22-4b12-b34c-123456789001',
        // sectionId: 'a1f7d3d1-1b22-4b12-b34c-123456789011',
        videoUrl:
            'https://dinhlooc-test-2025.s3.us-east-1.amazonaws.com/video-30012ca2-77fb-4635-be60-77f481933d63-1758467257284.mp4',
        videoPositionSeconds:
            120, // Mock: user watched up to 2 minutes (120 seconds)
      );

      // wait 2 seconds
      await Future.delayed(const Duration(seconds: 2));

      emit(ProgressLoaded(progress));
      log('Progress loaded: $progress');
    } catch (e) {
      emit(ProgressError(e.toString()));
    }
  }
}
