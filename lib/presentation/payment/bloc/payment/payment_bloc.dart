import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:e_learning_mobile/data/datasources/payment/payment_datasource.dart';
import 'package:e_learning_mobile/data/dtos/payment/create_payment_request.dart';
import 'package:e_learning_mobile/data/dtos/payment/paginated_payments.dart';
import 'package:e_learning_mobile/data/dtos/payment/payment_response_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'payment_event.dart';
part 'payment_state.dart';

@injectable
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentDatasource _paymentDatasource;

  PaymentBloc({required PaymentDatasource paymentDatasource})
      : _paymentDatasource = paymentDatasource,
        super(PaymentInitial()) {
    on<CreatePayment>(_onCreatePayment);
    on<GetPaymentByOrderCode>(_onGetPaymentByOrderCode);
    on<LoadUserPayments>(_onLoadUserPayments);
    on<CancelPayment>(_onCancelPayment);
  }

  Future<void> _onCreatePayment(
      CreatePayment event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    try {
      final payment = await _paymentDatasource.createPayment(event.request);
      emit(PaymentActionSuccess(payment));
    } catch (e) {
      log('Error creating payment: $e');
      emit(PaymentError(e.toString()));
    }
  }

  Future<void> _onGetPaymentByOrderCode(
      GetPaymentByOrderCode event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    try {
      final payment =
          await _paymentDatasource.getPaymentByOrderCode(event.orderCode);
      emit(PaymentLoaded(payment));
    } catch (e) {
      log('Error getting payment by order code: $e');
      emit(PaymentError(e.toString()));
    }
  }

  Future<void> _onLoadUserPayments(
      LoadUserPayments event, Emitter<PaymentState> emit) async {
    try {
      final current = state;
      if (event.append && current is PaymentsLoaded) {
        emit(current.copyWith(isAppending: true));
      } else {
        emit(PaymentLoading());
      }

      final PaginatedPayments pageData = await _paymentDatasource
          .getUserPayments(page: event.page, size: event.size);
      final merged = event.append && current is PaymentsLoaded
          ? [...current.payments, ...pageData.content]
          : pageData.content;
      emit(PaymentsLoaded(
        payments: merged,
        page: pageData.pageNumber,
        totalPages: pageData.totalPages,
        hasMore: pageData.pageNumber + 1 < pageData.totalPages,
        isAppending: false,
      ));
    } catch (e) {
      log('Error loading user payments: $e');
      emit(PaymentError(e.toString()));
    }
  }

  Future<void> _onCancelPayment(
      CancelPayment event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    try {
      final payment = await _paymentDatasource.cancelPayment(event.orderCode);
      emit(PaymentActionSuccess(payment));
    } catch (e) {
      log('Error cancelling payment: $e');
      emit(PaymentError(e.toString()));
    }
  }
}
