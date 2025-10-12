import 'package:e_learning_mobile/common/extensions/context_extension.dart';
import 'package:e_learning_mobile/common/theme/palette.dart';
import 'package:e_learning_mobile/common/utils/format_util.dart';
import 'package:e_learning_mobile/presentation/learn/view/video_play_view.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final String courseId;
  final String title;
  final String instructor;
  final int filesCount;
  final int duration;
  final double price;
  final String level;
  final String imageUrl;
  // final String videoUrl;

  const CourseCard({
    super.key,
    required this.courseId,
    required this.title,
    required this.instructor,
    required this.price,
    this.level = 'Beginner',
    this.filesCount = 3,
    this.duration = 15,
    required this.imageUrl
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail with play button
          Stack(
            children: [
              // Thumbnail Image
              Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.15),
                      BlendMode.color,
                    ),
                  ),
                ),
                // Play Button
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
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return VieoPlayPage(
                              videoUrl:
                                  'https://dinhlooc-test-2025.s3.us-east-1.amazonaws.com/video-30012ca2-77fb-4635-be60-77f481933d63-1758467257284.mp4',
                              courseId: courseId,
                            );
                          }));
                        },
                        icon: const Icon(
                          Icons.play_arrow_rounded,
                          size: 36,
                          color: Color(0xFF5B7FFF),
                        ),
                      )),
                ),
              ),
              // Dots indicator (top right)
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(instructor,
                    style: context.textStyles.body1
                        .copyWith(color: Colors.grey[700])),
                const SizedBox(height: 8),

                // price
                Row(
                  children: [
                    // level tag
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        level,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF1976D2),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(FormatUtil.formatNumberAsCurrency(price, symbol: '₫'),
                        style: context.textStyles.subHeading1.copyWith(
                            color: Palette.light().normalText,
                            fontWeight: FontWeight.bold)),
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
