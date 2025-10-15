import 'dart:developer';

import 'package:e_learning_mobile/data/dtos/lectures/lecture_response_dto.dart';
import 'package:e_learning_mobile/presentation/learn/bloc/sections/sections_bloc.dart';
import 'package:e_learning_mobile/presentation/learn/widgets/section_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SectionListView extends StatefulWidget {
  final Function(LectureResponseDto lecture) onLectureSelected;
  const SectionListView({super.key, required this.onLectureSelected});

  @override
  State<SectionListView> createState() => _SectionListViewState();
}

class _SectionListViewState extends State<SectionListView> {
  final Map<String, bool> _expandedSections = {};
  String? _selectedLectureId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SectionsBloc, SectionsState>(
      builder: (context, state) {
        if (state.errorMessage != null) {
          return Center(
            child: Text('Error: ${state.errorMessage}'),
          );
        }

        return ListView.builder(
          itemCount: state.sections.length,
          itemBuilder: (context, index) {
            final section = state.sections[index];
            final isExpanded = _expandedSections[section.sectionId] ?? false;

            // Get lectures for this section from cache
            final sectionLectures =
                state.getLecturesForSection(section.sectionId);
            // trạng thái loading của section đang được xét
            final isLoadingSection = state.isSectionLoading(section.sectionId);

            return SectionListItem(
              section: section,
              isExpanded: isExpanded,
              lectures: sectionLectures,
              isLoading: isLoadingSection,
              selectedLectureId: _selectedLectureId,
              onTap: () {
                // Load lectures for this section when tapped
                if (sectionLectures.isEmpty && !isLoadingSection) {
                  context.read<SectionsBloc>().add(
                        LoadLecturesBySectionId(section.sectionId),
                      );
                }
              },
              onToggleExpanded: () {
                setState(() {
                  _expandedSections[section.sectionId] = !isExpanded;
                });

                // Load lectures when expanding if not already loaded
                if (!isExpanded &&
                    sectionLectures.isEmpty &&
                    !isLoadingSection) {
                  context.read<SectionsBloc>().add(
                        LoadLecturesBySectionId(section.sectionId),
                      );
                }
              },
              onLectureTap: (lectureId) {
                setState(() {
                  _selectedLectureId = lectureId;
                });

                log('Selected lecture ID: $lectureId');

                // Find the selected lecture from cached lectures and play its video
                LectureResponseDto? selectedLecture;
                for (final lectures in state.lecturesCache.values) {
                  try {
                    selectedLecture = lectures.firstWhere(
                        (lecture) => lecture.lectureId == lectureId);
                    break;
                  } catch (e) {
                    // Continue searching in other sections
                  }
                }

                if (selectedLecture != null) {
                  widget.onLectureSelected(selectedLecture);
                } else {
                  log('Lecture not found: $lectureId');
                  return;
                }
              },
            );
          },
        );
      },
    );
  }
}
