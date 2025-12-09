import 'package:e_learning_mobile/common/extensions/context_extension.dart';
import 'package:e_learning_mobile/common/utils/format_util.dart';
import 'package:e_learning_mobile/data/dtos/courses/course_response_dto.dart';
import 'package:e_learning_mobile/data/dtos/courses/course_with_instructor_info_response_dto.dart';
import 'package:e_learning_mobile/data/dtos/enrollment/enrollment_dto.dart';
import 'package:e_learning_mobile/presentation/home/view/course_detail_view.dart';
import 'package:e_learning_mobile/presentation/home/widgets/rating_widget.dart';
import 'package:e_learning_mobile/presentation/learn/bloc/enrollment/enrollment_bloc.dart';
import 'package:e_learning_mobile/presentation/learn/view/video_play_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompactCourseCard extends StatelessWidget {
  final CourseWithInstructorInfoResponseDto course;

  const CompactCourseCard({
    super.key,
    required this.course,
  });

  // Generate mock data based on courseId hash
  double get _mockRating => 4.2 + (course.courseId.hashCode % 100) / 100;
  int get _mockReviewCount => 50 + (course.courseId.hashCode % 200);

  @override
  Widget build(BuildContext context) {
    final EnrollmentDto? enrollment =
        context.select<EnrollmentBloc, EnrollmentDto?>((bloc) {
      for (final e in bloc.state.enrollments) {
        if (e.course.courseId == course.courseId) return e;
      }
      return null;
    });
    final bool isEnrolled = enrollment != null;

    return InkWell(
      onTap: () {
        if (isEnrolled) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPlayPage(
                enrollment: enrollment,
                course: CourseResponseDto(
                  courseId: course.courseId,
                  title: course.title,
                  slug: course.slug,
                  description: course.description,
                  price: course.price,
                  level: course.level,
                  instructorId: course.instructor.userId,
                  instructorName: course.instructor.name,
                  category: course.category,
                  image: course.image,
                ),
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseDetailPage(
                course: course,
              ),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                ),
                child: course.image != null
                    ? Image.network(
                        course.image!,
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.image, color: Colors.grey[400]),
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: context.textStyles.body1.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    course.instructor.name,
                    style: context.textStyles.metadata1.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      RatingWidget(
                        rating: _mockRating,
                        reviewCount: _mockReviewCount,
                        size: 10,
                        showReviewCount: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (isEnrolled)
                    Text(
                      'Enrolled',
                      style: context.textStyles.metadata1.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  else
                    Text(
                      FormatUtil.formatNumberAsCurrency(course.price,
                          symbol: '₫'),
                      style: context.textStyles.body2.copyWith(
                        color: context.palette.primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
