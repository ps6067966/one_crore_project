import 'package:flutter/material.dart';

class KnowYourself extends StatefulWidget {
  const KnowYourself({super.key});

  @override
  State<KnowYourself> createState() => _KnowYourselfState();
}

class _KnowYourselfState extends State<KnowYourself> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Know Yourself"),
      ),
      body: SafeArea(
        child: Column(
          children: const [
            Text("Know Yourself"),
          ],
        ),
      ),
    );
  }
}
