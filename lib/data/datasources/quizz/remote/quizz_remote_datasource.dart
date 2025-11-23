import 'dart:developer';

import 'package:e_learning_mobile/common/constants/endpoints.dart';
import 'package:e_learning_mobile/common/helpers/dio_helper.dart';
import 'package:e_learning_mobile/data/dtos/quizz/quizz_overview_dto.dart';
import 'package:e_learning_mobile/data/dtos/quizz/quizz_result_dto.dart';
import 'package:e_learning_mobile/data/dtos/quizz/quizz_submit_dto.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class QuizzRemoteDatasource {
  final DioHelper _dioHelper;

  QuizzRemoteDatasource({required DioHelper dioHelper})
      : _dioHelper = dioHelper;

  Future<QuizzOverviewDto> getQuizzByLectureId(String lectureId) async {
    final response =
        await _dioHelper.get('${Endpoints.quizzes}/lecture/$lectureId');
    log('QuizzRemoteDatasource - getQuizzByLectureId: $response');

    return QuizzOverviewDto.fromJson(
      (response.data['data'] ?? response.data) as Map<String, dynamic>,
    );
  }

  Future<QuizzOverviewDto> getQuizzById(String quizzId) async {
    final response = await _dioHelper.get('${Endpoints.quizzes}/$quizzId');

    return QuizzOverviewDto.fromJson(
      (response.data['data'] ?? response.data) as Map<String, dynamic>,
    );
  }

  Future<QuizzResultDto> submitQuizzAnswers(QuizzSubmit submit) async {
    final response = await _dioHelper.post(
      '${Endpoints.quizzSubmissions}/submit',
      data: submit.toJson(),
    );

    return QuizzResultDto.fromJson(
      (response.data['data'] ?? response.data) as Map<String, dynamic>,
    );
  }
}
