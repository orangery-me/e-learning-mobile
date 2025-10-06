import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:e_learning_mobile/common/extensions/context_extension.dart';
// Removed Lottie usage; using a Material icon placeholder instead
import 'package:e_learning_mobile/generated/locale_keys.g.dart';
import 'package:e_learning_mobile/presentation/widgets/common_rounded_button.dart';

class CommonError extends StatelessWidget {
  const CommonError({super.key, this.onRefresh});
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: context.width / 2,
            color: Theme.of(context).colorScheme.error,
          ),
          Text(
            LocaleKeys.texts_error_occur.tr(),
            style: context.textStyles.errorButtonLabel,
            textAlign: TextAlign.center,
          ),
          if (onRefresh != null)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: CommonRoundedButton(
                onPressed: onRefresh!,
                content: LocaleKeys.button_try_again.tr(),
              ),
            ),
        ],
      ),
    );
  }
}
