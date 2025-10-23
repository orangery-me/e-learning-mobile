import 'package:e_learning_mobile/data/dtos/lectures/lecture_response_dto.dart';
import 'package:e_learning_mobile/di/di.dart';
import 'package:e_learning_mobile/presentation/learn/bloc/code_exercise/code_exercise_bloc.dart';
import 'package:e_learning_mobile/presentation/learn/bloc/notes/notes_bloc.dart';
import 'package:e_learning_mobile/presentation/learn/view/code_exercises/code_exercise_modal.dart';
import 'package:e_learning_mobile/presentation/learn/view/take_notes/note_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class OtherFeaturePage extends StatelessWidget {
  final String courseId;
  final LectureResponseDto? selectedLecture;
  final VideoPlayerController? videoController;
  final YoutubePlayerController? youtubeController;
  const OtherFeaturePage(
      {super.key,
      required this.courseId,
      this.selectedLecture,
      this.videoController,
      this.youtubeController});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<NotesBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<CodeExerciseBloc>(),
        ),
      ],
      child: OtherFeatureView(
        courseId: courseId,
        selectedLecture: selectedLecture,
        videoController: videoController,
        youtubeController: youtubeController,
      ),
    );
  }
}

class OtherFeatureView extends StatefulWidget {
  final String courseId;
  final LectureResponseDto? selectedLecture;
  final VideoPlayerController? videoController;
  final YoutubePlayerController? youtubeController;
  const OtherFeatureView(
      {super.key,
      required this.courseId,
      this.selectedLecture,
      this.videoController,
      this.youtubeController});

  @override
  State<OtherFeatureView> createState() => _OtherFeatureViewState();
}

class _OtherFeatureViewState extends State<OtherFeatureView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text('Notes'),
          leading: Icon(Icons.note),
          onTap: () {
            final parentBloc = context.read<NotesBloc>();

            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                elevation: 10,
                builder: (_) {
                  return BlocProvider.value(
                    value: parentBloc,
                    child: Builder(builder: (newContext) {
                      return NoteModal(
                        videoController: widget.videoController,
                        youtubeController: widget.youtubeController,
                        selectedLecture: widget.selectedLecture,
                      );
                    }),
                  );
                });
          },
        ),
        // ListTile(
        //   title: Text('Coding Practice'),
        //   leading: Icon(Icons.note),
        //   onTap: () {
        //     final parentBloc = context.read<CodeExerciseBloc>();

        //     showModalBottomSheet(
        //         context: context,
        //         isScrollControlled: true,
        //         useSafeArea: true,
        //         backgroundColor: Colors.white,
        //         shape: const RoundedRectangleBorder(
        //           borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        //         ),
        //         builder: (_) {
        //           return BlocProvider.value(
        //             value: parentBloc,
        //             child: Builder(builder: (newContext) {
        //               return CodeExerciseModal();
        //             }),
        //           );
        //         });
        //   },
        // ),
      ],
    );
  }
}
