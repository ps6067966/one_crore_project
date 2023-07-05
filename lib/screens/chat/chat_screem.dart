import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:one_crore_project/constant/color.dart';
import 'package:one_crore_project/util/utils.dart';
import 'package:pod_player/pod_player.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../widgets/custom_circular_indicator.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({
    Key? key,
  }) : super(key: key);

  @override
  ChatRoomScreenState createState() => ChatRoomScreenState();
}

class ChatRoomScreenState extends State<ChatRoomScreen>
    with WidgetsBindingObserver {
  late ScrollController _scrollController;
  final TextEditingController _chatController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? docID = DateTime.now().toIso8601String().split("T")[0];
  PodPlayerController? podPlayerController;
  final chatRoomCollection = FirebaseFirestore.instance.collection('chatroom');

  bool isProgressRunning = false;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController = ScrollController();
    chatRoomCollection.doc(docID).get().then((value) {
      if (value.exists) {
        podPlayerController = PodPlayerController(
          podPlayerConfig: const PodPlayerConfig(autoPlay: false),
          playVideoFrom: PlayVideoFrom.youtube(
            value["image"],
          ),
        )..initialise();
        if (mounted) {
          setState(() {});
        }
      } else {
        chatRoomCollection.doc(docID).set({
          "topic_name": "Topic of the day",
          "image": "https://youtu.be/UNAu-gNSqsM",
        });
      }
    });
  }

  @override
  void dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    _chatController.dispose();
    podPlayerController?.dispose();
    super.dispose();
  }

  void scrollToBottom() {
    final bottomOffset = _scrollController.position.maxScrollExtent;
    _scrollController.animateTo(
      bottomOffset,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
    );
  }

  Future<void> onSendMessage() async {
    Map<String, dynamic> messages = {
      "name": _auth.currentUser?.displayName?.split(" ")[0] ?? "",
      "email_id": _auth.currentUser?.email ?? "",
      "photo_url": _auth.currentUser?.photoURL ?? "",
      "message": _chatController.text,
      "time": FieldValue.serverTimestamp(),
    };
    chatRoomCollection.doc(docID).collection('chats').add(messages);
    _chatController.clear();
  }

  // onChatPushNotify() async {
  //   EasyLoading.show(
  //       status: "Connecting with our secure server",
  //       maskType: EasyLoadingMaskType.clear);
  //   EasyLoading.dismiss();
  //   ApiServices.sendChatNotification(deviceToken: '', senderName: ''
  //       // senderName: isListener ? widget.userName : widget.listenerName,
  //       );
  //   // }
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: context.isDarkMode ? primaryBlackColor : Colors.white70,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(context.isDarkMode
                            ? "assets/images/chat_bg.jpg"
                            : "assets/images/chat_bg_light.jpg"))),
                // height: size.height / 1.25,
                width: size.width,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 16.0,
                            right: 16,
                          ),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(15)),
                              width: double.infinity,
                              height: 50,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Today's Topic of Discussion",
                                      style: GoogleFonts.robotoFlex(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                    StreamBuilder(
                                        stream: chatRoomCollection
                                            .doc(docID)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            final data = snapshot.data;
                                            return Text(
                                              data?["topic_name"] ?? "",
                                              style: GoogleFonts.robotoFlex(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            );
                                          }
                                          return const SizedBox();
                                        }),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                            top: -6,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Icon(
                                Icons.question_mark,
                                color: context.isDarkMode
                                    ? Colors.white
                                    : Colors.amber,
                                size: 20,
                              ),
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    podPlayerController == null
                        ? const SizedBox()
                        : SizedBox(
                            height: 170,
                            width: size.width,
                            child: PodVideoPlayer(
                              controller: podPlayerController!,
                            ),
                          ),
                    const SizedBox(
                      height: 4,
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: chatRoomCollection
                            .doc(docID)
                            .collection('chats')
                            .orderBy('time', descending: true)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            return Expanded(
                              child: ListView.builder(
                                  controller: _scrollController,
                                  reverse: true,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data?.docs.length ?? 0,
                                  itemBuilder: (context, index) {
                                    final chatData = snapshot.data?.docs[index];
                                    return Container(
                                      width: size.width,
                                      alignment: chatData?['email_id'] ==
                                              _auth.currentUser?.email
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 6,
                                              horizontal: 10,
                                            ),
                                            margin: const EdgeInsets.symmetric(
                                              vertical: 5,
                                              horizontal: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: context.isDarkMode
                                                  ? primaryBlackColor
                                                  : Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.4),
                                                  spreadRadius: 1,
                                                  blurRadius: 1,
                                                  offset: const Offset(0, 1),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              crossAxisAlignment: chatData?[
                                                          'email_id'] ==
                                                      _auth.currentUser?.email
                                                  ? CrossAxisAlignment.end
                                                  : CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      width: 30,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image:
                                                              ExtendedNetworkImageProvider(
                                                            chatData?[
                                                                    'photo_url'] ??
                                                                "",
                                                            cache: true,
                                                          ),
                                                          fit: BoxFit.cover,
                                                        ),
                                                        border: Border.all(
                                                          color: context
                                                                  .isDarkMode
                                                              ? Colors.white
                                                              : primaryBlackColor,
                                                          width: 1,
                                                        ),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      chatData?['name'] ?? "",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: context
                                                                  .isDarkMode
                                                              ? Colors.white
                                                              : primaryBlackColor,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  chatData?['message'],
                                                  style: TextStyle(
                                                    color: context.isDarkMode
                                                        ? Colors.white
                                                        : primaryBlackColor,
                                                    fontSize: 16.0,
                                                  ),
                                                  textAlign:
                                                      chatData?['email_id'] ==
                                                              _auth.currentUser
                                                                  ?.email
                                                          ? TextAlign.right
                                                          : TextAlign.left,
                                                ),
                                                Text(
                                                  timeago.format(
                                                    chatData?['time'] == null
                                                        ? DateTime.now()
                                                        : chatData?['time']
                                                            .toDate(),
                                                  ),
                                                  style: TextStyle(
                                                    color: context.isDarkMode
                                                        ? Colors.white
                                                        : primaryBlackColor,
                                                    fontSize: 10.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CustomCircularIndicator();
                          } else {
                            return Container();
                          }
                        }),
                  ],
                ),
              ),
            ),

            Container(
              height: size.height / 14.0,
              width: size.width,
              color: context.isDarkMode ? Colors.transparent : Colors.white70,
              alignment: Alignment.center,
              child: SizedBox(
                height: size.height / 14,
                width: size.width / 1.1,
                child: Row(
                  children: [
                    SizedBox(
                      height: size.height / 14,
                      width: size.width / 1.32,
                      child: TextFormField(
                        autofocus: false,
                        controller: _chatController,
                        decoration: const InputDecoration(
                          hintText: 'Type here',
                        ),
                        onChanged: (value) {},
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                        onTap: () {
                          if (_chatController.text.trim().isNotEmpty) {
                            onSendMessage();
                            // onChatPushNotify();
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Icon(Icons.send),
                        )),
                  ],
                ),
              ),
            ),
            // }
          ],
        ),
      ),
    );
  }
}
