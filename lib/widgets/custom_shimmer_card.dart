import 'package:flutter/material.dart';
import 'package:h3m_shimmer_card/h3m_shimmer_card.dart';
import 'package:one_crore_project/constant/color.dart';
import 'package:one_crore_project/util/utils.dart';

class CustomShimmerCard extends StatefulWidget {
  final double height;
  final Widget child;
  final bool isProgressRunning;
  final double width;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  const CustomShimmerCard(
      {required this.height,
      required this.width,
      this.padding,
      required this.child,
      this.borderRadius,
      required this.isProgressRunning,
      super.key});

  @override
  State<CustomShimmerCard> createState() => _CustomShimmerCardState();
}

class _CustomShimmerCardState extends State<CustomShimmerCard> {
  @override
  Widget build(BuildContext context) {
    if (widget.isProgressRunning) {
      return Padding(
        padding: widget.padding ?? EdgeInsets.zero,
        child: ShimmerCard(
          borderRadius: widget.borderRadius ?? 0,
          width: widget.width,
          height: widget.height,
          beginAlignment: Alignment.topLeft,
          endAlignment: Alignment.bottomRight,
          backgroundColor:
              context.isDarkMode ? primaryBlackColor : Colors.white,
          shimmerColor: Colors.grey,
        ),
      );
    }
    return widget.child;
  }
}