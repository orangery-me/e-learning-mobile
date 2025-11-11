enum PaymentStatus {
  pending,
  paid,
  failed,
  cancelled,
  refunded;

  factory PaymentStatus.fromJson(String? raw) =>
      PaymentStatus.values.firstWhere(
        (e) => e.name == raw?.toLowerCase(),
        orElse: () => PaymentStatus.pending,
      );

  String toJson() => name.toUpperCase();
}
