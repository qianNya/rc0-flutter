import 'package:rc0_flutter/core/error/app_exception.dart';

class ApiResponse<T> {
  const ApiResponse({
    required this.code,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromJsonT,
  ) {
    final rawData = json['data'];
    return ApiResponse(
      code: json['code'] as int? ?? -1,
      message: json['message'] as String? ?? '',
      data: fromJsonT != null && rawData != null ? fromJsonT(rawData) : rawData as T?,
    );
  }

  final int code;
  final String message;
  final T? data;

  bool get isSuccess => code == 0;

  T requireData() {
    if (!isSuccess) {
      throw ApiException(message.isNotEmpty ? message : 'API error ($code)');
    }
    if (data == null) {
      throw const ApiException('Empty response data');
    }
    return data as T;
  }
}

class PagedResult<T> {
  const PagedResult({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.total,
  });

  factory PagedResult.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    return PagedResult(
      items: rawItems
          .map((e) => fromJsonT(e as Map<String, dynamic>))
          .toList(),
      page: json['page'] as int? ?? 1,
      pageSize: json['page_size'] as int? ?? rawItems.length,
      total: json['total'] as int? ?? rawItems.length,
    );
  }

  final List<T> items;
  final int page;
  final int pageSize;
  final int total;

  bool get hasMore => page * pageSize < total;
}
