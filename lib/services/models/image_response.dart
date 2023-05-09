
import 'package:json_annotation/json_annotation.dart';
import 'package:one_crore_project/services/models/url_response.dart';

part 'image_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ImageResponse {
  final int? created;
  final List<UrlResponse>? data;

  ImageResponse({this.created, this.data});

  factory ImageResponse.fromJson(Map<String, dynamic> data) =>
      _$ImageResponseFromJson(data);

  Map<String, dynamic> toJson() => _$ImageResponseToJson(this);
}
