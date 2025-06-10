class DatabaseConfig {
  // MySQL 连接配置
  static const String host = 'localhost';
  static const int port = 3306;
  static const String database = 'business';
  static const String username = 'root';
  static const String password = 'Qwer.com123';
  
  // 表名
  static const String tableParts = 'parts';
  static const String tableServers = 'servers';
  static const String tableSales = 'sales';
  static const String tableOperationLogs = 'operation_logs';
  
  // 配件表字段
  static const String columnPartId = 'id';
  static const String columnPartSerialNumber = 'serial_number';
  static const String columnPartType = 'type';
  static const String columnPartModel = 'model';
  static const String columnPartPurchaseCost = 'purchase_cost';
  static const String columnPartCurrentStatus = 'current_status';
  static const String columnPartSourceServerId = 'source_server_id';
  static const String columnPartCurrentServerId = 'current_server_id';
  static const String columnPartPurchaseDate = 'purchase_date';
  static const String columnPartLastModifiedDate = 'last_modified_date';
  
  // 服务器表字段
  static const String columnServerId = 'id';
  static const String columnServerSerialNumber = 'serial_number';
  static const String columnServerModel = 'model';
  static const String columnServerPurchaseCost = 'purchase_cost';
  static const String columnServerCurrentStatus = 'current_status';
  static const String columnServerAssemblyDate = 'assembly_date';
  static const String columnServerLastModifiedDate = 'last_modified_date';
  static const String columnServerPartSerialNumbers = 'part_serial_numbers';
  
  // 销售记录表字段
  static const String columnSaleId = 'id';
  static const String columnSaleItemType = 'item_type';
  static const String columnSaleSerialNumber = 'serial_number';
  static const String columnSalePrice = 'sale_price';
  static const String columnSaleDate = 'sale_date';
  static const String columnSaleCustomer = 'customer';
  static const String columnSaleNotes = 'notes';
  
  // 操作日志表字段
  static const String columnLogId = 'id';
  static const String columnLogOperationType = 'operation_type';
  static const String columnLogItemType = 'item_type';
  static const String columnLogSerialNumber = 'serial_number';
  static const String columnLogOperationDate = 'operation_date';
  static const String columnLogOperator = 'operator';
  static const String columnLogDetails = 'details';

  // 打印数据库配置信息
  static void printConfig() {
    print('数据库配置信息：');
    print('主机：$host');
    print('端口：$port');
    print('数据库：$database');
    print('用户名：$username');
    print('密码：${'*' * password.length}');
  }
} 