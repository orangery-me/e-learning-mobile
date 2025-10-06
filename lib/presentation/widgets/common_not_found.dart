import 'package:flutter/material.dart';
import 'package:e_learning_mobile/common/extensions/context_extension.dart';
// Removed Lottie usage; using a Material icon placeholder instead

class CommonNotFound extends StatelessWidget {
  const CommonNotFound({required this.text, super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.search_off_rounded,
          size: context.width / 2,
          color: Theme.of(context).colorScheme.primary,
        ),
        Text(
          text,
          style: context.textStyles.body1,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
