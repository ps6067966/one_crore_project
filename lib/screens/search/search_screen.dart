import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
        decoration: const InputDecoration(
      hintText: 'Search',
      prefixIcon: Icon(Icons.search),
    ));
  }
}
