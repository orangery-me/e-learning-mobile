import 'dart:developer';

import 'package:e_learning_mobile/common/theme/palette.dart';
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

// class _VideoPlayViewState extends State<VideoPlayView> {
//   late VideoPlayerController _controller;
//   late bool isLoading;
//   final Map<String, bool> _expandedSections = {};
//   String? _selectedLectureId;

//   @override
//   void initState() {
//     isLoading = true;
//     _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
//       ..initialize().then((_) {
//         setState(() {
//           isLoading = false;
//         });
//       });

//     // Load sections and lectures when the view is initialized
//     context.read<SectionsBloc>().add(LoadSectionsByCourseId(widget.courseId));
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Course Learning'),
//         backgroundColor: Palette.light().buttonBackground,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Column(
//         children: [
//           // Video Player Section
//           Container(
//             height: 250,
//             width: double.infinity,
//             color: Colors.black,
//             child: _controller.value.isInitialized && !isLoading
//                 ? AspectRatio(
//                     aspectRatio: _controller.value.aspectRatio,
//                     child: VideoPlayer(_controller),
//                   )
//                 : const Center(child: CircularProgressIndicator()),
//           ),

//           // Play/Pause Button
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: FloatingActionButton(
//               onPressed: () {
//                 setState(() {
//                   _controller.value.isPlaying
//                       ? _controller.pause()
//                       : _controller.play();
//                 });
//               },
//               child: Icon(
//                 _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//               ),
//             ),
//           ),

//           // Sections and Lectures List
//           Expanded(
//             child: BlocBuilder<SectionsBloc, SectionsState>(
//               builder: (context, sectionsState) {
//                 return BlocBuilder<LecturesBloc, LecturesState>(
//                   builder: (context, lecturesState) {
//                     if (sectionsState.isLoading) {
//                       return const Center(child: CircularProgressIndicator());
//                     }

//                     if (sectionsState.errorMessage != null) {
//                       return Center(
//                         child: Text('Error: ${sectionsState.errorMessage}'),
//                       );
//                     }

//                     return ListView.builder(
//                       itemCount: sectionsState.sections.length,
//                       itemBuilder: (context, index) {
//                         final section = sectionsState.sections[index];
//                         final isExpanded =
//                             _expandedSections[section.sectionId] ?? false;

//                         // Filter lectures for this section
//                         final sectionLectures = lecturesState.lectures
//                             .where((lecture) =>
//                                 lecture.sectionId == section.sectionId)
//                             .toList();

//                         return SectionListItem(
//                           section: section,
//                           isExpanded: isExpanded,
//                           lectures: sectionLectures,
//                           selectedLectureId: _selectedLectureId,
//                           onTap: () {
//                             // Load lectures for this section
//                             context.read<LecturesBloc>().add(
//                                   LoadLecturesBySectionId(section.sectionId),
//                                 );
//                           },
//                           onToggleExpanded: () {
//                             setState(() {
//                               _expandedSections[section.sectionId] =
//                                   !isExpanded;
//                             });

//                             // Load lectures when expanding
//                             if (!isExpanded) {
//                               context.read<LecturesBloc>().add(
//                                     LoadLecturesBySectionId(section.sectionId),
//                                   );
//                             }
//                           },
//                           onLectureTap: (lectureId) {
//                             setState(() {
//                               _selectedLectureId = lectureId;
//                             });

//                             log('Selected lecture ID: $lectureId');

//                             // Find the selected lecture and play its video
//                             final selectedLecture = lecturesState.lectures
//                                 .firstWhere((lecture) =>
//                                     lecture.lectureId == lectureId);

//                             log('Playing lecture: ${selectedLecture.title}, URL: ${selectedLecture.videoUrl}');

//                             // Update video player with new video URL
//                             _controller.dispose();
//                             _controller = VideoPlayerController.networkUrl(
//                               Uri.parse(selectedLecture.videoUrl),
//                             )..initialize().then((_) {
//                                 setState(() {});
//                               });
//                           },
//                         );
//                       },
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

enum VideoType { youtube, hosted }

class _VideoPlayViewState extends State<VideoPlayView> {
  YoutubePlayerController? _youtubeController;
  VideoPlayerController? _videoController;

  VideoType _currentVideoType = VideoType.hosted;
  bool isLoading = true;
  final Map<String, bool> _expandedSections = {};
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
    super.dispose();
  }

  bool _isYoutubeUrl(String url) {
    return url.contains('youtube.com') ||
        url.contains('youtu.be') ||
        url.contains('youtube-nocookie.com');
  }

  void _initializeVideo(String videoUrl) {
    setState(() {
      isLoading = true;
    });

    // Dispose previous controllers
    _youtubeController?.dispose();
    _videoController?.dispose();
    _youtubeController = null;
    _videoController = null;

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
          // Play/Pause button for hosted videos
          if (_videoController!.value.isInitialized)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        _videoController!.value.isPlaying
                            ? _videoController!.pause()
                            : _videoController!.play();
                      });
                    },
                    child: Icon(
                      _videoController!.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                  ),
                ],
              ),
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
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.errorMessage != null) {
                  return Center(
                    child: Text('Error: ${state.errorMessage}'),
                  );
                }

                return ListView.builder(
                  itemCount: state.sections.length,
                  itemBuilder: (context, index) {
                    final section = state.sections[index];
                    final isExpanded =
                        _expandedSections[section.sectionId] ?? false;

                    // Filter lectures for this section from the loaded lectures
                    final sectionLectures = state.lectures
                        .where(
                            (lecture) => lecture.sectionId == section.sectionId)
                        .toList();

                    return SectionListItem(
                      section: section,
                      isExpanded: isExpanded,
                      lectures: sectionLectures,
                      selectedLectureId: _selectedLectureId,
                      onTap: () {
                        // No need to load lectures anymore, they are already loaded
                      },
                      onToggleExpanded: () {
                        setState(() {
                          _expandedSections[section.sectionId] = !isExpanded;
                        });
                        // No need to load lectures anymore
                      },
                      onLectureTap: (lectureId) {
                        setState(() {
                          _selectedLectureId = lectureId;
                        });

                        log('Selected lecture ID: $lectureId');

                        // Find the selected lecture and play its video
                        final selectedLecture = state.lectures.firstWhere(
                            (lecture) => lecture.lectureId == lectureId);

                        log('Playing lecture: ${selectedLecture.title}, URL: ${selectedLecture.videoUrl}');

                        // Initialize new video (YouTube or hosted)
                        _initializeVideo(selectedLecture.videoUrl);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
