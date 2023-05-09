import 'dart:convert';

import 'package:dio/dio.dart';

import 'chat_gpt/interceptor/chat_gpt_interceptor.dart';
import 'models/async_completion_response.dart';
import 'models/completion_request.dart';
import 'models/create_image_request.dart';
import 'models/image_response.dart';
import 'models/image_variation_request.dart';
import 'models/stream_completion_response.dart';
import 'transformers/stream_transformers.dart';

const openAiBaseUrl = 'https://api.openai.com/v1';
const chatCompletionsEndPoint = '/chat/completions';
const imageGenerationsEndPoint = '/images/generations';
const imageEditsEndPoint = '/images/edits';
const imageVariationsEndPoint = '/images/variations';

class ChatGpt {
  final String apiKey;

  ChatGpt({
    required this.apiKey,
  });

  Future<AsyncCompletionResponse?> createChatCompletion(
    CompletionRequest request,
  ) async {
    final response = await dio.post(
      chatCompletionsEndPoint,
      data: json.encode(request.toJson()),
    );
    final data = response.data;
    if (data != null) {
      return AsyncCompletionResponse.fromJson(data);
    }
    return null;
  }

  Future<Stream<StreamCompletionResponse>?> createChatCompletionStream(
    CompletionRequest request,
  ) async {
    final response = await dio.post<ResponseBody>(
      chatCompletionsEndPoint,
      data: json.encode(request.toJson()),
      options: Options(
        headers: {
          "Accept": "text/event-stream",
          "Cache-Control": "no-cache",
        },
        responseType: ResponseType.stream,
      ),
    );

    final stream = response.data?.stream
        .transform(unit8Transformer)
        .transform(const Utf8Decoder())
        .transform(const LineSplitter())
        .transform(responseTransformer);

    return stream;
  }

  Future<ImageResponse?> createImage(
    CreateImageRequest request,
  ) async {
    final response = await dio.post(
      imageGenerationsEndPoint,
      data: json.encode(request.toJson()),
    );
    final data = response.data;
    if (data != null) {
      return ImageResponse.fromJson(data);
    }
    return null;
  }

  Future<ImageResponse?> createImageVariation(
    ImageVariationRequest request,
  ) async {
    final formData = FormData.fromMap({
      'n': request.n,
      'size': request.size,
      'image': request.image != null
          ? await MultipartFile.fromFile(request.image ?? '')
          : MultipartFile.fromBytes(request.webImage?.toList() ?? [],
              filename: ''),
    });
    final response = await imageDio.post(
      imageVariationsEndPoint,
      data: formData,
    );
    final data = response.data;
    if (data != null) {
      return ImageResponse.fromJson(data);
    }
    return null;
  }

  Dio get dio => Dio(BaseOptions(
      baseUrl: openAiBaseUrl,
      receiveTimeout: const Duration(minutes: 10),
      sendTimeout: const Duration(minutes: 10),
      connectTimeout: const Duration(minutes: 10)))
    ..interceptors.addAll([
      ChatGptInterceptor(apiKey),
    ]);

  Dio get imageDio =>
      dio..options.headers.addAll({'Content-Type': 'multipart/form-data'});
}
