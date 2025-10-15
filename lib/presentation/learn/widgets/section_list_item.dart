import 'package:e_learning_mobile/common/extensions/context_extension.dart';
import 'package:e_learning_mobile/data/dtos/sections/section_response_dto.dart';
import 'package:e_learning_mobile/data/dtos/lectures/lecture_response_dto.dart';
import 'package:e_learning_mobile/presentation/learn/widgets/lecture_list_item.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:flutter/material.dart';

class SectionListItem extends StatelessWidget {
  final SectionResponseDto section;
  final bool isExpanded;
  final bool isLoading;
  final VoidCallback onTap;
  final VoidCallback onToggleExpanded;
  final List<LectureResponseDto> lectures;
  final String? selectedLectureId;
  final Function(String lectureId) onLectureTap;

  const SectionListItem({
    super.key,
    required this.section,
    required this.isExpanded,
    required this.isLoading,
    required this.onTap,
    required this.onToggleExpanded,
    required this.lectures,
    required this.selectedLectureId,
    required this.onLectureTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      // margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        title: Text(section.title,
            style:
                context.textStyles.body1.copyWith(fontWeight: FontWeight.w600)),
        subtitle: Text(
          'Position: ${section.position}',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        trailing: isLoading
            ? SimpleCircularProgressBar(
                size: 21,
                progressStrokeWidth: 3,
                backStrokeWidth: 3,
                progressColors: const [Colors.cyan, Colors.purple],
                backColor: Colors.black.withOpacity(0.4),
              )
            : Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
        onExpansionChanged: (expanded) => onToggleExpanded(),
        children: lectures
            .map((lecture) => LectureListItem(
                  lecture: lecture,
                  isSelected: selectedLectureId == lecture.lectureId,
                  onTap: () => onLectureTap(lecture.lectureId),
                ))
            .toList(),
      ),
    );
  }
}
