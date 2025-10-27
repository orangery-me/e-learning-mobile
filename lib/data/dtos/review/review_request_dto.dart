import 'package:json_annotation/json_annotation.dart';
part 'review_request_dto.g.dart';

@JsonSerializable()
class ReviewRequestDto {
  final String comment;
  final int rating;
  ReviewRequestDto({
    required this.comment,
    required this.rating,
  });
  Map<String, dynamic> toJson() => _$ReviewRequestDtoToJson(this);
}
