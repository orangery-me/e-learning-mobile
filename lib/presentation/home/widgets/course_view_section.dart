import 'package:e_learning_mobile/common/extensions/context_extension.dart';
import 'package:e_learning_mobile/data/dtos/courses/course_response_dto.dart';
import 'package:e_learning_mobile/presentation/home/widgets/course_card.dart';
import 'package:flutter/material.dart';

class CourseViewSection extends StatelessWidget {
  final String sectionTitle;
  final List<CourseResponseDto> courses;

  const CourseViewSection({
    super.key,
    required this.sectionTitle,
    required this.courses,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(sectionTitle, style: context.textStyles.heading2),
            Text(
              'See all',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF5B7FFF),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Horizontal Course List
        SizedBox(
          height: 350,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: courses.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final course = courses[index];
              return CourseCard(
                courseId: course.courseId,
                title: course.title,
                instructor: course.instructorId,
                price: course.price,
                imageUrl: course.image,
                level: course.level,
              );
            },
          ),
        ),
      ],
    );
  }
}
