import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:e_learning_mobile/data/datasources/chat/chat_datasource.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'chat_event.dart';
part 'chat_state.dart';

@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatDatasource _chatDatasource;

  ChatBloc({required ChatDatasource chatDatasource})
      : _chatDatasource = chatDatasource,
        super(const ChatState()) {
    on<SendMessage>(_onSendMessage);
    on<EndChat>(_onEndChat);
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    // Add user message immediately
    final userMessage = ChatMessage(
      text: event.message,
      isUser: true,
      timestamp: DateTime.now(),
    );
    emit(state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
    ));

    try {
      // Call API
      final response = await _chatDatasource.sendMessage(event.message);

      // Add bot response
      final botMessage = ChatMessage(
        text: response.answer,
        isUser: false,
        timestamp: DateTime.now(),
      );

      emit(state.copyWith(
        messages: [...state.messages, botMessage],
        isLoading: false,
      ));
    } catch (e) {
      log('Error sending message: $e');
      // Add error message
      final errorMessage = ChatMessage(
        text: 'Sorry, I encountered an error. Please try again.',
        isUser: false,
        timestamp: DateTime.now(),
      );

      emit(state.copyWith(
        messages: [...state.messages, errorMessage],
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onEndChat(EndChat event, Emitter<ChatState> emit) {
    emit(const ChatState());
  }
}
