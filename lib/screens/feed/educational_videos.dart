import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_crore_project/widgets/pod_players.dart';

final videoCollection = FirebaseFirestore.instance.collection("videos");

class EducationVideos extends ConsumerStatefulWidget {
  const EducationVideos({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EducationVideosState();
}

class _EducationVideosState extends ConsumerState<EducationVideos> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: videoCollection
            .where("type", isEqualTo: "Educational")
            .orderBy("id", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
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
