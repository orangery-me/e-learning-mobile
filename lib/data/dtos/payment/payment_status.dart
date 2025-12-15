enum PaymentStatus {
  pending,
  failed,
  cancelled,
  refunded,
  success;

  factory PaymentStatus.fromJson(String? raw) =>
      PaymentStatus.values.firstWhere(
        (e) => e.name == raw?.toLowerCase(),
        orElse: () => PaymentStatus.pending,
      );

  String toJson() => name.toUpperCase();
}
