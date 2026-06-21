import 'package:rc0_flutter/core/network/api_response.dart';

PagedResult<T> parsePageData<T>(
  Map<String, dynamic> json,
  T Function(Map<String, dynamic>) fromJsonT,
) {
  return PagedResult.fromJson(json, fromJsonT);
}

List<T> parsePageItems<T>(
  dynamic data,
  T Function(Map<String, dynamic>) fromJsonT,
) {
  if (data is List<dynamic>) {
    return data
        .map((e) => fromJsonT(e as Map<String, dynamic>))
        .toList();
  }
  if (data is Map<String, dynamic>) {
    return parsePageData(data, fromJsonT).items;
  }
  return [];
}
