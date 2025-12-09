import 'package:json_annotation/json_annotation.dart';

class ChatBotResponseDto {
  final String answer;
  @JsonKey(name: 'context_used')
  final List<String>? contextUsed;
  ChatBotResponseDto({
    required this.answer,
    required this.contextUsed,
  });

  factory ChatBotResponseDto.fromJson(Map<String, dynamic> json) {
    return ChatBotResponseDto(
      answer: json['answer'] as String,
      contextUsed: json['context_used'] != null
          ? List<String>.from(json['context_used'] as List)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'answer': answer,
      'context_used': contextUsed,
    };
  }
}
