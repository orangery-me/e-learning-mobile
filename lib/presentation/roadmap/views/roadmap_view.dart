import 'package:e_learning_mobile/common/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_learning_mobile/di/di.dart';
import 'package:e_learning_mobile/presentation/roadmap/bloc/roadmap_bloc.dart';
import 'package:e_learning_mobile/presentation/roadmap/views/survey_view.dart';
import 'package:e_learning_mobile/presentation/roadmap/views/roadmap_result_view.dart';

class RoadmapPage extends StatelessWidget {
  const RoadmapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = getIt<RoadmapBloc>();
        // Load existing roadmap when page is opened
        bloc.add(const LoadExistingRoadmap());
        return bloc;
      },
      child: BlocBuilder<RoadmapBloc, RoadmapState>(
        builder: (context, state) {
          // Show loading when submitting survey
          if (state.isLoading) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          // Show error if any
          if (state.errorMessage != null) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Có lỗi xảy ra',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: context.palette.normalText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        state.errorMessage!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context.read<RoadmapBloc>().add(const ResetRoadmap());
                      },
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Show result if roadmap is available
          if (state.roadmap != null) {
            return const RoadmapResultView();
          }

          // Show survey by default
          return const SurveyView();
        },
      ),
    );
  }
}
