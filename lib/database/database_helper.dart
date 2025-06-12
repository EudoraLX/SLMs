import 'package:mysql1/mysql1.dart';
import '../config/database_config.dart';
import '../models/part.dart';
import '../models/server.dart';
import '../models/sale.dart';
import '../models/operation_log.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static MySqlConnection? _connection;

  DatabaseHelper._init();

  Future<MySqlConnection> get connection async {
    if (_connection != null) return _connection!;
    _connection = await MySqlConnection.connect(
      ConnectionSettings(
        host: DatabaseConfig.host,
        port: DatabaseConfig.port,
        user: DatabaseConfig.username,
        password: DatabaseConfig.password,
        db: DatabaseConfig.database,
      ),
    );
    return _connection!;
  }

  final String _host = DatabaseConfig.host;
  final int _port = DatabaseConfig.port;
  final String _database = DatabaseConfig.database;
  final String _username = DatabaseConfig.username;
  final String _password = DatabaseConfig.password;

  Future<Part?> getPart(int id) async {
    try {
      final conn = await connection;
      final results = await conn.query(
        'SELECT * FROM ${DatabaseConfig.tableParts} WHERE id = ?',
        [id],
      );
      
      if (results.isNotEmpty) {
        final row = results.first;
        return Part.fromMap(row.fields);
      }
      return null;
    } catch (e) {
      print('获取配件失败: $e');
      rethrow;
    }
  }

  Future<Server?> getServer(int id) async {
    try {
      final conn = await connection;
      final results = await conn.query(
        'SELECT * FROM ${DatabaseConfig.tableServers} WHERE id = ?',
        [id],
      );
      
      if (results.isNotEmpty) {
        final row = results.first;
        return Server.fromMap(row.fields);
      }
      return null;
    } catch (e) {
      print('获取服务器失败: $e');
      rethrow;
    }
  }

  // 获取所有配件（带外键名称）
  Future<List<Part>> getAllParts() async {
    final conn = await connection;
    final results = await conn.query('''
      SELECT p.*, 
        pt.name AS type_name, 
        m.name AS manufacturer_name, 
        l.name AS location_name, 
        s.name AS supplier_name, 
        w.name AS warranty_name, 
        st.name AS status_name
      FROM parts p
      LEFT JOIN part_types pt ON p.type_id = pt.id
      LEFT JOIN manufacturers m ON p.manufacturer_id = m.id
      LEFT JOIN locations l ON p.location_id = l.id
      LEFT JOIN suppliers s ON p.supplier_id = s.id
      LEFT JOIN warranty_periods w ON p.warranty_id = w.id
      LEFT JOIN status_types st ON p.status_id = st.id
    ''');
    return results.map((row) => Part.fromMap(row.fields)).toList();
  }

  // 获取所有服务器
  Future<List<Server>> getAllServers() async {
    final conn = await connection;
    final results = await conn.query('SELECT * FROM servers');
    return results.map((row) => Server.fromMap(row.fields)).toList();
  }

  // 获取所有销售记录
  Future<List<Sale>> getAllSales() async {
    final conn = await connection;
    final results = await conn.query('SELECT * FROM sales');
    return results.map((row) => Sale.fromMap(row.fields)).toList();
  }

  // 获取所有操作日志
  Future<List<OperationLog>> getAllOperationLogs() async {
    final conn = await connection;
    final results = await conn.query('SELECT * FROM operation_logs');
    return results.map((row) => OperationLog.fromMap(row.fields)).toList();
  }

  // 添加配件
  Future<int> insertPart(Part part) async {
    final conn = await connection;
    var result = await conn.query(
      'INSERT INTO parts (serial_number, type_id, model, manufacturer_id, specifications, purchase_cost, selling_price, quantity, location_id, supplier_id, warranty_id, status_id, source_server_id, current_server_id, purchase_date, last_modified_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
      [
        part.serialNumber,
        part.typeId,
        part.model,
        part.manufacturerId,
        part.specifications,
        part.purchaseCost,
        part.sellingPrice,
        part.quantity,
        part.locationId,
        part.supplierId,
        part.warrantyId,
        part.statusId,
        part.sourceServerId,
        part.currentServerId,
        part.purchaseDate.toIso8601String(),
        part.lastModifiedDate.toIso8601String(),
      ],
    );
    return result.insertId!;
  }

  // 更新配件
  Future<void> updatePart(Part part) async {
    final conn = await connection;
    await conn.query(
      'UPDATE parts SET type_id = ?, model = ?, manufacturer_id = ?, specifications = ?, purchase_cost = ?, selling_price = ?, quantity = ?, location_id = ?, supplier_id = ?, warranty_id = ?, status_id = ?, source_server_id = ?, current_server_id = ?, purchase_date = ?, last_modified_date = ? WHERE serial_number = ?',
      [
        part.typeId,
        part.model,
        part.manufacturerId,
        part.specifications,
        part.purchaseCost,
        part.sellingPrice,
        part.quantity,
        part.locationId,
        part.supplierId,
        part.warrantyId,
        part.statusId,
        part.sourceServerId,
        part.currentServerId,
        part.purchaseDate.toIso8601String(),
        part.lastModifiedDate.toIso8601String(),
        part.serialNumber,
      ],
    );
  }

  // 删除配件
  Future<void> deletePart(int id) async {
    final conn = await connection;
    await conn.query('DELETE FROM parts WHERE id = ?', [id]);
  }

  // 添加服务器
  Future<int> addServer(Server server) async {
    final conn = await connection;
    final result = await conn.query(
      '''
      INSERT INTO servers (
        serial_number, model, manufacturer, specifications, purchase_cost,
        selling_price, quantity, location, supplier, warranty, current_status,
        assembly_date, part_serial_numbers, last_modified_date
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ''',
      [
        server.serialNumber,
        server.model,
        server.manufacturer,
        server.specifications,
        server.purchaseCost,
        server.sellingPrice,
        server.quantity,
        server.location,
        server.supplier,
        server.warranty,
        server.currentStatus,
        server.assemblyDate,
        server.partSerialNumbers,
        server.lastModifiedDate,
      ],
    );
    return result.insertId!;
  }

  // 更新服务器
  Future<void> updateServer(Server server) async {
    final conn = await connection;
    await conn.query(
      '''
      UPDATE servers SET
        serial_number = ?, model = ?, manufacturer = ?, specifications = ?,
        purchase_cost = ?, selling_price = ?, quantity = ?, location = ?,
        supplier = ?, warranty = ?, current_status = ?, assembly_date = ?,
        part_serial_numbers = ?, last_modified_date = ?
      WHERE id = ?
      ''',
      [
        server.serialNumber,
        server.model,
        server.manufacturer,
        server.specifications,
        server.purchaseCost,
        server.sellingPrice,
        server.quantity,
        server.location,
        server.supplier,
        server.warranty,
        server.currentStatus,
        server.assemblyDate,
        server.partSerialNumbers,
        server.lastModifiedDate,
        server.id,
      ],
    );
  }

  // 删除服务器
  Future<void> deleteServer(int id) async {
    final conn = await connection;
    await conn.query('DELETE FROM servers WHERE id = ?', [id]);
  }

  // 添加销售记录
  Future<int> insertSale(Sale sale) async {
    final conn = await connection;
    var result = await conn.query(
      'INSERT INTO sales (item_type, serial_number, customer, quantity, unit_price, total_amount, sale_date, payment_method, notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
      [
        sale.itemType,
        sale.serialNumber,
        sale.customer,
        sale.quantity,
        sale.unitPrice,
        sale.totalAmount,
        sale.saleDate.toIso8601String(),
        sale.paymentMethod,
        sale.notes,
      ],
    );
    return result.insertId!;
  }

  // 添加操作日志
  Future<int> insertOperationLog(OperationLog log) async {
    final conn = await connection;
    var result = await conn.query(
      'INSERT INTO operation_logs (operation_type, item_type, serial_number, operation_date, operator, details) VALUES (?, ?, ?, ?, ?, ?)',
      [
        log.operationType,
        log.itemType,
        log.serialNumber,
        log.operationDate.toIso8601String(),
        log.operator,
        log.details,
      ],
    );
    return result.insertId!;
  }

  // 预选项相关方法
  Future<List<Map<String, dynamic>>> getAllPartTypes() async {
    final conn = await connection;
    final results = await conn.query('SELECT * FROM part_types');
    print('getAllPartTypes: ${results.length} rows');
    return results.map((row) => {
      'id': row['id'],
      'name': row['name'],
      'description': row['description'],
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getAllManufacturers() async {
    final conn = await connection;
    final results = await conn.query('SELECT * FROM manufacturers');
    return results.map((row) => {
      'id': row['id'],
      'name': row['name'],
      'website': row['website'],
      'contact_info': row['contact_info'],
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getAllLocations() async {
    final conn = await connection;
    final results = await conn.query('SELECT * FROM locations');
    return results.map((row) => {
      'id': row['id'],
      'name': row['name'],
      'address': row['address'],
      'capacity': row['capacity'],
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getAllSuppliers() async {
    final conn = await connection;
    final results = await conn.query('SELECT * FROM suppliers');
    return results.map((row) => {
      'id': row['id'],
      'name': row['name'],
      'contact_person': row['contact_person'],
      'phone': row['phone'],
      'email': row['email'],
      'address': row['address'],
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getAllWarrantyPeriods() async {
    final conn = await connection;
    final results = await conn.query('SELECT * FROM warranty_periods');
    return results.map((row) => {
      'id': row['id'],
      'name': row['name'],
      'months': row['months'],
      'description': row['description'],
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getAllStatusTypes() async {
    final conn = await connection;
    final results = await conn.query('SELECT * FROM status_types');
    return results.map((row) => {
      'id': row['id'],
      'name': row['name'],
      'description': row['description'],
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getAllPaymentMethods() async {
    final conn = await connection;
    final results = await conn.query('SELECT * FROM payment_methods');
    return results.map((row) => {
      'id': row['id'],
      'name': row['name'],
      'description': row['description'],
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getAllOperationTypes() async {
    final conn = await connection;
    final results = await conn.query('SELECT * FROM operation_types');
    return results.map((row) => {
      'id': row['id'],
      'name': row['name'],
      'description': row['description'],
    }).toList();
  }

  // 添加预选项
  Future<void> addPartType(String name, String description) async {
    print('addPartType called: $name, $description');
    final conn = await connection;
    await conn.query('INSERT INTO part_types (name, description) VALUES (?, ?)', [name, description]);
  }

  Future<void> addManufacturer(String name, String website, String contactInfo) async {
    final conn = await connection;
    await conn.query(
      'INSERT INTO manufacturers (name, website, contact_info) VALUES (?, ?, ?)',
      [name, website, contactInfo],
    );
  }

  Future<void> addLocation(String name, String address, int capacity) async {
    final conn = await connection;
    await conn.query(
      'INSERT INTO locations (name, address, capacity) VALUES (?, ?, ?)',
      [name, address, capacity],
    );
  }

  Future<void> addSupplier(String name, String contactPerson, String phone, String email, String address) async {
    final conn = await connection;
    await conn.query(
      'INSERT INTO suppliers (name, contact_person, phone, email, address) VALUES (?, ?, ?, ?, ?)',
      [name, contactPerson, phone, email, address],
    );
  }

  Future<void> addWarrantyPeriod(String name, int months, String description) async {
    final conn = await connection;
    await conn.query(
      'INSERT INTO warranty_periods (name, months, description) VALUES (?, ?, ?)',
      [name, months, description],
    );
  }

  Future<void> addStatusType(String name, String description) async {
    final conn = await connection;
    await conn.query(
      'INSERT INTO status_types (name, description) VALUES (?, ?)',
      [name, description],
    );
  }

  Future<void> addPaymentMethod(String name, String description) async {
    final conn = await connection;
    await conn.query(
      'INSERT INTO payment_methods (name, description) VALUES (?, ?)',
      [name, description],
    );
  }

  Future<void> addOperationType(String name, String description) async {
    final conn = await connection;
    await conn.query(
      'INSERT INTO operation_types (name, description) VALUES (?, ?)',
      [name, description],
    );
  }

  // 更新预选项
  Future<void> updatePartType(int id, String name, String description) async {
    final conn = await connection;
    await conn.query(
      'UPDATE part_types SET name = ?, description = ? WHERE id = ?',
      [name, description, id],
    );
  }

  Future<void> updateManufacturer(int id, String name, String website, String contactInfo) async {
    final conn = await connection;
    await conn.query(
      'UPDATE manufacturers SET name = ?, website = ?, contact_info = ? WHERE id = ?',
      [name, website, contactInfo, id],
    );
  }

  Future<void> updateLocation(int id, String name, String address, int capacity) async {
    final conn = await connection;
    await conn.query(
      'UPDATE locations SET name = ?, address = ?, capacity = ? WHERE id = ?',
      [name, address, capacity, id],
    );
  }

  Future<void> updateSupplier(int id, String name, String contactPerson, String phone, String email, String address) async {
    final conn = await connection;
    await conn.query(
      'UPDATE suppliers SET name = ?, contact_person = ?, phone = ?, email = ?, address = ? WHERE id = ?',
      [name, contactPerson, phone, email, address, id],
    );
  }

  Future<void> updateWarrantyPeriod(int id, String name, int months, String description) async {
    final conn = await connection;
    await conn.query(
      'UPDATE warranty_periods SET name = ?, months = ?, description = ? WHERE id = ?',
      [name, months, description, id],
    );
  }

  Future<void> updateStatusType(int id, String name, String description) async {
    final conn = await connection;
    await conn.query(
      'UPDATE status_types SET name = ?, description = ? WHERE id = ?',
      [name, description, id],
    );
  }

  Future<void> updatePaymentMethod(int id, String name, String description) async {
    final conn = await connection;
    await conn.query(
      'UPDATE payment_methods SET name = ?, description = ? WHERE id = ?',
      [name, description, id],
    );
  }

  Future<void> updateOperationType(int id, String name, String description) async {
    final conn = await connection;
    await conn.query(
      'UPDATE operation_types SET name = ?, description = ? WHERE id = ?',
      [name, description, id],
    );
  }

  // 删除预选项
  Future<void> deletePartType(int id) async {
    final conn = await connection;
    await conn.query('DELETE FROM part_types WHERE id = ?', [id]);
  }

  Future<void> deleteManufacturer(int id) async {
    final conn = await connection;
    await conn.query('DELETE FROM manufacturers WHERE id = ?', [id]);
  }

  Future<void> deleteLocation(int id) async {
    final conn = await connection;
    await conn.query('DELETE FROM locations WHERE id = ?', [id]);
  }

  Future<void> deleteSupplier(int id) async {
    final conn = await connection;
    await conn.query('DELETE FROM suppliers WHERE id = ?', [id]);
  }

  Future<void> deleteWarrantyPeriod(int id) async {
    final conn = await connection;
    await conn.query('DELETE FROM warranty_periods WHERE id = ?', [id]);
  }

  Future<void> deleteStatusType(int id) async {
    final conn = await connection;
    await conn.query('DELETE FROM status_types WHERE id = ?', [id]);
  }

  Future<void> deletePaymentMethod(int id) async {
    final conn = await connection;
    await conn.query('DELETE FROM payment_methods WHERE id = ?', [id]);
  }

  Future<void> deleteOperationType(int id) async {
    final conn = await connection;
    await conn.query('DELETE FROM operation_types WHERE id = ?', [id]);
  }

  // 关闭数据库连接
  Future<void> close() async {
    if (_connection != null) {
      await _connection!.close();
      _connection = null;
    }
  }

  Future<List<Server>> getServers() async {
    final conn = await connection;
    final results = await conn.query('SELECT * FROM servers');
    return results.map((row) {
      final partSerialNumbers = row['part_serial_numbers'] as String?;
      return Server(
        id: row['id'] as int,
        serialNumber: row['serial_number'] as String,
        model: row['model'] as String,
        manufacturer: row['manufacturer'] as String,
        specifications: row['specifications'] as String,
        purchaseCost: (row['purchase_cost'] as num).toDouble(),
        sellingPrice: (row['selling_price'] as num).toDouble(),
        quantity: row['quantity'] as int,
        location: row['location'] as String,
        supplier: row['supplier'] as String,
        warranty: row['warranty'] as String,
        currentStatus: row['current_status'] as String,
        assemblyDate: (row['assembly_date'] as DateTime).toLocal(),
        partSerialNumbers: partSerialNumbers ?? '',
        lastModifiedDate: (row['last_modified_date'] as DateTime).toLocal(),
      );
    }).toList();
  }

  Future<Server?> getServerBySerialNumber(String serialNumber) async {
    final conn = await connection;
    final results = await conn.query(
      'SELECT * FROM servers WHERE serial_number = ?',
      [serialNumber],
    );
    if (results.isEmpty) return null;
    final row = results.first;
    final partSerialNumbers = row['part_serial_numbers'] as String?;
    return Server(
      id: row['id'] as int,
      serialNumber: row['serial_number'] as String,
      model: row['model'] as String,
      manufacturer: row['manufacturer'] as String,
      specifications: row['specifications'] as String,
      purchaseCost: (row['purchase_cost'] as num).toDouble(),
      sellingPrice: (row['selling_price'] as num).toDouble(),
      quantity: row['quantity'] as int,
      location: row['location'] as String,
      supplier: row['supplier'] as String,
      warranty: row['warranty'] as String,
      currentStatus: row['current_status'] as String,
      assemblyDate: (row['assembly_date'] as DateTime).toLocal(),
      partSerialNumbers: partSerialNumbers ?? '',
      lastModifiedDate: (row['last_modified_date'] as DateTime).toLocal(),
    );
  }
} 