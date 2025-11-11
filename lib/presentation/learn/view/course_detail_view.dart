/// Course Detail Page for unpurchased courses
///
/// This page displays detailed information about a course including:
/// - Course header with image and basic info
/// - Instructor information (with mock data for now)
/// - Reviews section (with mock data for now)
/// - Course content (sections and lectures from DTO)
/// - Purchase section with price and add to cart button
///
/// Usage:
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (context) => CourseDetailPage(
///       course: courseResponseDto,
///     ),
///   ),
/// );
/// ```
import 'package:e_learning_mobile/common/extensions/context_extension.dart';
import 'package:e_learning_mobile/common/utils/format_util.dart';
import 'package:e_learning_mobile/data/dtos/courses/course_response_dto.dart';
import 'package:e_learning_mobile/data/dtos/lectures/lecture_response_dto.dart';
import 'package:e_learning_mobile/data/dtos/review/review_response_dto.dart';
import 'package:e_learning_mobile/data/dtos/sections/section_response_dto.dart';
import 'package:e_learning_mobile/di/di.dart';
import 'package:e_learning_mobile/presentation/home/widgets/course_view_section.dart';
import 'package:e_learning_mobile/presentation/home/widgets/rating_widget.dart';
import 'package:e_learning_mobile/presentation/learn/bloc/courses/courses_bloc.dart';
import 'package:e_learning_mobile/presentation/learn/bloc/reviews/reviews_bloc.dart';
import 'package:e_learning_mobile/presentation/learn/bloc/sections/sections_bloc.dart';
import 'package:e_learning_mobile/presentation/payment/bloc/cart/cart_bloc.dart';
import 'package:e_learning_mobile/presentation/payment/views/cart_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseDetailPage extends StatelessWidget {
  final CourseResponseDto course;

  const CourseDetailPage({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<SectionsBloc>()
            ..add(LoadSectionsByCourseId(course.courseId)),
        ),
        BlocProvider(
          create: (context) => getIt<CoursesBloc>()
            ..add(LoadCourses(
              page: 1,
              size: 10,
              sortBy: 'created_at',
              order: 'desc',
              filter: "category in ('${course.category}')",
            )),
        ),
        BlocProvider(
          create: (context) =>
              getIt<ReviewsBloc>()..add(LoadReviewsByCourseId(course.courseId)),
        ),
        BlocProvider(
          create: (context) => getIt<CartBloc>()..add(const LoadCart()),
        ),
      ],
      child: CourseDetailView(course: course),
    );
  }
}

class CourseDetailView extends StatefulWidget {
  final CourseResponseDto course;

  const CourseDetailView({
    super.key,
    required this.course,
  });

  @override
  State<CourseDetailView> createState() => _CourseDetailViewState();
}

class _CourseDetailViewState extends State<CourseDetailView> {
  final Map<String, bool> _expandedSections = {};

  // Mock data for instructor
  final String _mockInstructorName = 'Robert Petras';
  final String _mockInstructorImage =
      'https://i.pravatar.cc/150?img=12'; // Placeholder image
  final String _mockInstructorBio =
      'Partnering with Udemy, I help developers master Apple app design and development using SwiftUI, SwiftData, Apple Intelligence and UI/UX Design.';
  final double _mockInstructorRating = 4.3;
  final int _mockInstructorReviews = 7665;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<SectionsBloc, SectionsState>(
        builder: (context, sectionsState) {
          return SafeArea(
            child: Column(
              children: [
                // Header with back button and wishlist
                _buildHeader(),
                // Main content (scrollable)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Course image and basic info
                        _buildCourseHeader(sectionsState),
                        const SizedBox(height: 24),
                        // Course info
                        _buildCourseInfo(sectionsState),
                        const SizedBox(height: 24),
                        // What you'll learn (mocked for now)
                        // _buildWhatYoullLearn(),
                        // const SizedBox(height: 24),
                        // Course content (sections and lectures)
                        _buildCourseContent(sectionsState),
                        const SizedBox(height: 24),
                        // Instructor section
                        _buildInstructorSection(),
                        const SizedBox(height: 24),
                        // Reviews section
                        _buildReviewsSection(),
                        const SizedBox(height: 24),
                        // Related courses section
                        _buildRelatedCoursesSection(),
                        const SizedBox(
                            height: 180), // Space for sticky bottom section
                      ],
                    ),
                  ),
                ),
                // Sticky bottom section (Purchase section)
                _buildPurchaseSection(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey[100],
              padding: const EdgeInsets.all(8),
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              // Handle wishlist
            },
            icon: const Icon(Icons.favorite_border),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseHeader(SectionsState state) {
    // Calculate total content stats
    int totalLectures = 0;
    int totalDuration = 0;
    for (final lectures in state.lecturesCache.values) {
      totalLectures += lectures.length;
      for (final lecture in lectures) {
        totalDuration += lecture.duration ?? 0;
      }
    }

    return Column(
      children: [
        // Course image
        Container(
          width: double.infinity,
          height: 220,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.course.image ?? ''),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              // Play button overlay
              Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    size: 40,
                    color: context.palette.buttonBackground,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Course title and info
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                widget.course.title,
                style: context.textStyles.heading1.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              // Subtitle/Description
              Text(
                widget.course.description ?? 'No description available.',
                style: context.textStyles.body1.copyWith(
                  color: Colors.grey[600],
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              // Rating and students
              Row(
                children: [
                  RatingWidget(
                    rating: 4.3,
                    reviewCount: 7665,
                    size: 16,
                  ),
                  const SizedBox(width: 16),
                  StudentCountWidget(
                    studentCount: 46815,
                    size: 16,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Course stats
              if (state.sections.isNotEmpty || totalLectures > 0)
                Wrap(
                  spacing: 16,
                  children: [
                    if (state.sections.isNotEmpty)
                      _buildStatChip(
                        Icons.list_alt,
                        '${state.sections.length} sections',
                      ),
                    if (totalLectures > 0)
                      _buildStatChip(
                        Icons.video_library,
                        '$totalLectures lectures',
                      ),
                    if (totalDuration > 0)
                      _buildStatChip(
                        Icons.access_time,
                        _formatDuration(totalDuration),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    }
    return '${minutes}m';
  }

  Widget _buildCourseInfo(SectionsState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 20,
                  color: Colors.grey[700],
                ),
                const SizedBox(width: 8),
                Text(
                  'Course Info',
                  style: context.textStyles.heading3.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
                'Instructor', widget.course.instructorName ?? 'Unknown'),
            const Divider(height: 20),
            _buildInfoRow('Level', widget.course.level ?? 'All Levels'),
            const Divider(height: 20),
            _buildInfoRow('Category', widget.course.category),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: context.textStyles.body2.copyWith(
            color: Colors.grey[600],
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: context.textStyles.body1.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPurchaseSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Price with "Only with" prefix
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Only with ',
                style: context.textStyles.body2.copyWith(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              Text(
                FormatUtil.formatNumberAsCurrency(
                  widget.course.price,
                  symbol: '₫',
                ),
                style: context.textStyles.heading1.copyWith(
                  fontWeight: FontWeight.w800,
                  color: context.palette.buttonBackground,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Add to cart button
          BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              final isInCart = cartState is CartLoaded &&
                  cartState.cart.items.any(
                    (item) => item.courseId == widget.course.courseId,
                  );

              return SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (isInCart) {
                      // Navigate to cart if already in cart
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartPage(),
                        ),
                      );
                    } else {
                      // Add to cart
                      context.read<CartBloc>().add(
                            AddItemToCart(
                              courseId: widget.course.courseId,
                              price: widget.course.price,
                            ),
                          );

                      // Show toast notification
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text('Đã thêm khóa học vào giỏ hàng thành công'),
                            ],
                          ),
                          backgroundColor: Colors.green[600],
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isInCart
                        ? Colors.green[600]
                        : context.palette.buttonBackground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isInCart) ...[
                        const Icon(Icons.shopping_cart, color: Colors.white),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        isInCart ? 'Xem giỏ hàng' : 'Add to cart',
                        style: context.textStyles.heading4.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          // Buy now button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: () {
                // Handle buy now
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                    color: context.palette.buttonBackground, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Buy now',
                style: context.textStyles.heading4.copyWith(
                  color: context.palette.buttonBackground,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Guarantee
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.verified,
                size: 18,
                color: Colors.green[600],
              ),
              const SizedBox(width: 6),
              Text(
                '30-Day Money-Back Guarantee',
                style: context.textStyles.body2.copyWith(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCourseContent(SectionsState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Course Content',
            style: context.textStyles.heading2.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          if (state.sections.isEmpty && !state.isLoading)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'No content available yet',
                  style: context.textStyles.body1.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ),
            )
          else
            ...state.sections.map((section) {
              final isExpanded = _expandedSections[section.sectionId] ?? false;
              final sectionLectures =
                  state.getLecturesForSection(section.sectionId);
              final isLoadingSection =
                  state.isSectionLoading(section.sectionId);

              return _buildSectionCard(
                section,
                isExpanded,
                sectionLectures,
                isLoadingSection,
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    SectionResponseDto section,
    bool isExpanded,
    List<LectureResponseDto> lectures,
    bool isLoading,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Section header
          InkWell(
            onTap: () {
              setState(() {
                _expandedSections[section.sectionId] = !isExpanded;
              });

              // Load lectures when expanding if not already loaded
              if (!isExpanded && lectures.isEmpty && !isLoading) {
                context.read<SectionsBloc>().add(
                      LoadLecturesBySectionId(section.sectionId),
                    );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      section.title,
                      style: context.textStyles.heading4.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
          ),
          // Lectures list
          if (isExpanded) ...[
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (lectures.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'No lectures available',
                  style: context.textStyles.body2.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              )
            else
              ...lectures.map((lecture) {
                return _buildLectureItem(lecture);
              }).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildLectureItem(LectureResponseDto lecture) {
    final duration = lecture.duration ?? 0;
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    final durationText = minutes > 0
        ? '${minutes}m'
        : seconds > 0
            ? '${seconds}s'
            : '';

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(
            Icons.play_circle_outline,
            size: 20,
            color: Colors.grey,
          ),
        ),
        title: Text(
          lecture.title,
          style: context.textStyles.body1.copyWith(
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: durationText.isNotEmpty
            ? Text(
                durationText,
                style: context.textStyles.body2.copyWith(
                  color: Colors.grey[600],
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildInstructorSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Instructor',
            style: context.textStyles.heading2.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                // Instructor info
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(_mockInstructorImage),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _mockInstructorName,
                            style: context.textStyles.heading3.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Instructor',
                            style: context.textStyles.body2.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              RatingWidget(
                                rating: _mockInstructorRating,
                                reviewCount: _mockInstructorReviews,
                                size: 14,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  _mockInstructorBio,
                  style: context.textStyles.body1.copyWith(
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    return BlocBuilder<ReviewsBloc, ReviewsState>(
      builder: (context, reviewsState) {
        // Calculate average rating
        double averageRating = 0;
        if (reviewsState.reviews.isNotEmpty) {
          averageRating = reviewsState.reviews
                  .map((r) => r.rating)
                  .reduce((a, b) => a + b) /
              reviewsState.reviews.length;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reviews',
                    style: context.textStyles.heading2.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (reviewsState.reviews.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        // TODO: Navigate to full reviews page
                      },
                      child: Text(
                        'See all (${reviewsState.reviews.length})',
                        style: context.textStyles.body1.copyWith(
                          color: context.palette.buttonBackground,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              // Show rating summary if there are reviews
              if (reviewsState.reviews.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      Text(
                        averageRating.toStringAsFixed(1),
                        style: context.textStyles.heading1.copyWith(
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFFFB74D),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RatingWidget(
                            rating: averageRating,
                            reviewCount: reviewsState.reviews.length,
                            size: 16,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${reviewsState.reviews.length} reviews',
                            style: context.textStyles.body2.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              if (reviewsState.isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (reviewsState.errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red[600]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Error loading reviews: ${reviewsState.errorMessage}',
                          style: TextStyle(color: Colors.red[800]),
                        ),
                      ),
                    ],
                  ),
                )
              else if (reviewsState.reviews.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.reviews_outlined,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No reviews yet',
                          style: context.textStyles.body1.copyWith(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Be the first to review this course',
                          style: context.textStyles.body2.copyWith(
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...reviewsState.reviews.take(3).map(
                      (review) => _buildReviewCard(review),
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReviewCard(ReviewResponseDto review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info
          Row(
            children: [
              if (review.userAvatar.isNotEmpty)
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(review.userAvatar),
                  onBackgroundImageError: (_, __) {},
                )
              else
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blue,
                  child: Text(
                    review.userName.isNotEmpty
                        ? review.userName[0].toUpperCase()
                        : 'U',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName.isNotEmpty ? review.userName : 'User',
                      style: context.textStyles.body1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              // Rating
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < review.rating
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    size: 16,
                    color: const Color(0xFFFFB74D),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Review text
          Text(
            review.comment,
            style: context.textStyles.body1.copyWith(
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          // Helpful button
          TextButton.icon(
            onPressed: () {
              // TODO: Implement helpful/like functionality
            },
            icon: Icon(
              Icons.thumb_up_outlined,
              size: 16,
              color: Colors.grey[600],
            ),
            label: Text(
              'Helpful (${review.likeCount})',
              style: context.textStyles.body2.copyWith(
                color: Colors.grey[600],
              ),
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedCoursesSection() {
    return BlocBuilder<CoursesBloc, CoursesState>(
      builder: (context, coursesState) {
        // Get courses for the same category, excluding current course
        final categoryCourses =
            coursesState.categoryCourses[widget.course.category];
        if (categoryCourses == null || categoryCourses.isEmpty) {
          return const SizedBox();
        }

        // Filter out current course and limit to 5 courses
        final relatedCourses = categoryCourses
            .where((course) => course.courseId != widget.course.courseId)
            .take(5)
            .toList();

        if (relatedCourses.isEmpty) {
          return const SizedBox();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Related Courses',
                style: context.textStyles.heading2.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              CourseViewSection(
                sectionTitle: '',
                courses: relatedCourses,
                showSeeAll: false,
                cardHeight: 400,
                showCategory: true,
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        );
      },
    );
  }
}
