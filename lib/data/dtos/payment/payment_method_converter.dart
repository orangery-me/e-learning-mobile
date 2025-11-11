import 'package:json_annotation/json_annotation.dart';
import 'payment_method.dart';

class PaymentMethodConverter implements JsonConverter<PaymentMethod, String> {
  const PaymentMethodConverter();

  @override
  PaymentMethod fromJson(String json) => PaymentMethod.fromJson(json);

  @override
  String toJson(PaymentMethod object) => object.toJson();
}
