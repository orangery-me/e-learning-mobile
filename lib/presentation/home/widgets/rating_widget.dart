import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final double size;
  final bool showReviewCount;

  const RatingWidget({
    super.key,
    required this.rating,
    this.reviewCount = 0,
    this.size = 14.0,
    this.showReviewCount = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Star rating
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            final starRating = index + 1;
            final isFilled = starRating <= rating.floor();
            final isHalfFilled = starRating == rating.ceil() && rating % 1 != 0;

            return Container(
              margin: const EdgeInsets.only(right: 2),
              child: Icon(
                isHalfFilled
                    ? Icons.star_half_rounded
                    : isFilled
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                size: size,
                color: const Color(0xFFFFB74D),
              ),
            );
          }),
        ),
        const SizedBox(width: 4),
        // Rating number
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: size - 2,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        // Review count
        if (showReviewCount && reviewCount > 0) ...[
          const SizedBox(width: 4),
          Text(
            '($reviewCount)',
            style: TextStyle(
              fontSize: size - 4,
              color: Colors.grey[500],
            ),
          ),
        ],
      ],
    );
  }
}

class StudentCountWidget extends StatelessWidget {
  final int studentCount;
  final double size;

  const StudentCountWidget({
    super.key,
    required this.studentCount,
    this.size = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.people_rounded,
          size: size,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Text(
          _formatStudentCount(studentCount),
          style: TextStyle(
            fontSize: size,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatStudentCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}

class DurationWidget extends StatelessWidget {
  final int durationInMinutes;
  final double size;

  const DurationWidget({
    super.key,
    required this.durationInMinutes,
    this.size = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    final hours = durationInMinutes ~/ 60;
    final minutes = durationInMinutes % 60;

    String durationText;
    if (hours > 0 && minutes > 0) {
      durationText = '${hours}h ${minutes}m';
    } else if (hours > 0) {
      durationText = '${hours}h';
    } else {
      durationText = '${minutes}m';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.access_time_rounded,
          size: size,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Text(
          durationText,
          style: TextStyle(
            fontSize: size,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
