part of 'chat_bloc.dart';

class ChatMessage extends Equatable {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  @override
  List<Object> get props => [text, isUser, timestamp];
}

class ChatState extends Equatable {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? errorMessage;
  final bool isEnded;

  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.errorMessage,
    this.isEnded = false,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? errorMessage,
    bool? isEnded,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isEnded: isEnded ?? this.isEnded,
    );
  }

  @override
  List<Object?> get props => [messages, isLoading, errorMessage, isEnded];
}
