import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/inventory_provider.dart';
import 'part_management_screen.dart';
import 'server_management_screen.dart';
import 'inventory_report_screen.dart';
import 'server_assembly_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('服务器配件管理系统'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildMenuCard(
            context,
            '配件管理',
            Icons.build,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PartManagementScreen(),
              ),
            ),
          ),
          _buildMenuCard(
            context,
            '服务器管理',
            Icons.computer,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ServerManagementScreen(),
              ),
            ),
          ),
          _buildMenuCard(
            context,
            '库存报表',
            Icons.assessment,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const InventoryReportScreen(),
              ),
            ),
          ),
          _buildMenuCard(
            context,
            '组装/拆解',
            Icons.construction,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ServerAssemblyScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 