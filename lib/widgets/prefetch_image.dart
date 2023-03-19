import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'custom_shimmer_card.dart';

class PrefetchImage extends StatefulWidget {
  final String imageUrl;
  final double height;
  final double width;
  final Color? color;
  final BlendMode? colorBlendMode;
  final BoxFit? fit;
  final String? semantic;
  const PrefetchImage(
      {required this.imageUrl,
      required this.height,
      required this.width,
      this.color,
      this.colorBlendMode,
      this.fit,
      this.semantic,
      Key? key})
      : super(key: key);

  @override
  PrefetchImageState createState() => PrefetchImageState();
}

class PrefetchImageState extends State<PrefetchImage> {
  @override
  Widget build(BuildContext context) {
    if (widget.imageUrl.contains(".svg")) {
      return SvgPicture.network(
        widget.imageUrl,
        width: widget.width,
        height: widget.height,
        fit: widget.fit ?? BoxFit.cover,
        semanticsLabel: widget.semantic,
        placeholderBuilder: (context) {
          return CustomShimmerCard(
            width: widget.width,
            height: widget.height,
            isProgressRunning: true,
            child: const SizedBox(),
          );
        },
      );
    }
    return ExtendedImage.network(
      widget.imageUrl,
      width: widget.width,
      height: widget.height,
      color: widget.color,
      cache: true,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return CustomShimmerCard(
              width: widget.width,
              height: widget.height,
              isProgressRunning: true,
              child: const SizedBox(),
            );
          case LoadState.completed:
            return null;
          case LoadState.failed:
            return CustomShimmerCard(
              width: widget.width,
              height: widget.height,
              isProgressRunning: true,
              child: const SizedBox(),
            );
        }
      },
      enableLoadState: false,
      colorBlendMode: widget.colorBlendMode,
      fit: widget.fit,
      semanticLabel: widget.semantic,
      handleLoadingProgress: true,
    );
  }
}
