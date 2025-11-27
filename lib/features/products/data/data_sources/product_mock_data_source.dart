import 'package:dio/dio.dart';
import 'package:taskflow_app/core/network/exceptions.dart';
import 'package:taskflow_app/features/products/data/data_sources/product_remote_data_source.dart';
import 'package:taskflow_app/features/products/data/models/location_model.dart';
import 'package:taskflow_app/features/products/data/models/product_model.dart';
import 'package:taskflow_app/features/products/data/models/product_task_model.dart';
import 'package:taskflow_app/features/products/data/models/transfer_line_model.dart';
import 'package:taskflow_app/features/products/data/models/transfer_receipt_line_model.dart';
import 'package:taskflow_app/core/utils/paged_result.dart';
import 'package:flutter_translate/flutter_translate.dart';

/// Mock implementation of ProductRemoteDataSource for testing without real API
class ProductMockDataSource implements ProductRemoteDataSource {
  final List<Map<String, dynamic>> _mockProducts = [];
  final List<Map<String, dynamic>> _mockProductTasks = [];
  final List<Map<String, dynamic>> _mockLocations = [];
  final List<Map<String, dynamic>> _mockTransferHeaders = [];
  final List<Map<String, dynamic>> _mockTransferLines = [];
  final List<Map<String, dynamic>> _mockTransferReceiptLines = [];

  int _nextProductTaskId = 1;
  int _nextTransferHeaderId = 1;
  int _nextTransferLineId = 1;

  ProductMockDataSource() {
    _initializeMockData();
  }

  void _initializeMockData() {
    // Initialize mock products
    _mockProducts.addAll([
      {
        'no': 'PROD001',
        'systemId': 'sys-prod-001',
        'description': 'Industrial Pump Model A',
        'searchDescription': 'Pump A Industrial',
        'baseUnitOfMeasure': 'PCS',
        'inventory': 25.0,
        'locations': 'LOC001|LOC002',
        'inventoryPostingGroup': 'FINISHED',
        'vendorName': 'Acme Corp',
        'type': 'Inventory',
      },
      {
        'no': 'PROD002',
        'systemId': 'sys-prod-002',
        'description': 'Valve Assembly B',
        'searchDescription': 'Valve B Assembly',
        'baseUnitOfMeasure': 'PCS',
        'inventory': 50.0,
        'locations': 'LOC001',
        'inventoryPostingGroup': 'FINISHED',
        'vendorName': 'TechParts Inc',
        'type': 'Inventory',
      },
      {
        'no': 'PROD003',
        'systemId': 'sys-prod-003',
        'description': 'Pressure Sensor C',
        'searchDescription': 'Sensor C Pressure',
        'baseUnitOfMeasure': 'PCS',
        'inventory': 100.0,
        'locations': 'LOC002',
        'inventoryPostingGroup': 'FINISHED',
        'vendorName': 'SensorTech Ltd',
        'type': 'Inventory',
      },
      {
        'no': 'PROD004',
        'systemId': 'sys-prod-004',
        'description': 'Control Panel D',
        'searchDescription': 'Panel D Control',
        'baseUnitOfMeasure': 'PCS',
        'inventory': 15.0,
        'locations': 'LOC001|LOC002',
        'inventoryPostingGroup': 'FINISHED',
        'vendorName': 'ElectroSystems',
        'type': 'Inventory',
      },
      {
        'no': 'PROD005',
        'systemId': 'sys-prod-005',
        'description': 'Motor Assembly E',
        'searchDescription': 'Motor E Assembly',
        'baseUnitOfMeasure': 'PCS',
        'inventory': 30.0,
        'locations': 'LOC001',
        'inventoryPostingGroup': 'FINISHED',
        'vendorName': 'MotorWorks',
        'type': 'Inventory',
      },
    ]);

    // Initialize mock locations
    _mockLocations.addAll([
      {'code': 'LOC001', 'name': 'Main Warehouse', 'systemId': 'sys-loc-001'},
      {
        'code': 'LOC002',
        'name': 'Secondary Storage',
        'systemId': 'sys-loc-002',
      },
      {
        'code': 'LOC003',
        'name': 'Distribution Center',
        'systemId': 'sys-loc-003',
      },
    ]);

    // Initialize mock product tasks
    _mockProductTasks.addAll([
      {
        'systemId': 'prod-task-001',
        'documentNo': 'TASK001',
        'lineNo': 10000,
        'type': 'Item',
        'no': 'PROD001',
        'description': 'Industrial Pump Model A',
        'quantity': 2.0,
        'unitOfMeasure': 'PCS',
      },
      {
        'systemId': 'prod-task-002',
        'documentNo': 'TASK001',
        'lineNo': 20000,
        'type': 'Item',
        'no': 'PROD002',
        'description': 'Valve Assembly B',
        'quantity': 3.0,
        'unitOfMeasure': 'PCS',
      },
    ]);
  }

  @override
  Future<List<ProductModel>> getAllProducts({
    Function(int loaded, int total)? onProgressUpdate,
  }) async {
    // Simulate network delay and progress updates
    await Future.delayed(const Duration(milliseconds: 500));

    if (onProgressUpdate != null) {
      onProgressUpdate(_mockProducts.length, _mockProducts.length);
    }

    return _mockProducts.map((json) => ProductModel.fromJson(json)).toList();
  }

  @override
  Future<List<ProductModel>> getProducts(String locationCode) async {
    await Future.delayed(const Duration(milliseconds: 600));

    var products = _mockProducts;

    if (locationCode.isNotEmpty) {
      products =
          products
              .where((p) => (p['locations'] as String).contains(locationCode))
              .toList();
    }

    return products.map((json) => ProductModel.fromJson(json)).toList();
  }

  @override
  Future<int> getProductsCount() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockProducts.length;
  }

  @override
  Future<ProductModel> getProductById(String productId) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final product = _mockProducts.where((p) => p['no'] == productId).toList();

    if (product.isEmpty) {
      throw ValidationException(translate('productNotFound'), null);
    }

    return ProductModel.fromJson(product.first);
  }

  @override
  Future<ProductModel> getProductBySystemId(String systemId) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final product =
        _mockProducts.where((p) => p['systemId'] == systemId).toList();

    if (product.isEmpty) {
      throw ServerException(translate('failedToLoadProducts'), null);
    }

    return ProductModel.fromJson(product.first);
  }

  @override
  Future<List<ProductTaskModel>> getProductTasks(String taskId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final tasks =
        _mockProductTasks.where((pt) => pt['documentNo'] == taskId).toList();

    return tasks.map((json) => ProductTaskModel.fromJson(json)).toList();
  }

  @override
  Future<void> addProduct(ProductTaskModel product) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final newProduct = {
      'systemId': 'prod-task-${_nextProductTaskId.toString().padLeft(3, '0')}',
      'documentNo': product.taskId,
      'lineNo': (_mockProductTasks.length + 1) * 10000,
      'type': product.type,
      'no': product.id,
      'description': product.description,
      'quantity': product.quantity,
      'unitOfMeasure': product.unit,
      'locationCode': product.locationCode,
      'serviceItemNo': product.serviceItemNo,
      'serviceItemLineNo': product.serviceItemLineNo,
    };

    _mockProductTasks.add(newProduct);
    _nextProductTaskId++;
  }

  @override
  Future<void> deleteProductTask(String systemId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _mockProductTasks.indexWhere(
      (pt) => pt['systemId'] == systemId,
    );

    if (index == -1) {
      throw ServerException(translate('failedToDeleteProduct'), null);
    }

    _mockProductTasks.removeAt(index);
  }

  @override
  Future<int> getProductTasksCount(String taskId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return _mockProductTasks.where((pt) => pt['documentNo'] == taskId).length;
  }

  @override
  Future<List<LocationModel>> getLocations(String taskLocationCode) async {
    await Future.delayed(const Duration(milliseconds: 400));

    return _mockLocations.map((json) => LocationModel.fromJson(json)).toList();
  }

  @override
  Future<String> createTransferHeader(
    String transferFromCode,
    String transferToCode,
    String taskId,
    String licensePlate,
  ) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final headerId = 'TH-${_nextTransferHeaderId.toString().padLeft(5, '0')}';

    _mockTransferHeaders.add({
      'no': headerId,
      'transferFromCode': transferFromCode,
      'transferToCode': transferToCode,
      'taskId': taskId,
      'licensePlate': licensePlate,
    });

    _nextTransferHeaderId++;
    return headerId;
  }

  @override
  Future<void> createTransferLine(TransferLineModel transferLine) async {
    await Future.delayed(const Duration(milliseconds: 500));

    _mockTransferLines.add(transferLine.toJson());
    _nextTransferLineId++;
  }

  @override
  Future<List<TransferReceiptLineModel>> getTransferReceiptLines(
    String taskId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final lines =
        _mockTransferReceiptLines
            .where((line) => line['taskId'] == taskId)
            .toList();

    return lines
        .map((json) => TransferReceiptLineModel.fromJson(json))
        .toList();
  }

  @override
  Future<TransferReceiptLineModel?> getTransferReceiptLine(
    String taskId,
    String productId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final lines =
        _mockTransferReceiptLines
            .where(
              (line) => line['taskId'] == taskId && line['itemNo'] == productId,
            )
            .toList();

    if (lines.isEmpty) {
      return null;
    }

    return TransferReceiptLineModel.fromJson(lines.first);
  }

  @override
  Future<List<TransferLineModel>> getTransferLines(String taskId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final lines =
        _mockTransferLines.where((line) => line['taskId'] == taskId).toList();

    return lines.map((json) => TransferLineModel.fromJson(json)).toList();
  }

  @override
  Future<PagedResult<ProductModel>> getProductsPage({
    required int skip,
    required int top,
    String? searchQuery,
    CancelToken? cancelToken,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    var products = _mockProducts;

    // Apply search filter if provided
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      products =
          products.where((p) {
            final description = (p['description'] as String).toLowerCase();
            final searchDesc = (p['searchDescription'] as String).toLowerCase();
            final no = (p['no'] as String).toLowerCase();
            return description.contains(query) ||
                searchDesc.contains(query) ||
                no.contains(query);
          }).toList();
    }

    // Calculate pagination
    final total = products.length;
    final endIndex = (skip + top).clamp(0, total);
    final pagedProducts = products.sublist(skip.clamp(0, total), endIndex);

    return PagedResult<ProductModel>(
      items: pagedProducts.map((json) => ProductModel.fromJson(json)).toList(),
      totalCount: total,
      skip: skip,
      top: top,
    );
  }
}
