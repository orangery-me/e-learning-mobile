import 'package:e_learning_mobile/common/helpers/dio_helper.dart';
import 'package:e_learning_mobile/data/dtos/chat/chat_bot_response_dto.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ChatDatasource {
  ChatDatasource({required DioHelper dioHelper}) : _dioHelper = dioHelper;
  final DioHelper _dioHelper;

  Future<ChatBotResponseDto> sendMessage(String query) async {
    final response = await _dioHelper
        .get('https://f0a25427fba5.ngrok-free.app/ask?query=$query');

    return ChatBotResponseDto.fromJson(response.data as Map<String, dynamic>);
  }
}
