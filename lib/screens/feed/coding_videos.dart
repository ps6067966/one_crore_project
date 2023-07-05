import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/custom_circular_indicator.dart';
import '../../widgets/pod_players.dart';
import 'educational_videos.dart';

class CodingVideos extends ConsumerStatefulWidget {
  const CodingVideos({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CodingVideosState();
}

class _CodingVideosState extends ConsumerState<CodingVideos> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: videoCollection
            .where("type", isEqualTo: "Coding")
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
