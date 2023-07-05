import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/custom_circular_indicator.dart';
import '../../widgets/pod_players.dart';
import 'educational_videos.dart';

class AiVideos extends ConsumerStatefulWidget {
  const AiVideos({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AiVideosState();
}

class _AiVideosState extends ConsumerState<AiVideos> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: videoCollection
            .where("type", isEqualTo: "AI")
            .orderBy("id", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CustomCircularIndicator();
          }
          final data = snapshot.data?.docs;
          return ListView.builder(
            itemCount: data?.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final video = data?[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 14.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: PodPlayerView(
                    key: ValueKey(video?.data()["id"]),
                    videoUrl: video?.data()["url"],
                  ),
                ),
              );
            },
          );
        });
  }
}
