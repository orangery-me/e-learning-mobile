import 'package:flutter/material.dart';

class OtherFeatureView extends StatelessWidget {
  final String courseId;
  const OtherFeatureView({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('This feature is under development.'),
      ),
    );
  }
}
