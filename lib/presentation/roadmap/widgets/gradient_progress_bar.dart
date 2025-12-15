import 'package:flutter/material.dart';

class GradientProgressBar extends StatelessWidget {
  final double value;
  final double height;
  final BorderRadius? borderRadius;

  const GradientProgressBar({
    super.key,
    required this.value,
    this.height = 8,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = this.borderRadius ?? BorderRadius.circular(8);

    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        height: height,
        child: Stack(
          children: [
            // Background
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: borderRadius,
              ),
            ),
            // Progress with gradient
            FractionallySizedBox(
              widthFactor: value.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF4CAF50), // Green
                      Color(0xFF2196F3), // Blue
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: borderRadius,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
