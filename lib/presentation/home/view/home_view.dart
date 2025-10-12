import 'dart:developer';
import 'package:e_learning_mobile/di/di.dart';
import 'package:e_learning_mobile/presentation/auth/bloc/auth/auth_bloc.dart';
import 'package:e_learning_mobile/presentation/home/bloc/home_bloc.dart';
import 'package:e_learning_mobile/presentation/home/widgets/category_card.dart';
import 'package:e_learning_mobile/presentation/home/widgets/continue_learning.dart';
import 'package:e_learning_mobile/presentation/home/widgets/course_view_section.dart';
import 'package:e_learning_mobile/presentation/home/widgets/search_section.dart';
import 'package:e_learning_mobile/presentation/home/widgets/user_header.dart';
import 'package:e_learning_mobile/presentation/learn/bloc/courses/courses_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (_) => getIt<CoursesBloc>()),
      BlocProvider(create: (_) => HomeBloc()),
    ], child: const HomeView());
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    // load courses
    context.read<CoursesBloc>().add(const LoadCourses(page: 1, size: 10));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthBloc>().state.user;
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // profile widget
          UserHeader(
              name: '${user?.firstName} ${user?.lastName}',
              avatarUrl: 'assets/images/banners/avatar.png'),
          const SizedBox(height: 20),

          // search section
          SearchSection(),

          const SizedBox(height: 20),

          // Category Cards
          SizedBox(
            height: 180,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                CategoryCard(
                  title: 'Basic English\nfor Class XIII',
                  lessons: '28 Lessons',
                  color: Color(0xFFADD8E6),
                  icon: Icons.language,
                ),
                SizedBox(width: 16),
                CategoryCard(
                  title: 'General\nKnowle',
                  lessons: '28 Lessons',
                  color: Color(0xFFD8BFD8),
                  icon: Icons.psychology,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const ContinueLearningCard(
            title: 'How to get started',
            subtitle: 'You can start from where you left',
            progress: 0.6,
          ),
          const SizedBox(height: 20),

          // courses section
          BlocBuilder<CoursesBloc, CoursesState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.errorMessage != null) {
                return Center(child: Text('Error: ${state.errorMessage}'));
              } else if (state.courses.isEmpty) {
                return const Center(child: Text('No courses available'));
              } else {
                return CourseViewSection(
                  sectionTitle: "Popular Courses",
                  courses: state.courses,
                );
              }
            },
          ),

          // CourseViewSection(sectionTitle: "Most Popular Certificates"),

          // const SizedBox(height: 20),
          // CourseViewSection(sectionTitle: "Course for you"),
        ])));
  }
}
