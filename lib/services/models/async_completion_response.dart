
import 'package:json_annotation/json_annotation.dart';

import 'async_choice_response.dart';
import 'usage_response.dart';

part 'async_completion_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AsyncCompletionResponse {
  final String? id;
  final String? object;
  final int? created;
  final String? model;
  final UsageResponse? usage;
  final List<AsyncChoiceResponse>? choices;

  AsyncCompletionResponse({
    this.id,
    this.object,
    this.created,
    this.model,
    this.usage,
    this.choices,
  });

  factory AsyncCompletionResponse.fromJson(Map<String, dynamic> data) =>
      _$AsyncCompletionResponseFromJson(data);

  Map<String, dynamic> toJson() => _$AsyncCompletionResponseToJson(this);
}
