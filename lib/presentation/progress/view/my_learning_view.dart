import 'package:e_learning_mobile/di/di.dart';
import 'package:e_learning_mobile/presentation/auth/bloc/auth/auth_bloc.dart';
import 'package:e_learning_mobile/presentation/home/widgets/enrollment_view_section.dart';
import 'package:e_learning_mobile/presentation/learn/bloc/enrollment/enrollment_bloc.dart';
import 'package:e_learning_mobile/data/dtos/enrollment/enrollment_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyLearningPage extends StatelessWidget {
  const MyLearningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = getIt<EnrollmentBloc>();
        final user = context.read<AuthBloc>().state.user;
        if (user != null) {
          bloc.add(LoadEnrollmentsByUserId(user.id));
        }
        return bloc;
      },
      child: const MyLearningView(),
    );
  }
}

class MyLearningView extends StatelessWidget {
  const MyLearningView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Learning'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: BlocBuilder<EnrollmentBloc, EnrollmentState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 12),
                  Text(
                    'Failed to load enrollments',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.errorMessage!,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      final user = context.read<AuthBloc>().state.user;
                      if (user != null) {
                        context
                            .read<EnrollmentBloc>()
                            .add(LoadEnrollmentsByUserId(user.id));
                      }
                    },
                    child: const Text('Try again'),
                  ),
                ],
              ),
            );
          }

          if (state.enrollments.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school_outlined,
                      size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 12),
                  Text(
                    'No courses enrolled',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start learning by enrolling in a course',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          // Separate active and completed enrollments
          final activeEnrollments = state.enrollments
              .where((e) => e.status == EnrollmentStatus.active)
              .toList();
          final completedEnrollments = state.enrollments
              .where((e) => e.status == EnrollmentStatus.completed)
              .toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (activeEnrollments.isNotEmpty) ...[
                  const Text(
                    'Active Courses',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  EnrollmentViewSection(
                    sectionTitle: '',
                    enrollments: activeEnrollments,
                    isHorizontal: false,
                    showSeeAll: false,
                  ),
                  const SizedBox(height: 32),
                ],
                if (completedEnrollments.isNotEmpty) ...[
                  const Text(
                    'Completed Courses',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  EnrollmentViewSection(
                    sectionTitle: '',
                    enrollments: completedEnrollments,
                    isHorizontal: false,
                    showSeeAll: false,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
