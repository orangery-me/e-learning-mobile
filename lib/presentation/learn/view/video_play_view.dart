import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:e_learning_mobile/common/theme/palette.dart';
import 'package:e_learning_mobile/common/utils/dialog_util.dart';
import 'package:e_learning_mobile/data/dtos/courses/course_response_dto.dart';
import 'package:e_learning_mobile/data/dtos/enrollment/enrollment_dto.dart';
import 'package:e_learning_mobile/data/dtos/lectures/lecture_response_dto.dart';
import 'package:e_learning_mobile/di/di.dart';
// import 'package:e_learning_mobile/presentation/learn/bloc/lectures/lectures_bloc.dart';
import 'package:e_learning_mobile/presentation/learn/bloc/progress/progress_bloc.dart';
import 'package:e_learning_mobile/presentation/learn/bloc/sections/sections_bloc.dart';
import 'package:e_learning_mobile/presentation/learn/view/code_exercises/code_exercise_modal.dart';
import 'package:e_learning_mobile/presentation/learn/view/quizz/quizz_page.dart';
import 'package:e_learning_mobile/presentation/learn/view/other_feature_view.dart';
import 'package:e_learning_mobile/presentation/learn/view/section_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:e_learning_mobile/presentation/learn/bloc/video_play/video_play_bloc.dart';
import 'package:e_learning_mobile/data/dtos/video_event/video_event.dart';

class VideoPlayPage extends StatelessWidget {
  final EnrollmentDto enrollment;
  final CourseResponseDto course;

  const VideoPlayPage(
      {super.key, required this.enrollment, required this.course});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<SectionsBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<VideoPlayBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<ProgressBloc>(),
        )
      ],
      child: VideoPlayView(enrollment: enrollment, course: course),
    );
  }
}

class VideoPlayView extends StatefulWidget {
  final EnrollmentDto enrollment;
  final CourseResponseDto course;

  const VideoPlayView(
      {super.key, required this.enrollment, required this.course});

  @override
  State<VideoPlayView> createState() => _VideoPlayViewState();
}

class _VideoPlayViewState extends State<VideoPlayView> {
  LectureResponseDto? _selectedLecture;

  @override
  void initState() {
    super.initState();
    // load current progress
    context.read<ProgressBloc>().add(LoadCurrentProgress(widget.enrollment.id));

    // Load sections after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<SectionsBloc>()
          .add(LoadSectionsByCourseId(widget.course.courseId));
    });
  }

  Widget _buildVideoPlayer() {
    return BlocBuilder<VideoPlayBloc, VideoPlayState>(
      builder: (context, state) {
        final videoBloc = context.read<VideoPlayBloc>();

        if (state.isLoading) {
          return Container(
            height: 220,
            width: double.infinity,
            color: Colors.black,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state.videoType == VideoType.youtube &&
            videoBloc.youtubeController != null) {
          return SizedBox(
            height: 220,
            width: double.infinity,
            child: YoutubePlayerBuilder(
              player: YoutubePlayer(
                controller: videoBloc.youtubeController!,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.red,
                progressColors: const ProgressBarColors(
                  playedColor: Colors.red,
                  handleColor: Colors.redAccent,
                ),
                onReady: () {
                  log('YouTube Player is ready');
                },
              ),
              builder: (BuildContext context, Widget player) {
                return player;
              },
            ),
          );
        } else if (state.videoType == VideoType.hosted &&
            videoBloc.chewieController != null &&
            videoBloc.videoController != null &&
            context
                .read<VideoPlayBloc>()
                .videoController!
                .value
                .isInitialized) {
          return Container(
            height: 220,
            width: double.infinity,
            color: Colors.black,
            child: Chewie(controller: videoBloc.chewieController!),
          );
        }

        return Container(
          height: 220,
          width: double.infinity,
          color: Colors.black,
          child: const Center(
            child: Text(
              'Unable to load video',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            SizedBox(
              height: 40,
              child: TabBar(tabs: [
                Tab(text: 'Lectures'),
                Tab(text: 'More'),
              ]),
            ),
            // Sections and Lectures List
            Expanded(
              child: TabBarView(children: [
                // tab 1: Lectures
                SectionListView(
                  onLectureSelected: (selectedLecture) {
                    _selectedLecture = selectedLecture;
                    // Use bloc to handle lecture selection
                    context.read<VideoPlayBloc>().add(
                          SelectLecture(
                            lectureId: selectedLecture.lectureId,
                            videoUrl: selectedLecture.videoUrl ?? '',
                          ),
                        );
                  },
                ),
                // tab 2: More features
                BlocProvider.value(
                    value: context.read<VideoPlayBloc>(),
                    child: OtherFeaturePage(
                        enrollment: widget.enrollment,
                        selectedLecture: _selectedLecture,
                        videoController:
                            context.read<VideoPlayBloc>().videoController,
                        youtubeController:
                            context.read<VideoPlayBloc>().youtubeController)),
              ]),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose through bloc
    context.read<VideoPlayBloc>().add(const DisposeVideo());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // event listener to get current progress and initialize video position
        BlocListener<ProgressBloc, ProgressState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {
            if (state is ProgressLoaded) {
              final progress = state.progress;

              if (progress != null && progress.videoPositionSeconds != null) {
                // 1. Select section from progress
                context
                    .read<SectionsBloc>()
                    .add(SelectSection(progress.sectionId));

                // 2. Select the lecture and initialize video
                context.read<VideoPlayBloc>().add(SelectLecture(
                      lectureId: progress.lectureId,
                      videoUrl: progress.videoUrl ?? '',
                    ));
              }
            }
            if (state is ProgressError) {
              log('Error loading progress: ${state.message}');
            }
          },
        ),

        // event listener to show modal for code exercise or quiz
        BlocListener<VideoPlayBloc, VideoPlayState>(
          listenWhen: (previous, current) =>
              previous.acceptToDoExercise != current.acceptToDoExercise,
          listener: (context, state) {
            if (!state.acceptToDoExercise) return;

            // Determine current event type (CODE or QUIZ)
            final VideoEvent? currentEvent = state.currentEvents.isNotEmpty
                ? state.currentEvents.first
                : null;

            if (currentEvent == null) {
              return;
            }

            if (currentEvent.eventType == VideoEventType.CODE) {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => CodeExercisePage(
                  problemId: currentEvent.payload,
                ),
              );
            } else if (currentEvent.eventType == VideoEventType.QUIZ) {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => QuizzPage(
                  enrollmentId: widget.enrollment.id,
                  quizzId: currentEvent.payload,
                ),
              );
            }
          },
        ),

        // event listener to pause video and show dialog when an event is reached
        BlocListener<VideoPlayBloc, VideoPlayState>(
          listenWhen: (previous, current) =>
              previous.currentEvents != current.currentEvents,
          listener: (_, state) {
            if (state.currentEvents.isEmpty) return;

            final currentEvent = state.currentEvents.first;
            final isCodeEvent = currentEvent.eventType == VideoEventType.CODE;

            // stop the video
            context.read<VideoPlayBloc>().add(const PauseVideo());

            // show dialog to ask user to do the exercise / quiz
            DialogUtil.showCustomDialog(
              context,
              title: isCodeEvent ? "Code Exercise" : "Quiz",
              content: isCodeEvent
                  ? "Do you want to attempt the code exercise now?"
                  : "Do you want to attempt the quiz now?",
              isConfirmDialog: true,
              confirmButtonText: "Yes",
              cancelButtonText: "No",
              confirmAction: () {
                // add event to accept exercise / quiz
                context
                    .read<VideoPlayBloc>()
                    .add(const AskToDoExercise(acceptToDoExercise: true));
                log('User accepted to do the ${isCodeEvent ? 'code exercise' : 'quiz'} ${state.acceptToDoExercise}');
              },
              cancelAction: () => context.read<VideoPlayBloc>().add(
                    const AskToDoExercise(acceptToDoExercise: false),
                  ),
            );
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.course.title,
              // ... if the title is too long, show ellipsis
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis)),
          backgroundColor: Palette.light().buttonBackground,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            // Universal Video Player
            _buildVideoPlayer(),

            // Tabs for Lectures and More
            _buildContent()
          ],
        ),
      ),
    );
  }
}
