import 'package:e_learning_mobile/data/datasources/quizz/remote/quizz_remote_datasource.dart';
import 'package:e_learning_mobile/data/dtos/quizz/quizz_overview_dto.dart';
import 'package:e_learning_mobile/data/dtos/quizz/quizz_result_dto.dart';
import 'package:e_learning_mobile/data/dtos/quizz/quizz_submit_dto.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class QuizzDatasource {
  final QuizzRemoteDatasource _remoteDatasource;

  QuizzDatasource({required QuizzRemoteDatasource remoteDatasource})
      : _remoteDatasource = remoteDatasource;

  Future<QuizzOverviewDto> getQuizzByLectureId(String lectureId) async {
    return _remoteDatasource.getQuizzByLectureId(lectureId);
  }

  Future<QuizzOverviewDto> getQuizzById(String quizzId) async {
    return _remoteDatasource.getQuizzById(quizzId);
  }

  Future<QuizzResultDto> submitQuizzAnswers(QuizzSubmit submit) async {
    return _remoteDatasource.submitQuizzAnswers(submit);
  }
}
