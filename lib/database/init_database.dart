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
  }
} 