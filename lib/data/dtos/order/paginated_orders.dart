import 'order_response_dto.dart';

class PaginatedOrders {
  final List<OrderResponse> content;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final int totalElements;
  final bool last;
  final bool first;
  final int numberOfElements;
  final bool empty;

  PaginatedOrders({
    required this.content,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.totalElements,
    required this.last,
    required this.first,
    required this.numberOfElements,
    required this.empty,
  });

  factory PaginatedOrders.fromResponseData(Map<String, dynamic> data) {
    final contentList = (data['content'] as List? ?? const [])
        .map((e) => OrderResponse.fromJson(e as Map<String, dynamic>))
        .toList();
    return PaginatedOrders(
      content: contentList,
      pageNumber: (data['number'] as num? ?? 0).toInt(),
      pageSize: (data['size'] as num? ?? contentList.length).toInt(),
      totalPages: (data['totalPages'] as num? ?? 1).toInt(),
      totalElements:
          (data['totalElements'] as num? ?? contentList.length).toInt(),
      last: data['last'] as bool? ?? true,
      first: data['first'] as bool? ?? true,
      numberOfElements:
          (data['numberOfElements'] as num? ?? contentList.length).toInt(),
      empty: data['empty'] as bool? ?? contentList.isEmpty,
    );
  }
}
