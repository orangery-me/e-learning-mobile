import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_learning_mobile/common/extensions/context_extension.dart';
import 'package:e_learning_mobile/presentation/roadmap/bloc/roadmap_bloc.dart';
import 'package:e_learning_mobile/presentation/widgets/common_rounded_button.dart';
import 'package:e_learning_mobile/presentation/roadmap/widgets/roadmap_section_card.dart';

class RoadmapResultView extends StatelessWidget {
  const RoadmapResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoadmapBloc, RoadmapState>(
      builder: (context, state) {
        final roadmap = state.roadmap;
        if (roadmap == null) {
          return Scaffold(
            body: Center(
              child: Column(
                children: [
                  CircularProgressIndicator(
                      color: context.palette.primaryColor),
                  SizedBox(height: 16),
                  Text('Generating your roadmap...',
                      style: context.textStyles.heading4
                          .copyWith(color: context.palette.primaryColor)),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                context.read<RoadmapBloc>().add(const ResetRoadmap());
              },
            ),
            title: Text(
              'Lộ trình học tập',
              style: context.textStyles.heading1.copyWith(
                color: context.palette.normalText,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        context.palette.primaryColor,
                        context.palette.primaryColor.withValues(alpha: 0.8),
                        context.palette.primaryColor.withValues(alpha: 0.6),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color:
                            context.palette.primaryColor.withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.rocket_launch,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Target Role',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  roadmap.role,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.flag,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Career Goal',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color:
                                          Colors.white.withValues(alpha: 0.8),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    roadmap.goal,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
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

                const SizedBox(height: 24),

                // SECTIONS
                ...roadmap.sections.asMap().entries.map((entry) {
                  return RoadmapSectionCard(
                    section: entry.value,
                    index: entry.key + 1,
                  );
                }),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: CommonRoundedButton(
                      onPressed: () {
                        context.read<RoadmapBloc>().add(const ResetRoadmap());
                      },
                      content: 'Regenerate',
                      backgroundColor: Colors.grey[600]!,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: BlocListener<RoadmapBloc, RoadmapState>(
                      listenWhen: (previous, current) =>
                          previous.isSaving != current.isSaving ||
                          previous.isSaved != current.isSaved,
                      listener: (context, state) {
                        if (state.isSaved && !state.isSaving) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  const Text('Roadmap saved successfully!'),
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        } else if (state.errorMessage != null &&
                            !state.isSaving) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Failed to save: ${state.errorMessage}'),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                      child: BlocBuilder<RoadmapBloc, RoadmapState>(
                        builder: (context, state) {
                          return CommonRoundedButton(
                            onPressed: () {
                              if (!state.isSaving && !state.isSaved) {
                                context.read<RoadmapBloc>().add(
                                      const SaveRoadmap(),
                                    );
                              }
                            },
                            content: state.isSaving
                                ? 'Saving...'
                                : (state.isSaved ? 'Saved' : 'Save Roadmap'),
                            backgroundColor: context.palette.buttonBackground,
                            isLoading: state.isSaving,
                            isDisable: state.isSaving || state.isSaved,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
