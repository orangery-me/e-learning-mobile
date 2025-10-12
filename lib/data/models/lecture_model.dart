import 'package:e_learning_mobile/data/models/section_model.dart';

class LectureModel {
  final String lectureId;
  final SectionModel section;
  final String title;
  final String content;
  final int position;
  final String videoUrl;
  final int duration; // duration in seconds
  final DateTime createdAt;
  final DateTime updatedAt;

  LectureModel({
    required this.lectureId,
    required this.section,
    required this.title,
    required this.content,
    required this.position,
    required this.videoUrl,
    required this.duration,
    required this.createdAt,
    required this.updatedAt,
  });
}
