import 'package:mysql1/mysql1.dart';
import '../config/database_config.dart';
import '../models/part.dart';
import '../models/server.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static MySqlConnection? _connection;
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  static Future<DatabaseHelper> get instance async {
    if (_instance == null) {
      _instance = DatabaseHelper();
      await _instance!._initDB();
    }
    return _instance!;
  }

  Future<void> _initDB() async {
    if (_connection == null) {
      int retryCount = 0;
      while (retryCount < maxRetries) {
        try {
          print('尝试连接数据库（第 ${retryCount + 1} 次）...');
          DatabaseConfig.printConfig();
          
          _connection = await MySqlConnection.connect(
            ConnectionSettings(
              host: DatabaseConfig.host,
              port: DatabaseConfig.port,
              db: DatabaseConfig.database,
              user: DatabaseConfig.username,
              password: DatabaseConfig.password,
            ),
          );
          print('数据库连接成功！');
          return;
        } catch (e) {
          retryCount++;
          print('数据库连接失败（第 $retryCount 次）：$e');
          if (retryCount < maxRetries) {
            print('等待 ${retryDelay.inSeconds} 秒后重试...');
            await Future.delayed(retryDelay);
          } else {
            print('达到最大重试次数，放弃连接');
            rethrow;
          }
        }
      }
    }
  }

  Future<void> closeConnection() async {
    if (_connection != null) {
      await _connection!.close();
      _connection = null;
      print('数据库连接已关闭');
    }
  }

  // Parts CRUD operations
  Future<int> insertPart(Part part) async {
    await _initDB();
    try {
      final result = await _connection!.query(
        'INSERT INTO ${DatabaseConfig.tableParts} (${DatabaseConfig.columnPartSerialNumber}, ${DatabaseConfig.columnPartType}, ${DatabaseConfig.columnPartModel}, ${DatabaseConfig.columnPartPurchaseCost}, ${DatabaseConfig.columnPartCurrentStatus}, ${DatabaseConfig.columnPartSourceServerId}, ${DatabaseConfig.columnPartCurrentServerId}, ${DatabaseConfig.columnPartPurchaseDate}, ${DatabaseConfig.columnPartLastModifiedDate}) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [
          part.serialNumber,
          part.type,
          part.model,
          part.purchaseCost,
          part.currentStatus,
          part.sourceServerId,
          part.currentServerId,
          part.purchaseDate.toIso8601String(),
          part.lastModifiedDate?.toIso8601String() ?? part.purchaseDate.toIso8601String(),
        ],
      );
      return result.insertId ?? 0;
    } catch (e) {
      print('插入配件失败：$e');
      rethrow;
    }
  }

  Future<Part?> getPart(String serialNumber) async {
    await _initDB();
    final results = await _connection!.query(
      'SELECT * FROM ${DatabaseConfig.tableParts} WHERE ${DatabaseConfig.columnPartSerialNumber} = ?',
      [serialNumber],
    );

    if (results.isNotEmpty) {
      return Part.fromMap(results.first.fields);
    }
    return null;
  }

  Future<List<Part>> getAllParts() async {
    await _initDB();
    try {
      final results = await _connection!.query('SELECT * FROM ${DatabaseConfig.tableParts}');
      print('获取到 ${results.length} 个零件');
      return results.map((row) {
        print('零件数据: ${row.fields}');
        final part = Part.fromMap(row.fields);
        print('解析后的零件: ${part.serialNumber}, ${part.model}, ${part.type}, ${part.currentStatus}');
        return part;
      }).toList();
    } catch (e) {
      print('获取所有配件失败：$e');
      rethrow;
    }
  }

  Future<int> updatePart(Part part) async {
    await _initDB();
    final result = await _connection!.query(
      'UPDATE ${DatabaseConfig.tableParts} SET ${DatabaseConfig.columnPartType} = ?, ${DatabaseConfig.columnPartModel} = ?, ${DatabaseConfig.columnPartPurchaseCost} = ?, ${DatabaseConfig.columnPartCurrentStatus} = ?, ${DatabaseConfig.columnPartSourceServerId} = ?, ${DatabaseConfig.columnPartCurrentServerId} = ?, ${DatabaseConfig.columnPartPurchaseDate} = ?, ${DatabaseConfig.columnPartLastModifiedDate} = ? WHERE ${DatabaseConfig.columnPartSerialNumber} = ?',
      [
        part.type,
        part.model,
        part.purchaseCost,
        part.currentStatus,
        part.sourceServerId,
        part.currentServerId,
        part.purchaseDate.toIso8601String(),
        part.lastModifiedDate?.toIso8601String() ?? part.purchaseDate.toIso8601String(),
        part.serialNumber,
      ],
    );
    return result.affectedRows ?? 0;
  }

  // Servers CRUD operations
  Future<int> insertServer(Server server) async {
    await _initDB();
    final result = await _connection!.query(
      'INSERT INTO ${DatabaseConfig.tableServers} (${DatabaseConfig.columnServerSerialNumber}, ${DatabaseConfig.columnServerModel}, ${DatabaseConfig.columnServerPurchaseCost}, ${DatabaseConfig.columnServerCurrentStatus}, ${DatabaseConfig.columnServerAssemblyDate}, ${DatabaseConfig.columnServerLastModifiedDate}, ${DatabaseConfig.columnServerPartSerialNumbers}) VALUES (?, ?, ?, ?, ?, ?, ?)',
      [
        server.serialNumber,
        server.model,
        server.purchaseCost,
        server.currentStatus,
        server.assemblyDate.toIso8601String(),
        server.lastModifiedDate?.toIso8601String() ?? server.assemblyDate.toIso8601String(),
        server.partSerialNumbers.join(','),
      ],
    );
    return result.insertId ?? 0;
  }

  Future<Server?> getServer(String serialNumber) async {
    await _initDB();
    final results = await _connection!.query(
      'SELECT * FROM ${DatabaseConfig.tableServers} WHERE ${DatabaseConfig.columnServerSerialNumber} = ?',
      [serialNumber],
    );

    if (results.isNotEmpty) {
      return Server.fromMap(results.first.fields);
    }
    return null;
  }

  Future<List<Server>> getAllServers() async {
    await _initDB();
    try {
      final results = await _connection!.query('SELECT * FROM ${DatabaseConfig.tableServers}');
      print('获取到 ${results.length} 个服务器');
      return results.map((row) {
        print('服务器数据: ${row.fields}');
        final server = Server.fromMap(row.fields);
        print('解析后的服务器: ${server.serialNumber}, ${server.model}, ${server.currentStatus}');
        return server;
      }).toList();
    } catch (e) {
      print('获取所有服务器失败：$e');
      rethrow;
    }
  }

  Future<int> updateServer(Server server) async {
    await _initDB();
    final result = await _connection!.query(
      'UPDATE ${DatabaseConfig.tableServers} SET ${DatabaseConfig.columnServerModel} = ?, ${DatabaseConfig.columnServerPurchaseCost} = ?, ${DatabaseConfig.columnServerCurrentStatus} = ?, ${DatabaseConfig.columnServerAssemblyDate} = ?, ${DatabaseConfig.columnServerLastModifiedDate} = ?, ${DatabaseConfig.columnServerPartSerialNumbers} = ? WHERE ${DatabaseConfig.columnServerSerialNumber} = ?',
      [
        server.model,
        server.purchaseCost,
        server.currentStatus,
        server.assemblyDate.toIso8601String(),
        server.lastModifiedDate?.toIso8601String() ?? server.assemblyDate.toIso8601String(),
        server.partSerialNumbers.join(','),
        server.serialNumber,
      ],
    );
    return result.affectedRows ?? 0;
  }

  // Sales operations
  Future<int> insertSale(Map<String, dynamic> sale) async {
    await _initDB();
    final result = await _connection!.query(
      'INSERT INTO ${DatabaseConfig.tableSales} (${DatabaseConfig.columnSaleItemType}, ${DatabaseConfig.columnSaleSerialNumber}, ${DatabaseConfig.columnSalePrice}, ${DatabaseConfig.columnSaleDate}, ${DatabaseConfig.columnSaleCustomer}, ${DatabaseConfig.columnSaleNotes}) VALUES (?, ?, ?, ?, ?, ?)',
      [
        sale[DatabaseConfig.columnSaleItemType],
        sale[DatabaseConfig.columnSaleSerialNumber],
        sale[DatabaseConfig.columnSalePrice],
        sale[DatabaseConfig.columnSaleDate],
        sale[DatabaseConfig.columnSaleCustomer],
        sale[DatabaseConfig.columnSaleNotes],
      ],
    );
    return result.insertId ?? 0;
  }

  Future<List<Map<String, dynamic>>> getSalesBySerialNumber(String serialNumber) async {
    await _initDB();
    final results = await _connection!.query(
      'SELECT * FROM ${DatabaseConfig.tableSales} WHERE ${DatabaseConfig.columnSaleSerialNumber} = ?',
      [serialNumber],
    );
    return results.map((row) => row.fields).toList();
  }

  // Operation logs
  Future<int> insertOperationLog(Map<String, dynamic> log) async {
    await _initDB();
    final result = await _connection!.query(
      'INSERT INTO ${DatabaseConfig.tableOperationLogs} (${DatabaseConfig.columnLogOperationType}, ${DatabaseConfig.columnLogItemType}, ${DatabaseConfig.columnLogSerialNumber}, ${DatabaseConfig.columnLogOperationDate}, ${DatabaseConfig.columnLogOperator}, ${DatabaseConfig.columnLogDetails}) VALUES (?, ?, ?, ?, ?, ?)',
      [
        log[DatabaseConfig.columnLogOperationType],
        log[DatabaseConfig.columnLogItemType],
        log[DatabaseConfig.columnLogSerialNumber],
        log[DatabaseConfig.columnLogOperationDate],
        log[DatabaseConfig.columnLogOperator],
        log[DatabaseConfig.columnLogDetails],
      ],
    );
    return result.insertId ?? 0;
  }

  Future<List<Map<String, dynamic>>> getOperationLogsBySerialNumber(String serialNumber) async {
    await _initDB();
    final results = await _connection!.query(
      'SELECT * FROM ${DatabaseConfig.tableOperationLogs} WHERE ${DatabaseConfig.columnLogSerialNumber} = ? ORDER BY ${DatabaseConfig.columnLogOperationDate} DESC',
      [serialNumber],
    );
    return results.map((row) => row.fields).toList();
  }
} 