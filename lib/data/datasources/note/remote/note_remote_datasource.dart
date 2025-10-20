import 'dart:developer';

import 'package:e_learning_mobile/common/constants/endpoints.dart';
import 'package:e_learning_mobile/common/helpers/dio_helper.dart';
import 'package:e_learning_mobile/data/dtos/notes/note_request_dto.dart';
import 'package:e_learning_mobile/data/dtos/notes/note_response_dto.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class NoteRemoteDatasource {
  final DioHelper _dioHelper;

  NoteRemoteDatasource({required DioHelper dioHelper}) : _dioHelper = dioHelper;

  Future<List<NoteResponseDto>> getAllNotes(String lectureId) async {
    final response =
        await _dioHelper.get('${Endpoints.lectures}/$lectureId/notes');
    final List<dynamic> jsonList = response.data['data'] ?? response.data;
    log('abc: ${jsonList.toString()}');
    return jsonList.map((e) => NoteResponseDto.fromJson(e)).toList();
  }

  Future<NoteResponseDto> createNote(NoteCreateRequestDto dto) async {
    log('Creating note with data: ${dto.toJson()}');
    final response = await _dioHelper.post(
      '${Endpoints.lectures}/${dto.lectureId}/notes',
      data: dto.toJson(),
    );
    return NoteResponseDto.fromJson(response.data['data'] ?? response.data);
  }

  Future<NoteResponseDto> getNoteById(String noteId) async {
    final response =
        await _dioHelper.get('${Endpoints.lectures}/notes/$noteId');
    return NoteResponseDto.fromJson(response.data['data'] ?? response.data);
  }

  Future<NoteResponseDto> updateNote(
      String noteId, NoteUpdateRequestDto dto) async {
    final response = await _dioHelper.put(
      '${Endpoints.lectures}/notes/$noteId',
      data: dto.toJson(),
    );
    return NoteResponseDto.fromJson(response.data['data'] ?? response.data);
  }

  Future<void> deleteNote(String noteId) async {
    await _dioHelper.delete('${Endpoints.lectures}/notes/$noteId');
  }
}
