enum OrderStatus {
  pending, // chua thanh toan
  paid,
  failed,
  cancelled,
  refunded,
  delivered;

  factory OrderStatus.fromJson(String? raw) => OrderStatus.values.firstWhere(
        (e) => e.name == raw,
        orElse: () => OrderStatus.pending,
      );
}
