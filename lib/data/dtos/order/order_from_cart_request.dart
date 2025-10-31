class OrderFromCartRequest {
  final bool clearCartAfterOrder;
  final String? notes;

  OrderFromCartRequest({
    required this.clearCartAfterOrder,
    this.notes,
  });
  Map<String, dynamic> toJson() {
    return {
      'clearCartAfterOrder': clearCartAfterOrder,
      'notes': notes,
    };
  }
}
