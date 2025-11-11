enum PaymentMethod {
  payos,
  vnpay,
  momo,
  zalopay,
  bankTransfer;

  factory PaymentMethod.fromJson(String? raw) =>
      PaymentMethod.values.firstWhere(
        (e) => e.name == raw?.toLowerCase(),
        orElse: () => PaymentMethod.payos,
      );

  String toJson() => name.toUpperCase();
}
