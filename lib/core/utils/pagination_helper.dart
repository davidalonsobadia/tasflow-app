import 'package:dio/dio.dart';

class PaginationHelper<T> {
  final int pageSize;
  final Future<Response> Function(Map<String, dynamic> params) apiCall;
  final T Function(dynamic json) fromJson;

  PaginationHelper({this.pageSize = 50, required this.apiCall, required this.fromJson});

  Future<List<T>> fetchAllPages({
    required Map<String, dynamic> baseParams,
    String? filterQuery,
    Function(int loaded, int total)? onProgressUpdate,
  }) async {
    final List<T> allItems = [];
    int currentPage = 0;
    bool hasMoreData = true;

    // First get the total count
    final countParams = Map<String, dynamic>.from(baseParams);
    countParams["\$count"] = "true";
    countParams["\$top"] = 0;
    final countResponse = await apiCall(countParams);
    final totalCount = countResponse.data['@odata.count'] as int;

    final queryParams = Map<String, dynamic>.from(baseParams);
    if (filterQuery != null) {
      queryParams["\$filter"] = filterQuery;
    }

    while (hasMoreData) {
      queryParams["\$skip"] = currentPage * pageSize;
      queryParams["\$top"] = pageSize;

      final response = await apiCall(queryParams);
      final items = (response.data['value'] as List).map((item) => fromJson(item)).toList();

      allItems.addAll(items);

      // Report progress
      if (onProgressUpdate != null) {
        onProgressUpdate(allItems.length, totalCount);
      }

      hasMoreData = items.length == pageSize;
      currentPage++;
    }

    return allItems;
  }
}
