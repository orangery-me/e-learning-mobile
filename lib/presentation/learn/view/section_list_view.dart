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
            final isExpanded = state.selectedSection
                .any((s) => s.sectionId == section.sectionId);

            // Get lectures for this section from cache
            final sectionLectures =
                state.getLecturesForSection(section.sectionId);

            // trạng thái loading của section đang được xét
            final isLoadingSection = state.isSectionLoading(section.sectionId);

            if (isExpanded && sectionLectures.isEmpty && !isLoadingSection) {
              context
                  .read<SectionsBloc>()
                  .add(LoadLecturesBySectionId(section.sectionId));
            }

            return SectionListItem(
              key: ValueKey(
                  '${section.sectionId}-$isExpanded-${sectionLectures.length}'),
              section: section,
              isExpanded: isExpanded,
              lectures: sectionLectures,
              isLoading: isLoadingSection,
              onTap: () {
                // Load lectures for this section when tapped
                if (sectionLectures.isEmpty && !isLoadingSection) {
                  context.read<SectionsBloc>().add(
                        LoadLecturesBySectionId(section.sectionId),
                      );
                }
              },
              onToggleExpanded: () {
                if (isExpanded) {
                  context
                      .read<SectionsBloc>()
                      .add(DeselectSection(section.sectionId));
                } else {
                  context
                      .read<SectionsBloc>()
                      .add(SelectSection(section.sectionId));
                }

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
                log('Selected lecture ID: $lectureId');

                // Find the selected lecture from cached lectures and play its video
                LectureResponseDto? selectedLecture = state
                        .lecturesCache.values.isNotEmpty
                    ? state.lecturesCache.values
                        .expand((lectures) => lectures)
                        .firstWhere((lecture) => lecture.lectureId == lectureId)
                    : null;

                if (selectedLecture != null) {
                  widget.onLectureSelected(selectedLecture);
                }
              },
            );
          },
        );
      },
    );
  }
}
