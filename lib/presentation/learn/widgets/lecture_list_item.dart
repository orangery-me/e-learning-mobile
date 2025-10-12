import 'package:e_learning_mobile/data/dtos/lectures/lecture_response_dto.dart';
import 'package:flutter/material.dart';

class LectureListItem extends StatelessWidget {
  final LectureResponseDto lecture;
  final bool isSelected;
  final VoidCallback onTap;

  const LectureListItem({
    super.key,
    required this.lecture,
    required this.isSelected,
    required this.onTap,
  });

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes;
    final remainingSeconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.withOpacity(0.1) : null,
        borderRadius: BorderRadius.circular(8),
        border: isSelected ? Border.all(color: Colors.blue) : null,
      ),
      child: ListTile(
        leading: Icon(
          Icons.play_circle_outline,
          color: isSelected ? Colors.blue : Colors.grey[600],
        ),
        title: Text(
          lecture.title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? Colors.blue : null,
          ),
        ),
        subtitle: Text(
          _formatDuration(lecture.duration),
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        trailing: Icon(
          Icons.more_vert,
          color: Colors.grey[400],
        ),
        onTap: onTap,
      ),
    );
  }
}
