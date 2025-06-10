import 'package:flutter/foundation.dart';
import '../models/part.dart';
import '../models/server.dart';
import '../database/database_helper.dart';

class InventoryProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper;
  List<Part> _parts = [];
  List<Server> _servers = [];

  InventoryProvider(this._dbHelper) {
    loadInventory();
  }

  List<Part> get parts => _parts;
  List<Server> get servers => _servers;

  Future<void> loadInventory() async {
    _parts = await _dbHelper.getAllParts();
    _servers = await _dbHelper.getAllServers();
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
    await _dbHelper.insertPart(part);
    _parts.add(part);
    notifyListeners();
  }

  Future<void> updatePart(Part part) async {
    await _dbHelper.updatePart(part);
    final index = _parts.indexWhere((p) => p.serialNumber == part.serialNumber);
    if (index != -1) {
      _parts[index] = part;
      notifyListeners();
    }
  }

  Future<void> addServer(Server server) async {
    await _dbHelper.insertServer(server);
    _servers.add(server);
    notifyListeners();
  }

  Future<void> updateServer(Server server) async {
    await _dbHelper.updateServer(server);
    final index = _servers.indexWhere((s) => s.serialNumber == server.serialNumber);
    if (index != -1) {
      _servers[index] = server;
      notifyListeners();
    }
  }

  // 通过序列号获取配件
  Future<Part?> getPartBySerialNumber(String serialNumber) async {
    return await _dbHelper.getPart(serialNumber);
  }

  // 通过序列号获取服务器
  Future<Server?> getServerBySerialNumber(String serialNumber) async {
    return await _dbHelper.getServer(serialNumber);
  }

  // 获取库存中的配件
  List<Part> getInStockParts() {
    return _parts.where((part) => part.currentStatus == 'In Stock').toList();
  }

  // 获取已售出的配件
  List<Part> getSoldParts() {
    return _parts.where((part) => part.currentStatus == 'Sold').toList();
  }

  // 获取库存中的服务器
  List<Server> getInStockServers() {
    return _servers.where((server) => server.currentStatus == 'In Stock').toList();
  }

  // 获取已售出的服务器
  List<Server> getSoldServers() {
    return _servers.where((server) => server.currentStatus == 'Sold').toList();
  }

  // 计算总库存价值
  double getTotalInventoryValue() {
    double partsValue = _parts
        .where((part) => part.currentStatus == 'In Stock')
        .fold(0.0, (sum, part) => sum + part.purchaseCost);
    
    double serversValue = _servers
        .where((server) => server.currentStatus == 'In Stock')
        .fold(0.0, (sum, server) => sum + server.purchaseCost);
    
    return partsValue + serversValue;
  }

  // 计算总销售利润
  double getTotalProfit() {
    double profit = 0.0;
    
    // 计算已售出配件的利润
    for (var part in _parts.where((p) => p.currentStatus == 'Sold')) {
      // 从销售记录中获取销售价格
      // 暂时使用采购成本的1.2倍作为销售价格
      double salePrice = part.purchaseCost * 1.2;
      profit += salePrice - part.purchaseCost;
    }
    
    // 计算已售出服务器的利润
    for (var server in _servers.where((s) => s.currentStatus == 'Sold')) {
      // 从销售记录中获取销售价格
      // 暂时使用采购成本的1.3倍作为销售价格
      double salePrice = server.purchaseCost * 1.3;
      profit += salePrice - server.purchaseCost;
    }
    
    return profit;
  }
} 