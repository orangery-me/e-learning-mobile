import 'package:e_learning_mobile/data/datasources/video_events/remote/video_events_remote_datasource.dart';
import 'package:e_learning_mobile/data/dtos/video_event/video_event.dart';
import 'package:injectable/injectable.dart';

@singleton
class VideoEventsDatasource {
  final VideoEventsRemoteDatasource _remoteDatasource;

  VideoEventsDatasource({required VideoEventsRemoteDatasource remoteDatasource})
      : _remoteDatasource = remoteDatasource;

  Future<List<VideoEvent>> fetchVideoEventsByLectureId(String lectureId) {
    return _remoteDatasource.fetchVideoEventsByLectureId(lectureId);
  }
}
