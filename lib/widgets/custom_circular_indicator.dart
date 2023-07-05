import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomCircularIndicator extends ConsumerWidget {
  const CustomCircularIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Center(
      child: Card(
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              )),
        ),
      ),
    );
  }
}
