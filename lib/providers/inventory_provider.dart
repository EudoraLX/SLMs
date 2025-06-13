import 'package:flutter/foundation.dart';
import '../database/database_helper.dart';
import '../models/part.dart';
import '../models/server.dart';
import '../models/sale.dart';
import '../models/operation_log.dart';

class InventoryProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Part> _parts = [];
  List<Server> _servers = [];
  List<Sale> _sales = [];
  List<OperationLog> _operationLogs = [];

  List<Part> get parts => _parts;
  List<Server> get servers => _servers;
  List<Sale> get sales => _sales;
  List<OperationLog> get operationLogs => _operationLogs;

  InventoryProvider() {
    loadInventory();
  }

  Future<void> loadInventory() async {
    print('loadInventory called');
    _parts = await _dbHelper.getAllParts();
    _servers = await _dbHelper.getAllServers();
    _sales = await _dbHelper.getAllSales();
    _operationLogs = await _dbHelper.getAllOperationLogs();
    print('Inventory loaded: parts=${_parts.length}, servers=${_servers.length}, sales=${_sales.length}, logs=${_operationLogs.length}');
    notifyListeners();
  }

  Future<void> loadParts() async {
    _parts = await _dbHelper.getAllParts();
    notifyListeners();
  }

  Future<void> loadServers() async {
    _servers = await _dbHelper.getAllServers();
    notifyListeners();
  }

  Future<void> addPart(Part part) async {
    try {
      final id = await _dbHelper.insertPart(part);
      final newPart = part.copyWith(id: id);
      _parts.add(newPart);
      notifyListeners();
      
      // 记录操作日志
      await _dbHelper.insertOperationLog(OperationLog(
        operationType: '添加',
        itemType: '配件',
        serialNumber: part.serialNumber,
        operationDate: DateTime.now(),
        operator: '系统',
        details: '添加新配件: ${part.model}',
      ));
    } catch (e) {
      print('添加配件失败: $e');
      rethrow;
    }
  }

  Future<void> updatePart(Part part) async {
    try {
    await _dbHelper.updatePart(part);
      final index = _parts.indexWhere((p) => p.id == part.id);
      if (index != -1) {
        _parts[index] = part;
        notifyListeners();
      }
      
      // 记录操作日志
      await _dbHelper.insertOperationLog(OperationLog(
        operationType: '更新',
        itemType: '配件',
        serialNumber: part.serialNumber,
        operationDate: DateTime.now(),
        operator: '系统',
        details: '更新配件信息: ${part.model}',
      ));
    } catch (e) {
      print('更新配件失败: $e');
      rethrow;
    }
  }

  Future<void> deletePart(int id) async {
    try {
      await _dbHelper.deletePart(id);
      await loadInventory();
    } catch (e) {
      print('删除配件失败: $e');
      rethrow;
    }
  }

  Future<void> addServer(Server server) async {
    final id = await _dbHelper.addServer(server);
    server = Server(
      id: id,
      serialNumber: server.serialNumber,
      model: server.model,
      manufacturerId: server.manufacturerId,
      manufacturerName: server.manufacturerName,
      specifications: server.specifications,
      purchaseCost: server.purchaseCost,
      sellingPrice: server.sellingPrice,
      quantity: server.quantity,
      locationId: server.locationId,
      locationName: server.locationName,
      supplierId: server.supplierId,
      supplierName: server.supplierName,
      warrantyId: server.warrantyId,
      warrantyName: server.warrantyName,
      statusId: server.statusId,
      statusName: server.statusName,
      assemblyDate: server.assemblyDate,
      partSerialNumbers: server.partSerialNumbers,
      lastModifiedDate: server.lastModifiedDate,
    );
    _servers.add(server);
    notifyListeners();
  }

  Future<void> updateServer(Server server) async {
    try {
    await _dbHelper.updateServer(server);
      final index = _servers.indexWhere((s) => s.id == server.id);
      if (index != -1) {
        _servers[index] = server;
        notifyListeners();
      }
      
      // 记录操作日志
      await _dbHelper.insertOperationLog(OperationLog(
        operationType: '更新',
        itemType: '服务器',
        serialNumber: server.serialNumber,
        operationDate: DateTime.now(),
        operator: '系统',
        details: '更新服务器信息: ${server.model}',
      ));
    } catch (e) {
      print('更新服务器失败: $e');
      rethrow;
    }
  }

  Future<void> deleteServer(int id) async {
    try {
      await _dbHelper.deleteServer(id);
      await loadInventory();
    } catch (e) {
      print('删除服务器失败: $e');
      rethrow;
    }
  }

  Future<void> addSale(Sale sale) async {
    try {
      await _dbHelper.insertSale(sale);
      await loadInventory();
    } catch (e) {
      print('添加销售记录失败: $e');
      rethrow;
    }
  }

  Future<void> addOperationLog(OperationLog log) async {
    try {
      await _dbHelper.insertOperationLog(log);
      await loadInventory();
    } catch (e) {
      print('添加操作日志失败: $e');
      rethrow;
    }
  }

  Future<void> updatePartStatus(int partId, String newStatus) async {
    try {
      final part = await _dbHelper.getPart(partId);
      if (part != null) {
        final updatedPart = Part(
          id: part.id,
          serialNumber: part.serialNumber,
          typeId: part.typeId,
          typeName: part.typeName,
          model: part.model,
          manufacturerId: part.manufacturerId,
          manufacturerName: part.manufacturerName,
          specifications: part.specifications,
          purchaseCost: part.purchaseCost,
          sellingPrice: part.sellingPrice,
          quantity: part.quantity,
          locationId: part.locationId,
          locationName: part.locationName,
          supplierId: part.supplierId,
          supplierName: part.supplierName,
          warrantyId: part.warrantyId,
          warrantyName: part.warrantyName,
          statusId: part.statusId,
          statusName: newStatus,
          sourceServerId: part.sourceServerId,
          currentServerId: part.currentServerId,
          purchaseDate: part.purchaseDate,
          lastModifiedDate: DateTime.now(),
        );
        await updatePart(updatedPart);
      }
    } catch (e) {
      print('更新配件状态失败: $e');
      rethrow;
    }
  }

  Future<void> updateServerStatus(int serverId, String newStatus) async {
    try {
      final server = await _dbHelper.getServer(serverId);
      if (server != null) {
        final updatedServer = Server(
          id: server.id,
          serialNumber: server.serialNumber,
          model: server.model,
          manufacturerId: server.manufacturerId,
          manufacturerName: server.manufacturerName,
          specifications: server.specifications,
          purchaseCost: server.purchaseCost,
          sellingPrice: server.sellingPrice,
          quantity: server.quantity,
          locationId: server.locationId,
          locationName: server.locationName,
          supplierId: server.supplierId,
          supplierName: server.supplierName,
          warrantyId: server.warrantyId,
          warrantyName: server.warrantyName,
          statusId: server.statusId,
          statusName: newStatus,
          assemblyDate: server.assemblyDate,
          lastModifiedDate: DateTime.now(),
          partSerialNumbers: server.partSerialNumbers,
        );
        await updateServer(updatedServer);
      }
    } catch (e) {
      print('更新服务器状态失败: $e');
      rethrow;
    }
  }

  // 通过序列号获取配件
  Future<Part?> getPartBySerialNumber(String serialNumber) async {
    try {
      final parts = await _dbHelper.getAllParts();
      return parts.firstWhere((part) => part.serialNumber == serialNumber);
    } catch (e) {
      print('通过序列号获取配件失败: $e');
      return null;
    }
  }

  // 通过序列号获取服务器
  Future<Server?> getServerBySerialNumber(String serialNumber) async {
    try {
      final servers = await _dbHelper.getAllServers();
      return servers.firstWhere((server) => server.serialNumber == serialNumber);
    } catch (e) {
      print('通过序列号获取服务器失败: $e');
      return null;
    }
  }

  // 获取库存中的配件
  List<Part> getInStockParts() {
    return _parts.where((part) => part.statusName == 'In Stock').toList();
  }

  // 获取已售出的配件
  List<Part> getSoldParts() {
    return _parts.where((part) => part.statusName == 'Sold').toList();
  }

  // 获取库存中的服务器
  List<Server> getInStockServers() {
    return _servers.where((server) => server.statusName == 'In Stock').toList();
  }

  // 获取已售出的服务器
  List<Server> getSoldServers() {
    return _servers.where((server) => server.statusName == 'Sold').toList();
  }

  // 计算总库存价值
  double getTotalInventoryValue() {
    double partsValue = _parts
        .where((part) => part.statusName == 'In Stock')
        .fold(0.0, (sum, part) => sum + part.purchaseCost);
    
    double serversValue = _servers
        .where((server) => server.statusName == 'In Stock')
        .fold(0.0, (sum, server) => sum + server.purchaseCost);
    
    return partsValue + serversValue;
  }

  // 计算总销售利润
  double getTotalProfit() {
    double profit = 0.0;
    
    // 计算已售出配件的利润
    for (var part in _parts.where((p) => p.statusName == 'Sold')) {
      // 从销售记录中获取销售价格
      // 暂时使用采购成本的1.2倍作为销售价格
      double salePrice = part.purchaseCost * 1.2;
      profit += salePrice - part.purchaseCost;
    }
    
    // 计算已售出服务器的利润
    for (var server in _servers.where((s) => s.statusName == 'Sold')) {
      // 从销售记录中获取销售价格
      // 暂时使用采购成本的1.3倍作为销售价格
      double salePrice = server.purchaseCost * 1.3;
      profit += salePrice - server.purchaseCost;
    }
    
    return profit;
  }
} 