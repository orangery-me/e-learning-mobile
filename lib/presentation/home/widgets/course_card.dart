import 'package:e_learning_mobile/common/extensions/context_extension.dart';
import 'package:e_learning_mobile/presentation/learn/view/video_play_view.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final String instructor;
  final int filesCount;
  final int duration;
  final Color thumbnailColor;
  final String imageUrl;

  const CourseCard({
    super.key,
    required this.title,
    required this.instructor,
    required this.filesCount,
    required this.duration,
    required this.thumbnailColor,
    required this.imageUrl,
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
                  color: thumbnailColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      thumbnailColor.withOpacity(0.7),
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
                            return VideoPlayView(
                                videoUrl:
                                    'https://dinhlooc-test-2025.s3.us-east-1.amazonaws.com/video-30012ca2-77fb-4635-be60-77f481933d63-1758467257284.mp4');
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

                // Files and Duration Info
                Row(
                  children: [
                    Icon(
                      Icons.copy_outlined,
                      size: 18,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$filesCount Files',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Icon(
                      Icons.access_time_outlined,
                      size: 18,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$duration Mints',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
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
