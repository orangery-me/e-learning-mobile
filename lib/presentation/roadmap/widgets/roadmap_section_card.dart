import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_learning_mobile/presentation/roadmap/bloc/roadmap_bloc.dart';
import 'package:e_learning_mobile/data/dtos/roadmap/career_roadmap_response_dto.dart';
import 'package:e_learning_mobile/presentation/roadmap/widgets/roadmap_course_card.dart';

class RoadmapSectionCard extends StatefulWidget {
  final CareerRoadmapSectionDto section;
  final int index;

  const RoadmapSectionCard({
    super.key,
    required this.section,
    required this.index,
  });

  @override
  State<RoadmapSectionCard> createState() => _RoadmapSectionCardState();
}

class _RoadmapSectionCardState extends State<RoadmapSectionCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  // 6 basic colors for sections
  static final List<Color> _baseColors = [
    const Color(0xFF7C9ED9), // Blue
    const Color(0xFF6BC4A0), // Mint
    const Color(0xFFFFC085), // Peach
    const Color(0xFFFF9AA2), // Coral
    const Color(0xFFB89DD9), // Lavender
    const Color(0xFF7DD3D3), // Aqua
  ];

  Map<String, dynamic> get _colorScheme {
    final baseColor = _baseColors[widget.index % _baseColors.length];
    return {
      'primary': baseColor,
      'secondary': Color.lerp(baseColor, Colors.white, 0.3)!,
      'light': Color.lerp(baseColor, Colors.white, 0.85)!,
      'gradient': [baseColor, Color.lerp(baseColor, Colors.white, 0.2)!],
    };
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
        // Load courses when expanding for the first time
        final sectionKey = widget.index.toString();
        if (!context
            .read<RoadmapBloc>()
            .state
            .sectionCourses
            .containsKey(sectionKey)) {
          context.read<RoadmapBloc>().add(
                LoadSectionCourses(sectionKey, widget.section.courseIds),
              );
        }
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = _colorScheme;
    final primaryColor = colorScheme['primary'] as Color;
    final secondaryColor = colorScheme['secondary'] as Color;
    final lightColor = colorScheme['light'] as Color;
    final gradient = colorScheme['gradient'] as List<Color>;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.1),
            spreadRadius: 0,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _toggleExpand,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  lightColor.withValues(alpha: 0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: primaryColor.withValues(alpha: 0.15),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                // Header - Always visible
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      // Number badge with gradient
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: gradient,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '${widget.index}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Title - Reduced font size
                      Expanded(
                        child: Text(
                          widget.section.sectionTitle,
                          style: TextStyle(
                            fontSize: 16, // Reduced from 18
                            fontWeight: FontWeight.w600, // Reduced from bold
                            color: primaryColor,
                            height: 1.2,
                          ),
                        ),
                      ),
                      // Expand icon
                      AnimatedRotation(
                        turns: _isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: primaryColor,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
                // Expandable content
                SizeTransition(
                  sizeFactor: _expandAnimation,
                  axisAlignment: -1.0,
                  child: Column(
                    children: [
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: primaryColor.withValues(alpha: 0.2),
                        indent: 20,
                        endIndent: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Description
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: lightColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: primaryColor.withValues(alpha: 0.15),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: primaryColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      widget.section.description,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[800],
                                        height: 1.6,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Courses section
                            BlocBuilder<RoadmapBloc, RoadmapState>(
                              builder: (context, state) {
                                final sectionKey = widget.index.toString();
                                final isLoading =
                                    state.sectionLoadingStates[sectionKey] ??
                                        false;
                                final courses =
                                    state.sectionCourses[sectionKey] ?? [];
                                final error = state.sectionErrors[sectionKey];

                                if (isLoading) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 40),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }

                                if (error != null) {
                                  return Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.red[50],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.red[200]!,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.error_outline,
                                            color: Colors.red[700]),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            'Failed to load courses: $error',
                                            style: TextStyle(
                                              color: Colors.red[700],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                if (courses.isEmpty) {
                                  return Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: lightColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.info_outline,
                                            color: primaryColor),
                                        const SizedBox(width: 12),
                                        Text(
                                          'No courses available',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: gradient,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            '${courses.length} Courses',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    ...courses
                                        .map((course) => RoadmapCourseCard(
                                              course: course,
                                              primaryColor: primaryColor,
                                              secondaryColor: secondaryColor,
                                              gradient: gradient,
                                            )),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
