import 'package:e_learning_mobile/common/extensions/context_extension.dart';
import 'package:e_learning_mobile/presentation/home/widgets/course_card.dart';
import 'package:flutter/material.dart';

class CourseViewSection extends StatelessWidget {
  final String sectionTitle;
  // final List<Widget> courseCards;

  const CourseViewSection({
    super.key,
    required this.sectionTitle,
    // required this.courseCards,
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
          height: 300,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              CourseCard(
                title: 'Biology for class XIII',
                instructor: 'By Smith J.',
                filesCount: 17,
                duration: 40,
                thumbnailColor: const Color(0xFFB8C5FF),
                imageUrl: 'https://via.placeholder.com/300x200',
              ),
              const SizedBox(width: 16),
              CourseCard(
                title: 'Math for class XIII',
                instructor: 'By Smith J.',
                filesCount: 17,
                duration: 40,
                thumbnailColor: const Color(0xFFFFD4B0),
                imageUrl: 'https://via.placeholder.com/300x200',
              ),
              const SizedBox(width: 16),
              CourseCard(
                title: 'Physics for class XIII',
                instructor: 'By Smith J.',
                filesCount: 17,
                duration: 40,
                thumbnailColor: const Color(0xFFB8FFD4),
                imageUrl: 'https://via.placeholder.com/300x200',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
