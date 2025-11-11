import 'package:e_learning_mobile/common/extensions/context_extension.dart';
import 'package:e_learning_mobile/common/utils/format_util.dart';
import 'package:e_learning_mobile/data/dtos/order/order_response_dto.dart';
import 'package:e_learning_mobile/di/di.dart';
import 'package:e_learning_mobile/presentation/payment/bloc/order/order_bloc.dart';
import 'package:e_learning_mobile/presentation/payment/views/order_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderPage extends StatelessWidget {
  final OrderEvent? initialEvent;
  const OrderPage({super.key, this.initialEvent});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = getIt<OrderBloc>();
        final ev = initialEvent;
        if (ev != null) bloc.add(ev);
        return bloc;
      },
      child: const OrderView(),
    );
  }
}

class OrderView extends StatefulWidget {
  const OrderView({super.key});

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  // Status keys map to API/enum names (lowercase)
  static const List<String> _statusKeys = <String>[
    'pending',
    'failed',
    'cancelled',
    'delivered',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _statusKeys.length, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      _dispatchForIndex(_tabController.index);
    });

    _scrollController.addListener(_onScroll);

    // Ensure we show something when navigating directly (not from cart)
    // Load pending orders by default (first tab)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<OrderBloc>();
      if (bloc.state is OrderInitial) {
        bloc.add(LoadOrdersByStatus(_statusKeys[0], page: 0, size: 10));
      }
    });
  }

  void _dispatchForIndex(int index) {
    final bloc = context.read<OrderBloc>();
    final status = _statusKeys[index];
    bloc.add(LoadOrdersByStatus(status, page: 0, size: 10));
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= maxScroll - 200) {
      final s = context.read<OrderBloc>().state;
      if (s is OrdersLoaded && s.hasMore && !s.isAppending) {
        final nextPage = s.page + 1;
        if (s.statusFilter == null) {
          context
              .read<OrderBloc>()
              .add(LoadOrders(page: nextPage, size: 10, append: true));
        } else {
          context.read<OrderBloc>().add(LoadOrdersByStatus(s.statusFilter!,
              page: nextPage, size: 10, append: true));
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Orders'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: context.palette.buttonBackground,
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: context.palette.buttonBackground,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Failed'),
            Tab(text: 'Cancelled'),
            Tab(text: 'Delivered'),
          ],
        ),
      ),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is OrderLoading || state is OrderInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is OrderError) {
            return _ErrorPane(
              message: state.message,
              onRetry: () => _dispatchForIndex(_tabController.index),
            );
          }

          if (state is OrdersLoaded) {
            final orders = state.orders;
            if (orders.isEmpty) {
              return const Center(child: Text('No orders'));
            }
            return Stack(
              children: [
                _OrdersList(
                  orders: orders,
                  controller: _scrollController,
                ),
                if (state.isAppending)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: context.palette.buttonBackground,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

class _ErrorPane extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorPane({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 12),
            Text(
              'Failed to create order',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrdersList extends StatelessWidget {
  final List<OrderResponse> orders;
  final ScrollController? controller;

  const _OrdersList({required this.orders, this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: controller,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final order = orders[index];
        final firstCourseImage =
            order.items.isNotEmpty ? order.items[0].courseImage : null;
        return ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          leading: firstCourseImage != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    firstCourseImage,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.receipt_long,
                          color: context.palette.buttonBackground,
                        ),
                      );
                    },
                  ),
                )
              : CircleAvatar(
                  backgroundColor: Colors.blue[50],
                  foregroundColor: context.palette.buttonBackground,
                  child: const Icon(Icons.receipt_long),
                ),
          title: Text(
            '#${order.orderNumber}',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 2),
              Row(
                children: [
                  Text(
                    'Total: ',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    FormatUtil.formatNumberAsCurrency(
                      order.finalAmount,
                      symbol: '₫',
                    ),
                    style: TextStyle(
                      color: context.palette.buttonBackground,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              if (order.createdAt != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Created: ${FormatUtil.formatDateTime(order.createdAt!)}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ],
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Text(order.status.name),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => OrderDetailPage(orderId: order.id),
              ),
            );
          },
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemCount: orders.length,
    );
  }
}
