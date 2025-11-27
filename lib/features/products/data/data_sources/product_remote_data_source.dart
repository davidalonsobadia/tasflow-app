import 'package:dio/dio.dart';
import 'package:taskflow_app/core/network/api_client_dio.dart';
import 'package:taskflow_app/core/network/endpoints.dart';
import 'package:taskflow_app/core/network/exceptions.dart';
import 'package:taskflow_app/core/utils/paged_result.dart';
import 'package:taskflow_app/features/products/data/models/location_model.dart';
import 'package:taskflow_app/features/products/data/models/product_model.dart';
import 'package:taskflow_app/features/products/data/models/product_task_model.dart';
import 'package:taskflow_app/core/utils/pagination_helper.dart';
import 'package:taskflow_app/features/products/data/models/transfer_line_model.dart';
import 'package:taskflow_app/features/products/data/models/transfer_receipt_line_model.dart';
import 'package:flutter_translate/flutter_translate.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getAllProducts({
    Function(int loaded, int total)? onProgressUpdate,
  });
  Future<List<ProductModel>> getProducts(String locationCode);
  Future<int> getProductsCount();
  Future<ProductModel> getProductById(String productId);
  Future<ProductModel> getProductBySystemId(String systemId);
  Future<List<ProductTaskModel>> getProductTasks(String taskId);
  Future<void> addProduct(ProductTaskModel product);
  Future<void> deleteProductTask(String systemId);
  Future<int> getProductTasksCount(String taskId);
  Future<List<LocationModel>> getLocations(String taskLocationCode);
  Future<String> createTransferHeader(
    String transferFromCode,
    String transferToCode,
    String taskId,
    String licensePlate,
  );
  Future<void> createTransferLine(TransferLineModel transferLine);
  Future<List<TransferReceiptLineModel>> getTransferReceiptLines(String taskId);
  Future<TransferReceiptLineModel?> getTransferReceiptLine(
    String taskId,
    String productId,
  );
  Future<List<TransferLineModel>> getTransferLines(String taskId);

  // New paginated + search endpoint
  Future<PagedResult<ProductModel>> getProductsPage({
    required int skip,
    required int top,
    String? searchQuery,
    CancelToken? cancelToken,
  });
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final DioApiClient apiClient;
  CancelToken? _currentProductsRequest;

  ProductRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<ProductModel>> getAllProducts({
    Function(int loaded, int total)? onProgressUpdate,
  }) async {
    final paginationHelper = PaginationHelper<ProductModel>(
      apiCall:
          (params) => apiClient.get(Endpoints.productsEndpoint, params: params),
      fromJson: (json) => ProductModel.fromJson(json),
      pageSize: 1000,
    );

    final baseParams = {
      "\$select":
          "no,systemId,description,searchDescription,baseUnitOfMeasure,inventory,locations,inventoryPostingGroup,vendorName,type",
    };

    try {
      return await paginationHelper.fetchAllPages(
        baseParams: baseParams,
        onProgressUpdate: onProgressUpdate,
      );
    } catch (e) {
      if (e is DioException) {
        throw ServerException(translate('failedToLoadProducts'), e.response);
      }
      throw ValidationException(translate('invalidProductDataFormat'), e);
    }
  }

  @override
  Future<List<ProductTaskModel>> getProductTasks(String taskId) async {
    final paginationHelper = PaginationHelper<ProductTaskModel>(
      apiCall:
          (params) =>
              apiClient.get(Endpoints.productsInTaskEndpoint, params: params),
      fromJson: (json) => ProductTaskModel.fromJson(json),
    );

    final baseParams = {
      "\$select":
          "no,documentNo,serviceItemNo,serviceItemLineNo,lineNo,description,unitOfMeasure,quantity,type,locationCode,systemId",
    };

    try {
      return await paginationHelper.fetchAllPages(
        baseParams: baseParams,
        filterQuery: "documentNo eq '$taskId'",
      );
    } catch (e) {
      print('Error getting product tasks: ${e.toString()}');
      if (e is DioException) {
        rethrow;
      }
      throw ValidationException(translate('invalidProductDataFormat'), e);
    }
  }

  @override
  Future<List<ProductModel>> getProducts(String locationCode) async {
    final paginationHelper = PaginationHelper<ProductModel>(
      apiCall:
          (params) => apiClient.get(Endpoints.productsEndpoint, params: params),
      fromJson: (json) => ProductModel.fromJson(json),
    );

    final baseParams = {
      "\$select":
          "no,systemId,description,searchDescription,baseUnitOfMeasure,inventory,locations,inventoryPostingGroup,vendorName,type",
    };

    try {
      return await paginationHelper.fetchAllPages(baseParams: baseParams);
    } catch (e) {
      if (e is DioException) {
        rethrow;
      }
      throw ValidationException(translate('invalidProductDataFormat'), e);
    }
  }

  @override
  Future<int> getProductsCount() async {
    final queryParams = Map<String, dynamic>.from({
      "\$count": "true",
      "\$top": 0,
    });
    try {
      final response = await apiClient.get(
        Endpoints.productsEndpoint,
        params: queryParams,
      );
      if (response.statusCode != 200) {
        throw ServerException("Failed to get products", response);
      }
      return response.data['@odata.count'];
    } catch (e) {
      if (e is DioException) {
        throw ServerException(translate('failedToLoadProducts'), e.response);
      }
      throw ValidationException(translate('invalidProductDataFormat'), e);
    }
  }

  @override
  Future<void> addProduct(ProductTaskModel productTask) async {
    final response = await apiClient.post(
      Endpoints.productsInTaskEndpoint,
      data: productTask.toJson(),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw ServerException(translate('failedToAddProduct'), response);
    }
  }

  @override
  Future<void> deleteProductTask(String systemId) async {
    String deleteParam = '($systemId)';
    final response = await apiClient.delete(
      Endpoints.productsInTaskEndpoint + deleteParam,
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw ServerException(translate('failedToDeleteProduct'), response);
    }
  }

  @override
  Future<ProductModel> getProductById(String productId) async {
    final queryParams = {
      "\$select":
          "no,systemId,description,searchDescription,baseUnitOfMeasure,inventory,locations,inventoryPostingGroup,vendorName,type",
      "\$filter": "no eq '$productId'",
    };
    final response = await apiClient.get(
      Endpoints.productsEndpoint,
      params: queryParams,
    );
    if (response.statusCode != 200) {
      throw ServerException(translate('failedToLoadProducts'), response);
    }
    final values = response.data['value'];
    if (values == null || values is! List || values.isEmpty) {
      throw ValidationException(translate('productNotFound'), response);
    }
    return ProductModel.fromJson(values[0]);
  }

  @override
  Future<ProductModel> getProductBySystemId(String systemId) async {
    final selectFields = {
      "\$select":
          "no,systemId,description,searchDescription,baseUnitOfMeasure,inventory,locations,inventoryPostingGroup,vendorName,type",
    };
    final response = await apiClient.get(
      '${Endpoints.productsEndpoint}($systemId)',
      params: selectFields,
    );
    if (response.statusCode != 200) {
      throw ServerException(translate('failedToLoadProducts'), response);
    }
    return ProductModel.fromJson(response.data);
  }

  @override
  Future<int> getProductTasksCount(String taskId) async {
    final queryParams = Map<String, dynamic>.from({
      "\$count": "true",
      "\$top": 0,
      "\$filter": "documentNo eq '$taskId'",
    });
    try {
      final response = await apiClient.get(
        Endpoints.productsInTaskEndpoint,
        params: queryParams,
      );
      if (response.statusCode != 200) {
        throw ServerException("Failed to get product tasks count", response);
      }
      return response.data['@odata.count'];
    } catch (e) {
      if (e is DioException) {
        throw ServerException(translate('failedToLoadProducts'), e.response);
      }
      throw ValidationException(translate('invalidProductDataFormat'), e);
    }
  }

  @override
  Future<List<LocationModel>> getLocations(String taskLocationCode) async {
    final queryParams = {
      "\$select": "code,name,consumptionLocationCode,doTransferOrders",
      "\$filter": "code eq '$taskLocationCode'",
    };

    try {
      final response = await apiClient.get(
        Endpoints.locationsEndpoint,
        params: queryParams,
      );
      if (response.statusCode != 200) {
        throw ServerException("Failed to get locations", response);
      }
      final locationsData = response.data['value'] as List<dynamic>;
      return locationsData
          .map(
            (locationData) =>
                LocationModel.fromJson(locationData as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      if (e is DioException) {
        throw ServerException(translate('failedToLoadLocations'), e.response);
      }
      throw ValidationException(translate('invalidLocationDataFormat'), e);
    }
  }

  @override
  Future<String> createTransferHeader(
    String transferFromCode,
    String transferToCode,
    String taskId,
    String licensePlate,
  ) async {
    final data = {
      'transferFromCode': transferFromCode,
      'transferToCode': transferToCode,
      'licensePlate': licensePlate,
      'externalDocumentNo': taskId,
    };

    try {
      final response = await apiClient.post(
        Endpoints.transferHeadersEndpoint,
        data: data,
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(
          translate('failedToCreateTransferHeader'),
          response,
        );
      }
      return response.data['no'];
    } catch (e) {
      if (e is DioException) {
        throw ServerException(
          translate('failedToCreateTransferHeader'),
          e.response,
        );
      }
      throw ValidationException(translate('invalidTransferHeaderFormat'), e);
    }
  }

  @override
  Future<void> createTransferLine(TransferLineModel transferLine) async {
    final data = transferLine.toJson();

    try {
      final response = await apiClient.post(
        Endpoints.transferLinesEndpoint,
        data: data,
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(
          translate('failedToCreateTransferLine'),
          response,
        );
      }
    } catch (e) {
      if (e is DioException) {
        throw ServerException(
          translate('failedToCreateTransferLine'),
          e.response,
        );
      }
      throw ValidationException(translate('invalidTransferLineFormat'), e);
    }
  }

  @override
  Future<List<TransferReceiptLineModel>> getTransferReceiptLines(
    String serviceOrderNo,
  ) async {
    final paginationHelper = PaginationHelper<TransferReceiptLineModel>(
      apiCall:
          (params) => apiClient.get(
            Endpoints.transferReceiptLinesEndpoint,
            params: params,
          ),
      fromJson: (json) => TransferReceiptLineModel.fromJson(json),
    );

    final baseParams = {
      "\$select": "documentNo,itemNo,quantity,quantityReceived,serviceOrderNo",
    };

    try {
      return await paginationHelper.fetchAllPages(
        baseParams: baseParams,
        filterQuery: "serviceOrderNo eq '$serviceOrderNo'",
      );
    } catch (e) {
      if (e is DioException) {
        throw ServerException(
          translate('failedToLoadTransferReceipts'),
          e.response,
        );
      }
      throw ValidationException(translate('invalidTransferReceiptFormat'), e);
    }
  }

  @override
  Future<TransferReceiptLineModel?> getTransferReceiptLine(
    String taskId,
    String productId,
  ) async {
    final queryParams = {
      "\$select":
          "documentNo,itemNo,transferFromCode,transferToCode,serviceOrderNo",
      "\$filter": "serviceOrderNo eq '$taskId' and itemNo eq '$productId'",
    };

    try {
      final response = await apiClient.get(
        Endpoints.transferReceiptLinesEndpoint,
        params: queryParams,
      );
      if (response.statusCode != 200) {
        throw ServerException(
          translate('failedToLoadTransferReceipts'),
          response,
        );
      }
      if (response.data['value'] == null || response.data['value'].isEmpty) {
        return null;
      }
      final receiptLineData = response.data['value'][0];
      return TransferReceiptLineModel.fromJson(receiptLineData);
    } catch (e) {
      if (e is DioException) {
        throw ServerException(
          translate('failedToLoadTransferReceipts'),
          e.response,
        );
      }
      throw ValidationException(translate('invalidTransferReceiptFormat'), e);
    }
  }

  @override
  Future<List<TransferLineModel>> getTransferLines(String taskId) async {
    final paginationHelper = PaginationHelper<TransferLineModel>(
      apiCall:
          (params) =>
              apiClient.get(Endpoints.transferLinesEndpoint, params: params),
      fromJson: (json) => TransferLineModel.fromJson(json),
    );

    final baseParams = {
      "\$select": "documentNo,itemNo,quantity,quantityReceived,serviceOrderNo",
    };

    try {
      return await paginationHelper.fetchAllPages(
        baseParams: baseParams,
        filterQuery: "serviceOrderNo eq '$taskId'",
      );
    } catch (e) {
      if (e is DioException) {
        throw ServerException(
          translate('failedToLoadTransferLines'),
          e.response,
        );
      }
      throw ValidationException(translate('invalidTransferLineFormat'), e);
    }
  }

  @override
  Future<PagedResult<ProductModel>> getProductsPage({
    required int skip,
    required int top,
    String? searchQuery,
    CancelToken? cancelToken,
  }) async {
    // Cancel ongoing request if any when not explicitly provided a token
    if (cancelToken == null) {
      _currentProductsRequest?.cancel("New products request");
      _currentProductsRequest = CancelToken();
    }

    final params = <String, dynamic>{
      "\$select":
          "no,systemId,description,searchDescription,baseUnitOfMeasure,inventory,locations,inventoryPostingGroup,vendorName,type",
      "\$skip": skip,
      "\$top": top,
      "\$count": "true",
      "\$schemaversion": "2.1",
    };

    // OData filter: contains on description or searchDescription
    if (searchQuery != null && searchQuery.trim().length >= 3) {
      final q = searchQuery.replaceAll("'", "''");
      params["\$filter"] = "contains(tolower(description),tolower('$q'))";
    }

    try {
      final response = await apiClient.get(
        Endpoints.productsEndpoint,
        params: params,
        cancelToken: cancelToken ?? _currentProductsRequest,
      );
      if (response.statusCode != 200) {
        throw ServerException(translate('failedToLoadProducts'), response);
      }
      final List<ProductModel> items =
          (response.data['value'] as List)
              .map((json) => ProductModel.fromJson(json))
              .toList();
      final int totalCount =
          response.data['@odata.count'] as int? ?? items.length;
      return PagedResult<ProductModel>(
        items: items,
        totalCount: totalCount,
        skip: skip,
        top: top,
      );
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.cancel) {
          // No-op for cancellations; helpful debug print
          // ignore: avoid_print
          print('getProductsPage cancelled: \'${e.message}\'');
          // Re-throw so upper layers that explicitly expect cancellation can handle it silently
          rethrow;
        }
        throw ServerException(translate('failedToLoadProducts'), e.response);
      }
      throw ValidationException(translate('invalidProductDataFormat'), e);
    }
  }
}
