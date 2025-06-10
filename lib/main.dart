import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/inventory_provider.dart';
import 'database/database_helper.dart';
import 'database/init_database.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    print('开始初始化数据库...');
    // 初始化数据库
    await DatabaseInitializer.initializeDatabase();
    print('数据库初始化完成！');
    
    // 初始化数据库连接
    print('正在连接数据库...');
    final dbHelper = await DatabaseHelper.instance;
    print('数据库连接成功！');
    
    // 创建 InventoryProvider 实例
    print('正在创建 InventoryProvider...');
    final inventoryProvider = InventoryProvider(dbHelper);
    print('InventoryProvider 创建成功！');
    
    // 加载库存数据
    print('正在加载库存数据...');
    await inventoryProvider.loadInventory();
    print('库存数据加载完成！');
    
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: inventoryProvider,
          ),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e) {
    print('应用程序启动失败：$e');
    // 显示错误对话框
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('应用程序启动失败：$e'),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '服务器配件管理系统',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
} 