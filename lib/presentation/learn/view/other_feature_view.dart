import 'package:e_learning_mobile/data/dtos/lectures/lecture_response_dto.dart';
import 'package:e_learning_mobile/presentation/learn/bloc/video_play/video_play_bloc.dart';
import 'package:e_learning_mobile/presentation/learn/view/events/events_list_modal.dart';
import 'package:e_learning_mobile/presentation/learn/view/reviews/review_modal.dart';
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
    return OtherFeatureView(
      courseId: courseId,
      selectedLecture: selectedLecture,
      videoController: videoController,
      youtubeController: youtubeController,
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
          // image icon
          leading: Image.asset(
            'assets/icons/post-it.png',
            width: 24,
            height: 24,
          ),
          onTap: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                elevation: 10,
                builder: (_) {
                  return NoteModalView(
                    videoController: widget.videoController,
                    youtubeController: widget.youtubeController,
                    selectedLecture: widget.selectedLecture,
                  );
                });
          },
        ),
        ListTile(
          title: Text('Events'),
          leading: Image.asset(
            'assets/icons/events.png',
            width: 24,
            height: 24,
          ),
          onTap: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (_) {
                  return BlocProvider.value(
                      value: context.read<VideoPlayBloc>(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.9,
                        child: EventsListModal(),
                      ));
                });
          },
        ),
        ListTile(
          title: Text('Exercises'),
          leading: Image.asset(
            'assets/icons/terminal.png',
            width: 24,
            height: 24,
          ),
          onTap: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (_) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.9,
                    child: const EventsListModal(),
                  );
                });
          },
        ),
        ListTile(
          title: Text('Comments & Ratings'),
          leading: Image.asset(
            'assets/icons/star.png',
            width: 24,
            height: 24,
          ),
          onTap: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (_) {
                  return ReviewModalPage(courseId: widget.courseId);
                });
          },
        )
      ],
    );
  }
}
