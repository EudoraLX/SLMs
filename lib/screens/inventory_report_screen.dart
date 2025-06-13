import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/inventory_provider.dart';
import '../models/part.dart';
import '../models/server.dart';
import 'package:fl_chart/fl_chart.dart';

class InventoryReportScreen extends StatelessWidget {
  const InventoryReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<InventoryProvider>(
      builder: (context, provider, child) {
        final parts = provider.parts;
        final servers = provider.servers;
        final totalParts = parts.fold<int>(0, (sum, p) => sum + (p.quantity ?? 0));
        final totalServers = servers.fold<int>(0, (sum, s) => sum + (s.quantity ?? 0));
        final totalValue = parts.fold<double>(0, (sum, p) => sum + (p.sellingPrice ?? 0) * (p.quantity ?? 0)) +
            servers.fold<double>(0, (sum, s) => sum + (s.sellingPrice ?? 0) * (s.quantity ?? 0));

        // 统计配件类型分布
        final partTypeMap = <String, int>{};
        for (var p in parts) {
          partTypeMap[p.typeName ?? '未知'] = (partTypeMap[p.typeName ?? '未知'] ?? 0) + (p.quantity ?? 0);
        }
        // 统计服务器制造商分布
        final serverManuMap = <String, int>{};
        for (var s in servers) {
          serverManuMap[s.manufacturerName ?? '未知'] = (serverManuMap[s.manufacturerName ?? '未知'] ?? 0) + (s.quantity ?? 0);
        }
        // 统计库存状态分布
        final statusMap = <String, int>{};
        for (var p in parts) {
          statusMap[p.statusName ?? '未知'] = (statusMap[p.statusName ?? '未知'] ?? 0) + (p.quantity ?? 0);
        }
        for (var s in servers) {
          statusMap[s.statusName ?? '未知'] = (statusMap[s.statusName ?? '未知'] ?? 0) + (s.quantity ?? 0);
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildValueCard('配件总数', totalParts.toString()),
                    const SizedBox(width: 16),
                    _buildValueCard('服务器总数', totalServers.toString()),
                    const SizedBox(width: 16),
                    _buildValueCard('总价值', totalValue.toStringAsFixed(2)),
                  ],
                ),
                const SizedBox(height: 24),
                Text('配件类型分布', style: Theme.of(context).textTheme.titleMedium),
                SizedBox(
                  height: 300,
                  child: PieChart(
                    PieChartData(
                      sections: _createPieChartSections(partTypeMap),
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text('库存状态分布', style: Theme.of(context).textTheme.titleMedium),
                SizedBox(
                  height: 300,
                  child: PieChart(
                    PieChartData(
                      sections: _createPieChartSections(statusMap),
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildValueCard(String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _createPieChartSections(Map<String, int> data) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.cyan,
      Colors.amber,
      Colors.teal,
      Colors.brown,
      Colors.pink,
      Colors.indigo,
    ];
    int i = 0;
    return data.entries.map((e) {
      final color = colors[i % colors.length];
      i++;
      return PieChartSectionData(
        color: color,
        value: e.value.toDouble(),
        title: e.key,
        radius: 80,
        titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();
  }
} 