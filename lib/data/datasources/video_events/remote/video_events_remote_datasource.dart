import 'dart:developer';

import 'package:e_learning_mobile/common/constants/endpoints.dart';
import 'package:e_learning_mobile/common/helpers/dio_helper.dart';
import 'package:e_learning_mobile/data/dtos/video_event/video_event.dart';
import 'package:injectable/injectable.dart';

@singleton
class VideoEventsRemoteDatasource {
  final DioHelper _dioHelper;
  VideoEventsRemoteDatasource({required DioHelper dioHelper})
      : _dioHelper = dioHelper;

  Future<List<VideoEvent>> fetchVideoEventsByLectureId(String lectureId) async {
    final response =
        await _dioHelper.get('${Endpoints.videoEvents}/lecture/$lectureId');

    log('Fetched video events data: $response');
    final List<dynamic> data = response.data['data'];

    return data
        .map((json) => VideoEvent.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
