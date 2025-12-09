import 'package:flutter/material.dart';
import 'package:e_learning_mobile/common/theme/palette.dart';
import 'package:e_learning_mobile/common/theme/text_styles.dart';
import 'package:e_learning_mobile/generated/fonts.gen.dart';

class ThemeSheet {
  final ThemeData themeData;
  final Palette palette;
  final AppTextStyles textStyles;

  ThemeSheet({required this.palette, required this.textStyles})
      : themeData = ThemeData(
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            },
          ),
          brightness: palette.brightness,
          fontFamily: FontFamily.openSans,
          scaffoldBackgroundColor: palette.scaffoldBackground,
          extensions: [palette, textStyles],
        );
}
