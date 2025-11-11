import 'package:e_learning_mobile/common/extensions/context_extension.dart';
import 'package:e_learning_mobile/data/dtos/enrollment/enrollment_dto.dart';
import 'package:e_learning_mobile/presentation/home/widgets/enrollment_card.dart';
import 'package:flutter/material.dart';

class EnrollmentViewSection extends StatelessWidget {
  final String sectionTitle;
  final Color? sectionTitleColor;
  final List<EnrollmentDto> enrollments;
  final bool showSeeAll;
  final VoidCallback? onSeeAllTap;
  final String? subtitle;
  final Color? subtitleColor;
  final double cardHeight;
  final bool isHorizontal;

  const EnrollmentViewSection({
    super.key,
    required this.sectionTitle,
    required this.enrollments,
    this.sectionTitleColor = Colors.black,
    this.subtitleColor = Colors.grey,
    this.showSeeAll = true,
    this.onSeeAllTap,
    this.subtitle,
    this.cardHeight = 240,
    this.isHorizontal = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        _buildHeader(context),
        const SizedBox(height: 16),

        // Enrollment List
        _buildEnrollmentList(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sectionTitle,
                style: context.textStyles.heading3
                    .copyWith(color: sectionTitleColor),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: context.textStyles.body1
                      .copyWith(color: subtitleColor, fontSize: 14),
                ),
              ],
            ],
          ),
        ),
        if (showSeeAll)
          GestureDetector(
            onTap: onSeeAllTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF5B7FFF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'See all',
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFF5B7FFF),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEnrollmentList(BuildContext context) {
    if (enrollments.isEmpty) {
      return SizedBox(
        height: isHorizontal ? cardHeight : null,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.school_outlined,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 12),
              Text(
                'No courses enrolled',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (isHorizontal) {
      return SizedBox(
        height: cardHeight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: enrollments.length,
          separatorBuilder: (context, index) => const SizedBox(width: 16),
          itemBuilder: (context, index) {
            final enrollment = enrollments[index];
            return EnrollmentCard(
              enrollment: enrollment,
              isHorizontal: true,
            );
          },
        ),
      );
    } else {
      return Column(
        children: enrollments
            .map((enrollment) => EnrollmentCard(
                  enrollment: enrollment,
                  isHorizontal: false,
                ))
            .toList(),
      );
    }
  }
}
