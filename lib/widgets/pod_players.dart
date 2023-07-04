import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:h3m_shimmer_card/h3m_shimmer_card.dart';
import 'package:pod_player/pod_player.dart';

import '../constant/color.dart';
import '../util/utils.dart';

class PodPlayerView extends StatefulWidget {
  final String videoUrl;
  const PodPlayerView({required this.videoUrl, super.key});

  @override
  State<PodPlayerView> createState() => _PodPlayerViewState();
}

class _PodPlayerViewState extends State<PodPlayerView> {
  String videoId = "";
  PodPlayerController? controller;
  @override
  void initState() {
    super.initState();
    controller = PodPlayerController(
      podPlayerConfig: const PodPlayerConfig(
        autoPlay: false,
        wakelockEnabled: true,
        forcedVideoFocus: true,
        isLooping: true,
      ),
      playVideoFrom: PlayVideoFrom.youtube(
        widget.videoUrl,
      ),
    )..initialise();
    videoId = convertUrlToId(widget.videoUrl) ?? "";
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      const ShimmerCard();
    }
    return PodVideoPlayer(
      key: ValueKey(widget.videoUrl),
      controller: controller!,
      podProgressBarConfig: const PodProgressBarConfig(
        bufferedBarColor: primaryColor,
        circleHandlerColor: primaryColor,
        playingBarColor: primaryColor,
      ),
      videoThumbnail: DecorationImage(
        image: ExtendedImage.network(
          "https://i1.ytimg.com/vi/$videoId/maxresdefault.jpg",
          cache: true,
        ).image,
        fit: BoxFit.cover,
      ),
    );
  }
}
