import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:e_learning_mobile/common/theme/palette.dart';
import 'package:e_learning_mobile/data/dtos/lectures/lecture_response_dto.dart';
import 'package:e_learning_mobile/di/di.dart';
import 'package:e_learning_mobile/presentation/learn/bloc/sections/sections_bloc.dart';
import 'package:e_learning_mobile/presentation/learn/view/other_feature_view.dart';
import 'package:e_learning_mobile/presentation/learn/view/section_list_view.dart';
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
  bool _isDisposed = false;
  LectureResponseDto? _selectedLecture;

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

  void _initializeVideo(String? videoUrl) {
    if (_isDisposed) return;

    setState(() {
      isLoading = true;
    });

    // Dispose previous controllers
    _chewieController?.dispose();
    _youtubeController?.dispose();
    _videoController?.dispose();
    _chewieController = null;
    _youtubeController = null;
    _videoController = null;

    if (videoUrl == null || videoUrl.isEmpty) {
      if (!_isDisposed) {
        setState(() {
          isLoading = false;
        });
      }
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
        if (!_isDisposed) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } else {
      // Initialize regular video player
      _currentVideoType = VideoType.hosted;
      _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
        ..initialize().then((_) {
          if (!_isDisposed) {
            _chewieController = ChewieController(
              videoPlayerController: _videoController!,
              autoPlay: false,
              looping: false,
            );
            setState(() {
              isLoading = false;
            });
          }
        }).catchError((error) {
          log('Error initializing video: $error');
          if (!_isDisposed) {
            setState(() {
              isLoading = false;
            });
          }
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
        _videoController != null &&
        _videoController!.value.isInitialized) {
      return Container(
        height: 250,
        width: double.infinity,
        color: Colors.black,
        child: AspectRatio(
          aspectRatio: _videoController!.value.aspectRatio,
          child: VideoPlayer(_videoController!),
        ),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Learning',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
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
    );
  }
}
