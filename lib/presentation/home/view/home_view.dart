import 'package:e_learning_mobile/data/models/category.dart';
import 'package:e_learning_mobile/di/di.dart';
import 'package:e_learning_mobile/presentation/auth/bloc/auth/auth_bloc.dart';
import 'package:e_learning_mobile/presentation/home/bloc/home/home_bloc.dart';
import 'package:e_learning_mobile/presentation/home/widgets/continue_learning.dart';
import 'package:e_learning_mobile/presentation/home/widgets/course_view_section.dart';
import 'package:e_learning_mobile/presentation/home/widgets/enrollment_view_section.dart';
import 'package:e_learning_mobile/presentation/home/widgets/search_section.dart';
import 'package:e_learning_mobile/presentation/home/widgets/user_header.dart';
import 'package:e_learning_mobile/presentation/core/bloc/root_bloc.dart';
import 'package:e_learning_mobile/presentation/learn/bloc/courses/courses_bloc.dart';
import 'package:e_learning_mobile/presentation/learn/bloc/enrollment/enrollment_bloc.dart';
import 'package:e_learning_mobile/data/dtos/enrollment/enrollment_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (_) => getIt<CoursesBloc>()),
      BlocProvider(create: (_) => getIt<HomeBloc>()),
      BlocProvider(create: (_) => getIt<EnrollmentBloc>()),
    ], child: const HomeView());
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final isLoading = ValueNotifier<bool>(false);

  @override
  void initState() {
    // load courses
    context.read<CoursesBloc>().add(const LoadCourses(
        page: 1, size: 5, sortBy: 'created_at', order: 'desc'));

    // load categories for random selection
    context.read<HomeBloc>().add(const LoadRandomCategoryCourses(count: 3));

    // load enrollments for current user
    final user = context.read<AuthBloc>().state.user;
    if (user != null) {
      context.read<EnrollmentBloc>().add(LoadEnrollmentsByUserId(user.id));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthBloc>().state.user;
    // Combine loading từ nhiều bloc
    final homeState = context.watch<HomeBloc>().state;
    final coursesState = context.watch<CoursesBloc>().state;
    final showPageLoading = homeState.isLoading ||
        (coursesState.isLoading && coursesState.courses.isEmpty);

    if (showPageLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 8, 12),
        child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // profile widget
          UserHeader(
              name: '${user?.firstName} ${user?.lastName}',
              avatarUrl: 'assets/images/banners/avatar.png'),
          const SizedBox(height: 24),

          // Motivational text
          const Text(
            'What do you want to learn today?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // search section
          SearchSection(),

          const SizedBox(height: 20),

          _exploreCategoriesSection(),

          const SizedBox(height: 20),

          // My Learning section
          _myLearningSection(),

          const SizedBox(height: 20),

          // Vertical layout demo
          _verticalCourseSection(),

          const SizedBox(height: 20),

          const ContinueLearningCard(
            title: 'How to get started',
            subtitle: 'You can start from where you left',
            progress: 0.6,
          ),

          const SizedBox(height: 20),

          // Recently released courses section
          _latestCourse(),

          const SizedBox(height: 20),

          // Category-based courses sections,
          _categoryBasedCourseSection(),
        ])));
  }

  Widget _latestCourse() {
    return BlocBuilder<CoursesBloc, CoursesState>(
      builder: (context, state) {
        if (state.isLoading ||
            state.courses.isEmpty ||
            state.errorMessage != null) {
          if (state.isLoading) isLoading.value = true;
          return const SizedBox();
        } else {
          isLoading.value = false;
          return Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              // gradient blue
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF007AFF), // xanh dương đậm (giống góc trái)
                  Color(0xFF00C6FF), // xanh dương nhạt (giống góc phải)
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CourseViewSection(
              sectionTitle: "Recently Released Courses",
              subtitle: "Discover the latest courses from top instructors",
              sectionTitleColor: Colors.white,
              subtitleColor: Colors.white70,
              courses: state.courses,
              cardHeight: 400,
              showCategory: true,
            ),
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
                      final isCategoryLoading =
                          coursesState.isCategoryLoading(category);

                      if (categoryCourses == null &&
                          !isCategoryLoading &&
                          coursesState.errorMessage == null) {
                        // Load courses for this category using filter
                        context.read<CoursesBloc>().add(
                              LoadCourses(
                                page: 1,
                                size: 10,
                                sortBy: 'price',
                                order: 'asc',
                                filter: "category in ('$category')",
                              ),
                            );
                        // Return loading indicator while fetching
                        return const SizedBox(
                          height: 200,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (categoryCourses != null &&
                          categoryCourses.isNotEmpty) {
                        return CourseViewSection(
                          sectionTitle: randomTitle,
                          subtitle: "Top-rated courses in $category",
                          courses: categoryCourses,
                          cardHeight: 400,
                          showCategory: true,
                        );
                      }

                      // Show loading if currently loading this category
                      if (isCategoryLoading) {
                        return const SizedBox(
                          height: 200,
                          child: Center(child: CircularProgressIndicator()),
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
        if (state.isLoading ||
            state.errorMessage != null ||
            state.courses.isEmpty) {
          return const SizedBox();
        } else {
          // Lấy 3 courses đầu tiên cho vertical layout
          final verticalCourses = state.courses.take(3).toList();
          return CourseViewSection(
            sectionTitle: "Quick Learning Path",
            subtitle: "Start your journey with these popular courses",
            courses: verticalCourses,
            cardHeight: 400,
            showCategory: true,
          );
        }
      },
    );
  }

  Widget _exploreCategoriesSection() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.isLoading ||
            state.allCategories == null ||
            state.allCategories!.isEmpty ||
            state.errorMessage != null) {
          return const SizedBox();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Explore Categories",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildCategoryList(state.allCategories!),
          ],
        );
      },
    );
  }

  Widget _buildCategoryList(List<String> categories) {
    final half = (categories.length / 2).ceil();
    final firstRow = categories.sublist(0, half);
    final secondRow = categories.sublist(half);

    return SizedBox(
      height: 100,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: firstRow
                  .map((category) => _buildCategoryItem(category))
                  .toList(),
            ),
            const SizedBox(height: 8),
            Row(
              children: secondRow
                  .map((category) => _buildCategoryItem(category))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String category) {
    final displayName =
        Category.fromDbValue(category)?.displayName ?? 'Unknown';
    final emoji = Category.fromDbValue(category)?.getEmoji() ?? '❓';

    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 6),
          Text(
            displayName,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _myLearningSection() {
    return BlocBuilder<EnrollmentBloc, EnrollmentState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const SizedBox(
            height: 240,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.errorMessage != null) {
          return const SizedBox();
        }

        if (state.enrollments.isEmpty) {
          return const SizedBox();
        }

        // Show only active enrollments, limit to 5 for horizontal scroll
        final activeEnrollments = state.enrollments
            .where((e) => e.status == EnrollmentStatus.active)
            .take(5)
            .toList();

        if (activeEnrollments.isEmpty) {
          return const SizedBox();
        }

        return EnrollmentViewSection(
          sectionTitle: 'My Learning',
          subtitle: 'Continue your learning journey',
          enrollments: activeEnrollments,
          cardHeight: 280,
          isHorizontal: true,
          onSeeAllTap: () {
            // Navigate to My Learning page (tab index 3, after Notification)
            context.read<RootBloc>().add(
                  const RootBottomTabChange(newIndex: 3),
                );
          },
        );
      },
    );
  }
}
