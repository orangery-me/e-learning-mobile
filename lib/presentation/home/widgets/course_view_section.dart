import 'package:e_learning_mobile/common/extensions/context_extension.dart';
import 'package:e_learning_mobile/data/dtos/courses/course_with_instructor_info_response_dto.dart';
import 'package:e_learning_mobile/presentation/home/widgets/course_card.dart';
import 'package:flutter/material.dart';

class CourseViewSection extends StatelessWidget {
  final String sectionTitle;
  final Color? sectionTitleColor;
  final Color? backgroundColor;
  final List<CourseWithInstructorInfoResponseDto> courses;
  final bool showSeeAll;
  final VoidCallback? onSeeAllTap;
  final String? subtitle;
  final Color? subtitleColor;
  final Widget? customHeader;
  final double cardHeight;
  final EdgeInsetsGeometry? padding;
  final bool showCategory;

  const CourseViewSection({
    super.key,
    required this.sectionTitle,
    required this.courses,
    this.sectionTitleColor = Colors.black,
    this.backgroundColor = Colors.white,
    this.subtitleColor = Colors.grey,
    this.showSeeAll = true,
    this.onSeeAllTap,
    this.subtitle,
    this.customHeader,
    this.cardHeight = 380,
    this.padding,
    this.showCategory = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(context),
          const SizedBox(height: 20),

          // Course List
          _buildCourseList(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    if (customHeader != null) {
      return customHeader!;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sectionTitle,
                    style: context.textStyles.heading4
                        .copyWith(color: sectionTitleColor),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(subtitle!,
                        style: context.textStyles.body2
                            .copyWith(color: subtitleColor, fontSize: 12)),
                  ],
                ],
              ),
            ),
            if (showSeeAll)
              GestureDetector(
                onTap: onSeeAllTap,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: context.palette.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'See all',
                    style: context.textStyles.buttonLabel.copyWith(
                      fontSize: 14,
                      color: context.palette.primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildCourseList(BuildContext context) {
    if (courses.isEmpty) {
      return SizedBox(
        height: cardHeight,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.school_outlined,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 12),
              Text(
                'No courses available',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Horizontal layout
    return SizedBox(
      height: cardHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: courses.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final course = courses[index];
          return _buildCourseCard(course);
        },
      ),
    );
  }

  Widget _buildCourseCard(CourseWithInstructorInfoResponseDto course) {
    return CourseCard(
      course: course,
      showCategory: showCategory,
    );
  }
}
