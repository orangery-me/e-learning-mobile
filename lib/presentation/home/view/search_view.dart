import 'dart:async';

import 'package:e_learning_mobile/common/extensions/context_extension.dart';
import 'package:e_learning_mobile/presentation/home/widgets/compact_course_card.dart';
import 'package:e_learning_mobile/presentation/learn/bloc/courses/courses_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  final int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom && context.read<CoursesBloc>().state.hasMore) {
      final currentState = context.read<CoursesBloc>().state;
      if (!currentState.isLoading) {
        final nextPage = currentState.page + 1;
        context.read<CoursesBloc>().add(LoadCourses(
              query: _searchController.text,
              page: nextPage,
              size: _pageSize,
            ));
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        context.read<CoursesBloc>().add(LoadCourses(
              query: query,
              page: 1,
              size: _pageSize,
            ));
      } else {
        // Clear results if query is empty
        // We can create a specialized event or just load default
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: context.palette.scaffoldBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.palette.normalText),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Container(
          decoration: BoxDecoration(
            color: context.palette.textFieldBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            onChanged: (value) => _onSearchChanged(value),
            style: context.textStyles.body1,
            decoration: InputDecoration(
              hintText: 'Search courses...',
              hintStyle: context.textStyles.body1.copyWith(
                color: context.palette.hintTextField,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: context.palette.hintTextField,
              ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
      ),
      body: BlocBuilder<CoursesBloc, CoursesState>(
        builder: (context, state) {
          if (state.isLoading && state.courses.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.courses.isEmpty) {
            if (_searchController.text.isNotEmpty && !state.isLoading) {
              return Center(
                child: Text(
                  'No courses found',
                  style: context.textStyles.body1.copyWith(
                    color: context.palette.hintTextField,
                  ),
                ),
              );
            }
            return Center(
              child: Text(
                'Type to search courses',
                style: context.textStyles.body1.copyWith(
                  color: context.palette.hintTextField,
                ),
              ),
            );
          }

          return ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount:
                state.hasMore ? state.courses.length + 1 : state.courses.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              if (index >= state.courses.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              final course = state.courses[index];
              return CompactCourseCard(
                course: course,
              );
            },
          );
        },
      ),
    );
  }
}
