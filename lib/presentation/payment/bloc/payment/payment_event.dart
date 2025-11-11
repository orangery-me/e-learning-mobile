part of 'payment_bloc.dart';

sealed class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class CreatePayment extends PaymentEvent {
  final CreatePaymentRequest request;

  const CreatePayment(this.request);

  @override
  List<Object> get props => [request];
}

class GetPaymentByOrderCode extends PaymentEvent {
  final String orderCode;

  const GetPaymentByOrderCode(this.orderCode);

  @override
  List<Object> get props => [orderCode];
}

class LoadUserPayments extends PaymentEvent {
  final int page;
  final int size;
  final bool append;

  const LoadUserPayments({this.page = 0, this.size = 10, this.append = false});

  @override
  List<Object> get props => [page, size, append];
}

class CancelPayment extends PaymentEvent {
  final String orderCode;

  const CancelPayment(this.orderCode);

  @override
  List<Object> get props => [orderCode];
}
