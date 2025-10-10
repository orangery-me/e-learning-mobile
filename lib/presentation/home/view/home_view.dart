import 'package:e_learning_mobile/presentation/auth/bloc/auth/auth_bloc.dart';
import 'package:e_learning_mobile/presentation/home/widgets/category_card.dart';
import 'package:e_learning_mobile/presentation/home/widgets/continue_learning.dart';
import 'package:e_learning_mobile/presentation/home/widgets/course_view_section.dart';
import 'package:e_learning_mobile/presentation/home/widgets/search_section.dart';
import 'package:e_learning_mobile/presentation/home/widgets/user_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_learning_mobile/presentation/home/bloc/home_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => HomeBloc(), child: const _HomeView());
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    // get current user info
    final user = context.read<AuthBloc>().state.user;

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                  CourseViewSection(sectionTitle: "Most Popular Certificates"),

                  const SizedBox(height: 20),
                  CourseViewSection(sectionTitle: "Course for you"),
                ])));
      },
    );
  }
}


// Container(
//               width: double.infinity,
//               height: 100,
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Color(0xFF1976D2), // xanh đậm
//                     Color(0xFF42A5F5), // xanh nhạt
//                   ],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.all(Radius.circular(16)),
//               ),
//               margin: const EdgeInsets.all(16),
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // Text section
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "Achieve your career goals",
//                           style: Fonts.s14w4
//                               .copyWith(color: Colors.white, fontSize: 20),
//                         ),
//                         Text(
//                           "with Coursera",
//                           style: TextStyle(
//                             color: Colors.white70,
//                             fontSize: 16,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
            // )