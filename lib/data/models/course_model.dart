class CourseModel {
  final String courseId;
  final String title;
  final String slug;
  final String description;
  final int price;
  final String level;
  final String instructorId;
  final String instructorName;
  final String category;
  final String thumbnailUrl;

  CourseModel({
    required this.courseId,
    required this.title,
    required this.slug,
    required this.description,
    required this.price,
    required this.level,
    required this.instructorId,
    required this.instructorName,
    required this.category,
    required this.thumbnailUrl,
  });
}
