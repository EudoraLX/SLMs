import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:server_parts_management/providers/inventory_provider.dart';
import 'package:server_parts_management/providers/preference_provider.dart';
import 'package:server_parts_management/screens/inventory_report_screen.dart';
import 'package:server_parts_management/screens/parts_management_screen.dart';
import 'package:server_parts_management/screens/server_management_screen.dart';
import 'package:server_parts_management/screens/sales_record_screen.dart';
import 'package:server_parts_management/screens/operation_log_screen.dart';
import 'package:server_parts_management/screens/preference_management_screen.dart';
import 'package:server_parts_management/database/init_database.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await DatabaseInitializer.initializeDatabase();
    runApp(const MyApp());
  } catch (e) {
    print('应用程序启动失败：$e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InventoryProvider()),
        ChangeNotifierProvider(create: (_) => PreferenceProvider()),
      ],
      child: MaterialApp(
        title: '服务器配件管理系统',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 1200;
        final isMediumScreen = constraints.maxWidth > 800;

        return Scaffold(
          appBar: AppBar(
            title: const Text('服务器配件管理系统'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: Row(
            children: [
              if (isWideScreen || isMediumScreen)
                NavigationRail(
                  extended: isWideScreen,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.dashboard),
                      label: Text('仪表盘'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.memory),
                      label: Text('配件管理'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.computer),
                      label: Text('服务器管理'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.shopping_cart),
                      label: Text('销售管理'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.assessment),
                      label: Text('库存报表'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings),
                      label: Text('预选项管理'),
                    ),
                  ],
                  selectedIndex: 0,
                  onDestinationSelected: (index) {
                    // TODO: 实现导航
                  },
                ),
              Expanded(
                child: HomeScreen(),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // TODO: 实现添加功能
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const PartsManagementScreen(),
    const ServerManagementScreen(),
    const InventoryReportScreen(),
    const PreferenceManagementScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('服务器配件管理系统'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Row(
        children: [
          NavigationRail(
            extended: true,
            minExtendedWidth: 180,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.memory),
                label: Text('配件管理'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.dns),
                label: Text('服务器管理'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.assessment),
                label: Text('库存报表'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text('预选项管理'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _screens[_selectedIndex],
          ),
        ],
      ),
    );
  }
} 