import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:e_learning_mobile/common/theme/palette.dart';
import 'package:e_learning_mobile/common/utils/dialog_util.dart';
import 'package:e_learning_mobile/data/dtos/lectures/lecture_response_dto.dart';
import 'package:e_learning_mobile/di/di.dart';
import 'package:e_learning_mobile/presentation/learn/bloc/sections/sections_bloc.dart';
import 'package:e_learning_mobile/presentation/learn/view/code_exercises/code_exercise_modal.dart';
import 'package:e_learning_mobile/presentation/learn/view/other_feature_view.dart';
import 'package:e_learning_mobile/presentation/learn/view/section_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:e_learning_mobile/presentation/learn/bloc/video_play/video_play_bloc.dart';

class VieoPlayPage extends StatelessWidget {
  final String videoUrl;
  final String courseId;

  const VieoPlayPage({
    super.key,
    required this.videoUrl,
    required this.courseId,
  });

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
      ],
      child: VideoPlayView(videoUrl: videoUrl, courseId: courseId),
    );
  }
}

class VideoPlayView extends StatefulWidget {
  final String videoUrl;
  final String courseId;

  const VideoPlayView({
    super.key,
    required this.videoUrl,
    required this.courseId,
  });

  @override
  State<VideoPlayView> createState() => _VideoPlayViewState();
}

// Use VideoType from VideoPlayBloc to avoid duplicate enum definitions

class _VideoPlayViewState extends State<VideoPlayView> {
  YoutubePlayerController? _youtubeController;
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  VideoType _currentVideoType = VideoType.hosted;
  bool isLoading = true;
  final bool _isDisposed = false;
  LectureResponseDto? _selectedLecture;
  int lastLoggedTime = 0;

  @override
  void initState() {
    super.initState();
    _initializeVideo(widget.videoUrl);

    // Load sections after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SectionsBloc>().add(LoadSectionsByCourseId(widget.courseId));
    });
  }

  bool _isYoutubeUrl(String url) {
    return url.contains('youtube.com') ||
        url.contains('youtu.be') ||
        url.contains('youtube-nocookie.com');
  }

  void _disposeControllers() {
    _chewieController?.dispose();
    _youtubeController?.dispose();
    _videoController?.dispose();
    _chewieController = null;
    _youtubeController = null;
    _videoController = null;
  }

  void _finishLoading() {
    if (!_isDisposed) {
      setState(() => isLoading = false);
    }
  }

  void _initializeYoutubeVideo(String url) {
    // set current video type
    _currentVideoType = VideoType.youtube;
    context
        .read<VideoPlayBloc>()
        .add(const SetVideoType(videoType: VideoType.youtube));

    final videoId = YoutubePlayer.convertUrlToId(url);

    if (videoId == null) {
      _finishLoading();
      return;
    }

    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    )..addListener(_registerVideoEventListener);

    _finishLoading();
  }

  void _initializeHostedVideo(String url) {
    // set current video type
    _currentVideoType = VideoType.hosted;
    context
        .read<VideoPlayBloc>()
        .add(const SetVideoType(videoType: VideoType.hosted));

    _videoController = VideoPlayerController.networkUrl(Uri.parse(url))
      ..initialize().then((_) {
        if (_isDisposed) return;

        _chewieController = ChewieController(
          videoPlayerController: _videoController!,
          autoPlay: false,
          looping: false,
        );

        _videoController!.addListener(_registerVideoEventListener);

        _finishLoading();
      }).catchError((error) {
        log('Error initializing video: $error');
        _finishLoading();
      });
  }

  void _initializeVideo(String? videoUrl) {
    if (_isDisposed) return;

    setState(() {
      isLoading = true;
    });

    // Dispose previous controllers
    _disposeControllers();

    if (videoUrl == null || videoUrl.isEmpty) {
      _finishLoading();
      return;
    }

    if (_isYoutubeUrl(videoUrl)) {
      _initializeYoutubeVideo(videoUrl);
    } else {
      _initializeHostedVideo(videoUrl);
    }
  }

  void _getLectureEvents(String lectureId) {
    // load video events
    context
        .read<VideoPlayBloc>()
        .add(GetEventsByLectureId(lectureId: lectureId));
  }

  Widget _buildVideoPlayer() {
    if (isLoading) {
      return Container(
        height: 250,
        width: double.infinity,
        color: Colors.black,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_currentVideoType == VideoType.youtube && _youtubeController != null) {
      return SizedBox(
        height: 250,
        width: double.infinity,
        child: YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: _youtubeController!,
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
    } else if (_currentVideoType == VideoType.hosted &&
        _chewieController != null &&
        _videoController != null &&
        _videoController!.value.isInitialized) {
      return Container(
        height: 250,
        width: double.infinity,
        color: Colors.black,
        child: Chewie(controller: _chewieController!),
      );
    }

    return Container(
      height: 250,
      width: double.infinity,
      color: Colors.black,
      child: const Center(
        child: Text(
          'Unable to load video',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _registerVideoEventListener() {
    final currentPos = _currentVideoType == VideoType.youtube
        ? _youtubeController?.value.position.inSeconds
        : _videoController?.value.position.inSeconds;

    if (currentPos != null && currentPos != lastLoggedTime) {
      // only update every 1 second to reduce event spam
      lastLoggedTime = currentPos;
      // Dispatch event
      context
          .read<VideoPlayBloc>()
          .add(UpdatePosition(positionSeconds: currentPos));
      // log('Current video position: $currentPos seconds');
    }
  }

  void _acceptToDoExercise(BuildContext context) {
    // close dialog
    Navigator.of(context).pop();
    // add event to accept exercise
    context
        .read<VideoPlayBloc>()
        .add(const AskToDoExercise(acceptToDoExercise: true));
  }

  Widget _buildContent() {
    return Expanded(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            SizedBox(
              height: 50,
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
                    log('video url: ${selectedLecture.videoUrl}');
                    // Only initialize if the video URL is different
                    if (selectedLecture.videoUrl != widget.videoUrl) {
                      _selectedLecture = selectedLecture;
                      _getLectureEvents(selectedLecture.lectureId);
                      _initializeVideo(selectedLecture.videoUrl);
                    }
                  },
                ),
                // tab 2: More features
                OtherFeaturePage(
                    courseId: widget.courseId,
                    selectedLecture: _selectedLecture,
                    videoController: _videoController,
                    youtubeController: _youtubeController)
              ]),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<VideoPlayBloc, VideoPlayState>(
          listenWhen: (previous, current) =>
              previous.acceptToDoExercise != current.acceptToDoExercise,
          listener: (context, state) {
            // show code exercise modal
            if (state.acceptToDoExercise) {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (_) => CodeExercisePage(
                      problemStatement: state.problemStatement));
            }
          },
        ),
        BlocListener<VideoPlayBloc, VideoPlayState>(
          listenWhen: (previous, current) =>
              previous.currentEvents != current.currentEvents,
          listener: (context, state) {
            // show dialog to ask user to do the exercise
            DialogUtil.showCustomDialog(context,
                title: "Code Exercise",
                content: "Do you want to attempt the code exercise now?",
                isConfirmDialog: true,
                confirmButtonText: "Yes",
                cancelButtonText: "No",
                confirmAction: () => _acceptToDoExercise(context),
                cancelAction: () {
                  Navigator.of(context).pop();
                });
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Course Learning',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
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


// showDialog(
            //     context: context,
            //     builder: (newContext) {
            //       return AlertDialog(
            //         title: const Text('Code Exercise'),
            //         content: const Text(
            //             'Do you want to attempt the code exercise now?'),
            //         actions: [
            //           TextButton(
            //               child: const Text('No'),
            //               onPressed: () {
            //                 Navigator.of(newContext).pop();
            //               }),
            //           TextButton(
            //             child: const Text('Yes'),
            //             onPressed: () {
            //               Navigator.of(newContext).pop();
            //               // add event to get code exercise
            //               context.read<VideoPlayBloc>().add(
            //                     const AskToDoExercise(
            //                         acceptToDoExercise: true),
            //                   );
            //               // show code exercise modal
            //               showModalBottomSheet(
            //                   context: context,
            //                   isScrollControlled: true,
            //                   backgroundColor: Colors.white,
            //                   shape: RoundedRectangleBorder(
            //                     borderRadius: BorderRadius.vertical(
            //                         top: Radius.circular(20)),
            //                   ),
            //                   builder: (_) => CodeExercisePage(
            //                       problemStatement: state.problemStatement));
            //             },
            //           ),
            //         ],
            //       );
            //     });
            // }