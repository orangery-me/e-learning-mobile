import 'package:json_annotation/json_annotation.dart';
import 'payment_status.dart';

class PaymentStatusConverter implements JsonConverter<PaymentStatus, String> {
  const PaymentStatusConverter();

  @override
  PaymentStatus fromJson(String json) => PaymentStatus.fromJson(json);

  @override
  String toJson(PaymentStatus object) => object.toJson();
}
