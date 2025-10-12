import 'package:json_annotation/json_annotation.dart';

class DateTimeTimestampConverter implements JsonConverter<DateTime, int> {
  const DateTimeTimestampConverter();

  // Chuyển đổi từ int sang DateTime
  @override
  DateTime fromJson(int json) => DateTime.fromMillisecondsSinceEpoch(json);

  // Chuyển đổi từ DateTime sang int
  @override
  int toJson(DateTime object) => object.millisecondsSinceEpoch;
}
