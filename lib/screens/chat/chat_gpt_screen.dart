import 'dart:async';
import 'dart:developer';

import 'package:bard_api/bard_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:one_crore_project/constant/color.dart';
import 'package:one_crore_project/util/utils.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../widgets/progress_container_view.dart';

class ChatGptScreen extends StatefulWidget {
  const ChatGptScreen({
    Key? key,
  }) : super(key: key);

  @override
  ChatGptScreenState createState() => ChatGptScreenState();
}

class ChatGptScreenState extends State<ChatGptScreen>
    with WidgetsBindingObserver {
  late ScrollController _scrollController;
  final TextEditingController _chatController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final chatRoomCollection = FirebaseFirestore.instance.collection('bard');
  final sessionCollection = FirebaseFirestore.instance.collection('session');
  String sessionId = "";

  bool isProgressRunning = false;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController = ScrollController();
    chatRoomCollection.doc(FirebaseAuth.instance.currentUser?.email).set({
      "name": _auth.currentUser?.displayName?.split(" ")[0] ?? "",
      "email_id": _auth.currentUser?.email ?? "",
      "photo_url": _auth.currentUser?.photoURL ?? "",
    });
    sessionCollection
        .doc("1")
        .get()
        .then((value) => sessionId = value["session"]);
  }

  @override
  void dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    _chatController.dispose();
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
    if (mounted) {
      setState(() {
        isProgressRunning = true;
      });
    }
    final bard = ChatBot(sessionId: sessionId);
    final result = await bard.ask(_chatController.text);
    Map<String, dynamic> messages = {
      "name": _auth.currentUser?.displayName?.split(" ")[0] ?? "",
      "email_id": _auth.currentUser?.email ?? "",
      "photo_url": _auth.currentUser?.photoURL ?? "",
      "message": _chatController.text,
      "time": FieldValue.serverTimestamp(),
    };
    _chatController.clear();
    chatRoomCollection
        .doc(FirebaseAuth.instance.currentUser?.email)
        .collection('chats')
        .add(messages);
    Map<String, dynamic> messages2 = {
      "name": "AI Bot",
      "email_id": "aibot@gmail.com",
      "photo_url":
          "https://images.ctfassets.net/foc8yxpzaiuk/WFEZbr6obtbPRG7msTVN6/3151320e157d9cfc3b282a1d6c19e743/11._Guide_to_Understanding_AI_Chatbots.jpg",
      "message": result["content"],
      "time": FieldValue.serverTimestamp(),
    };
    chatRoomCollection
        .doc(FirebaseAuth.instance.currentUser?.email)
        .collection('chats')
        .add(messages2);
    log("$result");

    if (mounted) {
      setState(() {
        isProgressRunning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 30,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: ExtendedImage.network(
                      "https://images.ctfassets.net/foc8yxpzaiuk/WFEZbr6obtbPRG7msTVN6/3151320e157d9cfc3b282a1d6c19e743/11._Guide_to_Understanding_AI_Chatbots.jpg")
                  .image,
            ),
            const SizedBox(
              width: 10,
            ),
            const Text("AI Bot"),
          ],
        ),
      ),
      backgroundColor: context.isDarkMode ? primaryBlackColor : Colors.white70,
      body: ProgressContainerView(
        isProgressRunning: isProgressRunning,
        child: SafeArea(
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
                      StreamBuilder<QuerySnapshot>(
                          stream: chatRoomCollection
                              .doc(FirebaseAuth.instance.currentUser?.email)
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
                                      final chatData =
                                          snapshot.data?.docs[index];
                                      return Container(
                                        constraints: BoxConstraints(
                                            maxWidth: size.width * 0.7),
                                        alignment: chatData?['email_id'] ==
                                                _auth.currentUser?.email
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        child: Column(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 6,
                                                horizontal: 10,
                                              ),
                                              margin:
                                                  const EdgeInsets.symmetric(
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
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
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
                                                          shape:
                                                              BoxShape.circle,
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
                                                                FontWeight
                                                                    .w600),
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
                                                                _auth
                                                                    .currentUser
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
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
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
      ),
    );
  }
}
