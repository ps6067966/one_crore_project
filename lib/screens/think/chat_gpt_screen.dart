import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../../constant/global.dart';
import '../../services/chat_gpt_src.dart';
import '../../services/models/completion_request.dart';
import '../../services/models/message.dart';
import '../../services/models/role.dart';
import '../../services/models/stream_completion_response.dart';

class QuestionAnswer {
  final String question;
  final StringBuffer answer;

  QuestionAnswer({
    required this.question,
    required this.answer,
  });

  QuestionAnswer copyWith({
    String? newQuestion,
    StringBuffer? newAnswer,
  }) {
    return QuestionAnswer(
      question: newQuestion ?? question,
      answer: newAnswer ?? answer,
    );
  }
}

class ChatGptScreen extends StatefulWidget {
  const ChatGptScreen({super.key});

  @override
  State<ChatGptScreen> createState() => _ChatGptScreenState();
}

class _ChatGptScreenState extends State<ChatGptScreen> {
  String? answer;
  final chatGpt = ChatGpt(apiKey: apiKey);
  bool loading = false;
  final testPrompt =
      'Which Disney character famously leaves a glass slipper behind at a royal ball?';

  final List<QuestionAnswer> questionAnswers = [];

  late TextEditingController textEditingController;

  StreamSubscription<StreamCompletionResponse>? streamSubscription;

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ChatGPT")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: questionAnswers.length,
                  itemBuilder: (context, index) {
                    final questionAnswer = questionAnswers[index];
                    final answer = questionAnswer.answer.toString().trim();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Q: ${questionAnswer.question}'),
                        const SizedBox(height: 12),
                        if (answer.isEmpty && loading)
                          const Center(child: CircularProgressIndicator())
                        else
                          Text('A: $answer'),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: textEditingController,
                      decoration: const InputDecoration(hintText: 'Type in...'),
                      onFieldSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ClipOval(
                    child: Material(
                      color: Colors.blue, // Button color
                      child: InkWell(
                        onTap: _sendMessage,
                        child: const SizedBox(
                          width: 48,
                          height: 48,
                          child: Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _sendMessage() async {
    final question = textEditingController.text;
    setState(() {
      textEditingController.clear();
      loading = true;
      questionAnswers.add(
        QuestionAnswer(
          question: question,
          answer: StringBuffer(),
        ),
      );
    });
    final testRequest = CompletionRequest(
      stream: true,
      maxTokens: 4000,
      messages: [Message(role: Role.user.name, content: question)],
    );
    await _streamResponse(testRequest);
    setState(() => loading = false);
  }

  _streamResponse(CompletionRequest request) async {
    streamSubscription?.cancel();
    try {
      final stream = await chatGpt.createChatCompletionStream(request);
      streamSubscription = stream?.listen(
        (event) => setState(
          () {
            if (event.streamMessageEnd) {
              streamSubscription?.cancel();
            } else {
              return questionAnswers.last.answer.write(
                event.choices?.first.delta?.content,
              );
            }
          },
        ),
      );
    } catch (error) {
      log("Error occurred: $error");
      setState(() {
        loading = false;
        questionAnswers.last.answer.write("Error");
      });
    }
  }
}
