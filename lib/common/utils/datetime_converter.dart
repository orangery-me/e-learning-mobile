import 'package:json_annotation/json_annotation.dart';

class DateTimeTimestampConverter implements JsonConverter<DateTime, int> {
  const DateTimeTimestampConverter();

  @override
  DateTime fromJson(int json) => DateTime.fromMillisecondsSinceEpoch(json);

  // Chuyển đổi từ DateTime sang int
  @override
  int toJson(DateTime object) => object.millisecondsSinceEpoch;
}

class VideoPositionConverter implements JsonConverter<Duration, int> {
  const VideoPositionConverter();

  @override
  Duration fromJson(int json) => Duration(milliseconds: json);

  @override
  int toJson(Duration object) => object.inMilliseconds;
}

class UNIXTimestampConverter implements JsonConverter<DateTime, num> {
  const UNIXTimestampConverter();

  @override
  DateTime fromJson(num timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(
      (timestamp * 1000).toInt(),
      isUtc: true,
    );
  }

  @override
  num toJson(DateTime date) {
    return date.millisecondsSinceEpoch / 1000;
  }
}
