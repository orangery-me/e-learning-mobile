import 'package:e_learning_mobile/data/models/category.dart';
import 'package:e_learning_mobile/di/di.dart';
import 'package:e_learning_mobile/presentation/auth/bloc/auth/auth_bloc.dart';
import 'package:e_learning_mobile/presentation/home/bloc/home_bloc.dart';
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
      BlocProvider(create: (_) => getIt<HomeBloc>()),
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
    context.read<CoursesBloc>().add(const LoadCourses(
        page: 1, size: 5, sortBy: 'created_at', order: 'desc'));

    // load categories for random selection
    context.read<HomeBloc>().add(const LoadRandomCategoryCourses(count: 3));

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

          const ContinueLearningCard(
            title: 'How to get started',
            subtitle: 'You can start from where you left',
            progress: 0.6,
          ),
          const SizedBox(height: 20),

          // Recently released courses section
          _lastestCourse(),

          const SizedBox(height: 20),

          // Category-based courses sections,
          _categoryBasedCourseSection(),

          const SizedBox(height: 20),

          // Vertical layout demo
          _verticalCourseSection(),
        ])));
  }

  Widget _lastestCourse() {
    return BlocBuilder<CoursesBloc, CoursesState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.errorMessage != null) {
          return Center(child: Text('Error: ${state.errorMessage}'));
        } else if (state.courses.isEmpty) {
          return const Center(child: Text('No courses available'));
        } else {
          return CourseViewSection(
            sectionTitle: "Recently Released Courses",
            subtitle: "Discover the latest courses from top instructors",
            courses: state.courses,
            cardHeight: 450,
            showCategory: true,
          );
        }
      },
    );
  }

  Widget _categoryBasedCourseSection() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, homeState) {
        if (homeState.isLoading ||
            homeState.errorMessage != null ||
            homeState.randomCategories.isEmpty) {
          return const SizedBox();
        } else {
          return Column(
            children: homeState.randomCategories.map((category) {
              String categoryName =
                  Category.fromDbValue(category)?.displayName ?? 'Unknown';

              final sectionTitles = [
                "Top Courses in $categoryName",
                "Popular $categoryName Courses",
                "Best $categoryName Learning",
                "Featured $categoryName Programs",
                "Trending $categoryName Courses",
              ];
              final randomTitle =
                  sectionTitles[category.hashCode % sectionTitles.length];

              return Column(
                children: [
                  const SizedBox(height: 20),
                  BlocBuilder<CoursesBloc, CoursesState>(
                    builder: (context, coursesState) {
                      final categoryCourses =
                          coursesState.getCoursesForCategory(category);

                      if (categoryCourses == null) {
                        // Load courses for this category using filter
                        context.read<CoursesBloc>().add(
                              LoadCourses(
                                page: 1,
                                size: 5,
                                sortBy: 'price',
                                order: 'desc',
                                filter: "category in ('$category')",
                              ),
                            );
                      }

                      if (categoryCourses != null &&
                          categoryCourses.isNotEmpty) {
                        return CourseViewSection(
                          sectionTitle: randomTitle,
                          subtitle: "Top-rated courses in $category",
                          courses: categoryCourses,
                          cardHeight: 420,
                          showCategory: true,
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                ],
              );
            }).toList(),
          );
        }
      },
    );
  }

  Widget _verticalCourseSection() {
    return BlocBuilder<CoursesBloc, CoursesState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.errorMessage != null) {
          return Center(child: Text('Error: ${state.errorMessage}'));
        } else if (state.courses.isEmpty) {
          return const SizedBox();
        } else {
          // Lấy 3 courses đầu tiên cho vertical layout
          final verticalCourses = state.courses.take(3).toList();
          return CourseViewSection(
            sectionTitle: "Quick Learning Path",
            subtitle: "Start your journey with these popular courses",
            courses: verticalCourses,
            cardHeight: 420,
            showCategory: true,
          );
        }
      },
    );
  }
}
