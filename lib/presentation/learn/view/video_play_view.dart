import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:e_learning_mobile/common/theme/palette.dart';
import 'package:e_learning_mobile/data/dtos/lectures/lecture_response_dto.dart';
import 'package:e_learning_mobile/di/di.dart';
import 'package:e_learning_mobile/presentation/learn/bloc/sections/sections_bloc.dart';
import 'package:e_learning_mobile/presentation/learn/widgets/section_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
    return BlocProvider(
      create: (context) => getIt<SectionsBloc>(),
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

enum VideoType { youtube, hosted }

class _VideoPlayViewState extends State<VideoPlayView> {
  YoutubePlayerController? _youtubeController;
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  VideoType _currentVideoType = VideoType.hosted;
  bool isLoading = true;
  final Map<String, bool> _expandedSections = {};
  int _currentTabIndex = 0;
  String? _selectedLectureId;

  @override
  void initState() {
    super.initState();
    _initializeVideo(widget.videoUrl);

    // Load sections after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SectionsBloc>().add(LoadSectionsByCourseId(widget.courseId));
    });
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  bool _isYoutubeUrl(String url) {
    return url.contains('youtube.com') ||
        url.contains('youtu.be') ||
        url.contains('youtube-nocookie.com');
  }

  void _initializeVideo(String? videoUrl) {
    setState(() {
      isLoading = true;
    });

    // Dispose previous controllers
    _youtubeController?.dispose();
    _videoController?.dispose();
    _youtubeController = null;
    _videoController = null;

    if (videoUrl == null || videoUrl.isEmpty) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    if (_isYoutubeUrl(videoUrl)) {
      // Initialize YouTube player
      _currentVideoType = VideoType.youtube;
      final videoId = YoutubePlayer.convertUrlToId(videoUrl);

      if (videoId != null) {
        _youtubeController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
          ),
        );
        setState(() {
          isLoading = false;
        });
      }
    } else {
      // Initialize regular video player
      _currentVideoType = VideoType.hosted;
      _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
        ..initialize().then((_) {
          _chewieController = ChewieController(
            videoPlayerController: _videoController!,
            autoPlay: false,
            looping: false,
          );
          setState(() {
            isLoading = false;
          });
        }).catchError((error) {
          log('Error initializing video: $error');
          setState(() {
            isLoading = false;
          });
        });
    }
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
      return YoutubePlayer(
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
      );
    } else if (_currentVideoType == VideoType.hosted &&
        _videoController != null) {
      return Column(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            color: Colors.black,
            child: _videoController!.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
        ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Learning'),
        backgroundColor: Palette.light().buttonBackground,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Universal Video Player
          _buildVideoPlayer(),

          // Sections and Lectures List
          Expanded(
            child: BlocBuilder<SectionsBloc, SectionsState>(
              builder: (context, state) {
                if (state.errorMessage != null) {
                  return Center(
                    child: Text('Error: ${state.errorMessage}'),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 2 tabs
                    SizedBox(
                      height: 50,
                      child: DefaultTabController(
                          length: 2,
                          child: TabBar(tabs: [
                            Tab(text: 'Lectures'),
                            Tab(text: 'More'),
                          ])),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.sections.length,
                        itemBuilder: (context, index) {
                          final section = state.sections[index];
                          final isExpanded =
                              _expandedSections[section.sectionId] ?? false;

                          // Get lectures for this section from cache
                          final sectionLectures =
                              state.getLecturesForSection(section.sectionId);
                          final isLoadingSection =
                              state.isSectionLoading(section.sectionId);

                          return SectionListItem(
                            section: section,
                            isExpanded: isExpanded,
                            lectures: sectionLectures,
                            selectedLectureId: _selectedLectureId,
                            onTap: () {
                              // Load lectures for this section when tapped
                              if (sectionLectures.isEmpty &&
                                  !isLoadingSection) {
                                context.read<SectionsBloc>().add(
                                      LoadLecturesBySectionId(
                                          section.sectionId),
                                    );
                              }
                            },
                            onToggleExpanded: () {
                              setState(() {
                                _expandedSections[section.sectionId] =
                                    !isExpanded;
                              });

                              // Load lectures when expanding if not already loaded
                              if (!isExpanded &&
                                  sectionLectures.isEmpty &&
                                  !isLoadingSection) {
                                context.read<SectionsBloc>().add(
                                      LoadLecturesBySectionId(
                                          section.sectionId),
                                    );
                              }
                            },
                            onLectureTap: (lectureId) {
                              setState(() {
                                _selectedLectureId = lectureId;
                              });

                              log('Selected lecture ID: $lectureId');

                              // Find the selected lecture from cached lectures and play its video
                              LectureResponseDto? selectedLecture;
                              for (final lectures
                                  in state.lecturesCache.values) {
                                try {
                                  selectedLecture = lectures.firstWhere(
                                      (lecture) =>
                                          lecture.lectureId == lectureId);
                                  break;
                                } catch (e) {
                                  // Continue searching in other sections
                                }
                              }

                              if (selectedLecture != null) {
                                log('Playing lecture: ${selectedLecture.title}, URL: ${selectedLecture.videoUrl}');
                              } else {
                                log('Lecture not found: $lectureId');
                                return;
                              }

                              // Initialize new video (YouTube or hosted)
                              _initializeVideo(selectedLecture.videoUrl);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
