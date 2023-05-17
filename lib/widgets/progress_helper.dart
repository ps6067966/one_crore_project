import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';

class ProgressWidget extends StatelessWidget {
  final String? progressText;

  const ProgressWidget({this.progressText, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: JumpingDots(
          color: Colors.yellow,
          radius: 10,
          numberOfDots: 3,
          animationDuration: const Duration(milliseconds: 200),
        ),
      ),
    );
  }
}
