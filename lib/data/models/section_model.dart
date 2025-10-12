import 'package:e_learning_mobile/data/models/course_model.dart';

class SectionModel {
  final String sectionId;
  final CourseModel course;
  final String title;
  final int position;
  final DateTime createdAt;
  final DateTime updatedAt;

  SectionModel({
    required this.sectionId,
    required this.course,
    required this.title,
    required this.position,
    required this.createdAt,
    required this.updatedAt,
  });
}
