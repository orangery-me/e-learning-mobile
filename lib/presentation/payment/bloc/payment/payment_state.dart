part of 'payment_bloc.dart';

sealed class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

final class PaymentInitial extends PaymentState {}

final class PaymentLoading extends PaymentState {}

final class PaymentsLoaded extends PaymentState {
  final List<PaymentResponseDto> payments;
  final int page;
  final int totalPages;
  final bool hasMore;
  final bool isAppending;

  const PaymentsLoaded({
    required this.payments,
    required this.page,
    required this.totalPages,
    required this.hasMore,
    this.isAppending = false,
  });

  PaymentsLoaded copyWith({
    List<PaymentResponseDto>? payments,
    int? page,
    int? totalPages,
    bool? hasMore,
    bool? isAppending,
  }) =>
      PaymentsLoaded(
        payments: payments ?? this.payments,
        page: page ?? this.page,
        totalPages: totalPages ?? this.totalPages,
        hasMore: hasMore ?? this.hasMore,
        isAppending: isAppending ?? this.isAppending,
      );

  @override
  List<Object> get props => [payments, page, totalPages, hasMore, isAppending];
}

final class PaymentLoaded extends PaymentState {
  final PaymentResponseDto payment;
  const PaymentLoaded(this.payment);

  @override
  List<Object> get props => [payment];
}

final class PaymentActionSuccess extends PaymentState {
  final PaymentResponseDto payment;
  const PaymentActionSuccess(this.payment);

  @override
  List<Object> get props => [payment];
}

final class PaymentError extends PaymentState {
  final String message;
  const PaymentError(this.message);

  @override
  List<Object> get props => [message];
}
