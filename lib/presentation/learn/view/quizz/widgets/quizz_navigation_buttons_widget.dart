import 'package:e_learning_mobile/common/extensions/context_extension.dart';
import 'package:e_learning_mobile/common/theme/palette.dart';
import 'package:flutter/material.dart';

class QuizzNavigationButtonsWidget extends StatelessWidget {
  final bool canGoPrev;
  final bool canGoNext;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const QuizzNavigationButtonsWidget({
    super.key,
    required this.canGoPrev,
    required this.canGoNext,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OutlinedButton.icon(
          onPressed: canGoPrev ? onPrevious : null,
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: Palette.light().primaryColor,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: Icon(
            Icons.arrow_back,
            color: Palette.light().primaryColor,
          ),
          label: Text(
            'Previous',
            style: context.textStyles.buttonLabel.copyWith(
              color: Palette.light().primaryColor,
            ),
          ),
        ),
        OutlinedButton.icon(
          onPressed: canGoNext ? onNext : null,
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: Palette.light().primaryColor,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          label: Text(
            'Next',
            style: context.textStyles.buttonLabel.copyWith(
              color: Palette.light().primaryColor,
            ),
          ),
          icon: Icon(
            Icons.arrow_forward,
            color: Palette.light().primaryColor,
          ),
        ),
      ],
    );
  }
}
