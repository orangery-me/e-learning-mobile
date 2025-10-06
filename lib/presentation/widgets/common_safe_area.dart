import 'package:flutter/material.dart';
import 'package:e_learning_mobile/common/extensions/context_extension.dart';
import 'package:e_learning_mobile/common/theme/app_size.dart';

class AppSafeArea extends StatelessWidget {
  const AppSafeArea({required this.child, super.key, this.paddingBottom = 0});
  final Widget child;
  final double paddingBottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSize.horizontalSpacing,
        context.paddingTop,
        AppSize.horizontalSpacing,
        paddingBottom,
      ),
      child: child,
    );
  }
}
