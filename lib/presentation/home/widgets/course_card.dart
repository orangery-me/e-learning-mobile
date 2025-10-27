// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:e_learning_mobile/common/extensions/context_extension.dart';
import 'package:e_learning_mobile/data/models/category.dart';
import 'package:e_learning_mobile/presentation/learn/view/video_play_view.dart';
import 'package:flutter/material.dart';

import 'package:e_learning_mobile/common/utils/format_util.dart';
import 'package:e_learning_mobile/data/dtos/courses/course_response_dto.dart';
import 'package:e_learning_mobile/presentation/home/widgets/rating_widget.dart';
import 'package:e_learning_mobile/presentation/learn/view/course_detail_view.dart';

class CourseCard extends StatelessWidget {
  final CourseResponseDto course;
  final bool showCategory;

  const CourseCard({
    super.key,
    required this.course,
    this.showCategory = true,
  });

  // Generate mock data based on courseId hash
  int get _mockDuration => 120 + (course.courseId.hashCode % 480);
  double get _mockRating => 4.2 + (course.courseId.hashCode % 100) / 100;
  int get _mockReviewCount => 50 + (course.courseId.hashCode % 200);
  int get _mockStudentCount => 100 + (course.courseId.hashCode % 5000);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260, // Featured style width
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FF), // Light blue background
        borderRadius: BorderRadius.circular(12), // Featured style border radius
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF8F9FF),
            Color(0xFFF0F2FF),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5B7FFF).withOpacity(0.15),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: const Color(0xFF5B7FFF).withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail with play button
          Stack(
            children: [
              // Thumbnail Image
              Container(
                height: 150, // Featured style image height
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(course.image),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () {
                        // go to video play screen
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) {
                        //   return VieoPlayPage(
                        //     videoUrl: '',
                        //     courseId: course.courseId,
                        //   );
                        // }));

                        // Navigate to course detail page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CourseDetailPage(
                              course: course,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.play_arrow_rounded,
                        size: 36,
                        color: Color(0xFF5B7FFF),
                      ),
                    ),
                  ),
                ),
              ),

              // Dots indicator
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildDot(const Color(0xFFFFB74D)),
                      const SizedBox(width: 3),
                      _buildDot(const Color(0xFFFFB74D)),
                      const SizedBox(width: 3),
                      _buildDot(const Color(0xFFFFB74D)),
                      const SizedBox(width: 6),
                      _buildDot(const Color(0xFF42A5F5)),
                      const SizedBox(width: 3),
                      _buildDot(const Color(0xFF42A5F5)),
                      const SizedBox(width: 3),
                      _buildDot(const Color(0xFF42A5F5)),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Course Info
          Padding(
            padding: const EdgeInsets.all(20), // Featured style padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category and Level
                if (showCategory)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        if (showCategory) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              Category.fromDbValue(course.category)!
                                  .displayName,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF4CAF50),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3F2FD),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            course.level,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF1976D2),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                if (showCategory) const SizedBox(height: 8),

                // Title
                Text(
                  course.title,
                  style: context.textStyles.heading4
                      .copyWith(fontWeight: FontWeight.w700),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 6),

                // Instructor
                Text('By ${course.instructorName}',
                    style: context.textStyles.body1),

                const SizedBox(height: 8),

                // Rating and Student Count
                Row(
                  children: [
                    RatingWidget(
                      rating: _mockRating,
                      reviewCount: _mockReviewCount,
                      size: 12,
                      showReviewCount:
                          true, // Featured style shows review count
                    ),
                    const SizedBox(width: 12),
                    StudentCountWidget(
                      studentCount: _mockStudentCount,
                      size: 12,
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Duration and Price
                Row(
                  children: [
                    DurationWidget(
                      durationInMinutes: _mockDuration,
                      size: 12,
                    ),
                    const Spacer(),
                    Text(
                      FormatUtil.formatNumberAsCurrency(course.price,
                          symbol: '₫'),
                      style: context.textStyles.heading4
                          .copyWith(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
