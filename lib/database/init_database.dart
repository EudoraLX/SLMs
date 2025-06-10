import 'package:mysql1/mysql1.dart';
import '../config/database_config.dart';

class DatabaseInitializer {
  static Future<void> initializeDatabase() async {
    print('开始初始化数据库...');
    print('连接信息：');
    print('主机：${DatabaseConfig.host}');
    print('端口：${DatabaseConfig.port}');
    print('数据库：${DatabaseConfig.database}');
    print('用户名：${DatabaseConfig.username}');
    
    // 创建数据库连接
    MySqlConnection? connection;
    try {
      print('正在连接MySQL服务器...');
      connection = await MySqlConnection.connect(
        ConnectionSettings(
          host: DatabaseConfig.host,
          port: DatabaseConfig.port,
          user: DatabaseConfig.username,
          password: DatabaseConfig.password,
        ),
      );
      print('MySQL服务器连接成功！');

      // 创建数据库
      print('正在创建数据库 ${DatabaseConfig.database}...');
      await connection.query('DROP DATABASE IF EXISTS ${DatabaseConfig.database}');
      await connection.query('CREATE DATABASE ${DatabaseConfig.database}');
      await connection.query('USE ${DatabaseConfig.database}');
      print('数据库创建/选择成功！');

      // 创建配件表
      print('正在创建配件表...');
      await connection.query('''
        CREATE TABLE IF NOT EXISTS ${DatabaseConfig.tableParts} (
          id INT AUTO_INCREMENT PRIMARY KEY,
          serial_number VARCHAR(50) UNIQUE NOT NULL,
          type VARCHAR(50) NOT NULL,
          model VARCHAR(100) NOT NULL,
          purchase_cost DECIMAL(10,2) NOT NULL,
          current_status VARCHAR(50) NOT NULL,
          source_server_id VARCHAR(50),
          current_server_id VARCHAR(50),
          purchase_date DATETIME NOT NULL,
          last_modified_date DATETIME NOT NULL
        )
      ''');
      print('配件表创建成功！');

      // 创建服务器表
      print('正在创建服务器表...');
      await connection.query('''
        CREATE TABLE IF NOT EXISTS ${DatabaseConfig.tableServers} (
          id INT AUTO_INCREMENT PRIMARY KEY,
          serial_number VARCHAR(50) UNIQUE NOT NULL,
          model VARCHAR(100) NOT NULL,
          purchase_cost DECIMAL(10,2) NOT NULL,
          current_status VARCHAR(50) NOT NULL,
          assembly_date DATETIME NOT NULL,
          last_modified_date DATETIME NOT NULL,
          part_serial_numbers VARCHAR(500)
        )
      ''');
      print('服务器表创建成功！');

      // 创建销售记录表
      print('正在创建销售记录表...');
      await connection.query('''
        CREATE TABLE IF NOT EXISTS ${DatabaseConfig.tableSales} (
          id INT AUTO_INCREMENT PRIMARY KEY,
          item_type VARCHAR(50) NOT NULL,
          serial_number VARCHAR(50) NOT NULL,
          sale_price DECIMAL(10,2) NOT NULL,
          sale_date DATETIME NOT NULL,
          customer VARCHAR(100) NOT NULL,
          notes TEXT
        )
      ''');
      print('销售记录表创建成功！');

      // 创建操作日志表
      print('正在创建操作日志表...');
      await connection.query('''
        CREATE TABLE IF NOT EXISTS ${DatabaseConfig.tableOperationLogs} (
          id INT AUTO_INCREMENT PRIMARY KEY,
          operation_type VARCHAR(50) NOT NULL,
          item_type VARCHAR(50) NOT NULL,
          serial_number VARCHAR(50) NOT NULL,
          operation_date DATETIME NOT NULL,
          operator VARCHAR(50) NOT NULL,
          details TEXT
        )
      ''');
      print('操作日志表创建成功！');

      // 插入测试数据
      print('正在插入测试数据...');
      await _insertTestData(connection);
      print('测试数据插入成功！');

      print('数据库初始化完成！');
    } catch (e) {
      print('数据库初始化失败：$e');
      rethrow;
    } finally {
      if (connection != null) {
        await connection.close();
        print('数据库连接已关闭');
      }
    }
  }

  static Future<void> _insertTestData(MySqlConnection connection) async {
    try {
      // 插入测试配件
      print('正在插入测试配件数据...');
      await connection.query('''
        INSERT INTO ${DatabaseConfig.tableParts} (
          serial_number,
          type,
          model,
          purchase_cost,
          current_status,
          purchase_date,
          last_modified_date
        ) VALUES
        ('CPU001', 'CPU', 'Intel Xeon E5-2680', 2999.99, 'In Stock', NOW(), NOW()),
        ('CPU002', 'CPU', 'AMD EPYC 7742', 3999.99, 'In Stock', NOW(), NOW()),
        ('CPU003', 'CPU', 'Intel Xeon Gold 6346', 4999.99, 'In Stock', NOW(), NOW()),
        ('RAM001', '内存', 'DDR4 32GB', 999.99, 'In Stock', NOW(), NOW()),
        ('RAM002', '内存', 'DDR4 64GB', 1999.99, 'In Stock', NOW(), NOW()),
        ('RAM003', '内存', 'DDR4 128GB', 3999.99, 'In Stock', NOW(), NOW()),
        ('HDD001', '硬盘', 'Seagate 2TB', 599.99, 'In Stock', NOW(), NOW()),
        ('HDD002', '硬盘', 'WD 4TB', 899.99, 'In Stock', NOW(), NOW()),
        ('SSD001', '固态硬盘', 'Samsung 1TB', 1299.99, 'In Stock', NOW(), NOW()),
        ('SSD002', '固态硬盘', 'Intel 2TB', 2499.99, 'In Stock', NOW(), NOW()),
        ('MB001', '主板', 'ASUS WS C621E', 3999.99, 'In Stock', NOW(), NOW()),
        ('MB002', '主板', 'GIGABYTE MZ32', 4999.99, 'In Stock', NOW(), NOW()),
        ('PSU001', '电源', 'Corsair 1200W', 1999.99, 'In Stock', NOW(), NOW()),
        ('PSU002', '电源', 'Seasonic 1600W', 2499.99, 'In Stock', NOW(), NOW()),
        ('CASE001', '机箱', 'Dell R740', 2999.99, 'In Stock', NOW(), NOW()),
        ('CASE002', '机箱', 'HPE DL380', 3499.99, 'In Stock', NOW(), NOW())
      ''');
      print('测试配件数据插入成功！');

      // 插入测试服务器
      print('正在插入测试服务器数据...');
      await connection.query('''
        INSERT INTO ${DatabaseConfig.tableServers} (
          serial_number,
          model,
          purchase_cost,
          current_status,
          assembly_date,
          last_modified_date,
          part_serial_numbers
        ) VALUES
        ('SRV001', 'Dell PowerEdge R740', 49999.99, 'Assembled', NOW(), NOW(), 'CPU001,RAM001,HDD001,SSD001,MB001,PSU001,CASE001'),
        ('SRV002', 'HPE ProLiant DL380', 59999.99, 'Assembled', NOW(), NOW(), 'CPU002,RAM002,HDD002,SSD002,MB002,PSU002,CASE002'),
        ('SRV003', 'Lenovo ThinkSystem SR650', 54999.99, 'In Stock', NOW(), NOW(), ''),
        ('SRV004', 'Cisco UCS C240', 52999.99, 'In Stock', NOW(), NOW(), '')
      ''');
      print('测试服务器数据插入成功！');

      // 插入销售记录
      print('正在插入销售记录数据...');
      await connection.query('''
        INSERT INTO ${DatabaseConfig.tableSales} (
          item_type,
          serial_number,
          sale_price,
          sale_date,
          customer,
          notes
        ) VALUES
        ('Server', 'SRV001', 55000.00, DATE_SUB(NOW(), INTERVAL 30 DAY), '阿里巴巴', '企业级服务器'),
        ('Part', 'CPU001', 3200.00, DATE_SUB(NOW(), INTERVAL 15 DAY), '腾讯', 'CPU升级'),
        ('Part', 'RAM001', 1100.00, DATE_SUB(NOW(), INTERVAL 7 DAY), '百度', '内存升级')
      ''');
      print('销售记录数据插入成功！');

      // 插入操作日志
      print('正在插入操作日志数据...');
      await connection.query('''
        INSERT INTO ${DatabaseConfig.tableOperationLogs} (
          operation_type,
          item_type,
          serial_number,
          operation_date,
          operator,
          details
        ) VALUES
        ('Assembly', 'Server', 'SRV001', DATE_SUB(NOW(), INTERVAL 30 DAY), '张三', '服务器组装完成'),
        ('Sale', 'Server', 'SRV001', DATE_SUB(NOW(), INTERVAL 30 DAY), '李四', '服务器售出'),
        ('Purchase', 'Part', 'CPU001', DATE_SUB(NOW(), INTERVAL 45 DAY), '王五', 'CPU入库'),
        ('Assembly', 'Part', 'CPU001', DATE_SUB(NOW(), INTERVAL 30 DAY), '张三', 'CPU安装到服务器')
      ''');
      print('操作日志数据插入成功！');
    } catch (e) {
      print('插入测试数据失败：$e');
      rethrow;
    }
  }
} 