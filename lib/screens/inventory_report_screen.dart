import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/inventory_provider.dart';
import '../services/export_service.dart';

class InventoryReportScreen extends StatelessWidget {
  const InventoryReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('库存报表'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () => _handleExport(context),
            tooltip: '导出报表',
          ),
        ],
      ),
      body: Consumer<InventoryProvider>(
        builder: (context, provider, child) {
          final inStockParts = provider.getInStockParts();
          final soldParts = provider.getSoldParts();
          final inStockServers = provider.getInStockServers();
          final soldServers = provider.getSoldServers();
          final totalInventoryValue = provider.getTotalInventoryValue();
          final totalProfit = provider.getTotalProfit();

          print('库存配件数量: ${inStockParts.length}');
          print('已售配件数量: ${soldParts.length}');
          print('库存服务器数量: ${inStockServers.length}');
          print('已售服务器数量: ${soldServers.length}');
          print('库存总价值: ¥${totalInventoryValue.toStringAsFixed(2)}');
          print('总利润: ¥${totalProfit.toStringAsFixed(2)}');

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCard(
                  context,
                  '库存总览',
                  [
                    '库存配件数量: ${inStockParts.length}',
                    '已售配件数量: ${soldParts.length}',
                    '库存服务器数量: ${inStockServers.length}',
                    '已售服务器数量: ${soldServers.length}',
                    '库存总价值: ¥${totalInventoryValue.toStringAsFixed(2)}',
                    '总利润: ¥${totalProfit.toStringAsFixed(2)}',
                  ],
                ),
                const SizedBox(height: 16),
                _buildInventoryDistribution(
                  context,
                  inStockParts.length,
                  soldParts.length,
                  inStockServers.length,
                  soldServers.length,
                ),
                const SizedBox(height: 16),
                _buildInventoryList(context, '库存配件', inStockParts),
                const SizedBox(height: 16),
                _buildInventoryList(context, '已售配件', soldParts),
                const SizedBox(height: 16),
                _buildInventoryList(context, '库存服务器', inStockServers),
                const SizedBox(height: 16),
                _buildInventoryList(context, '已售服务器', soldServers),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, List<String> items) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(item),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryDistribution(
    BuildContext context,
    int inStockParts,
    int soldParts,
    int inStockServers,
    int soldServers,
  ) {
    final totalItems = inStockParts + soldParts + inStockServers + soldServers;
    if (totalItems == 0) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '库存分布',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildDistributionItem('库存配件', inStockParts, totalItems),
            _buildDistributionItem('已售配件', soldParts, totalItems),
            _buildDistributionItem('库存服务器', inStockServers, totalItems),
            _buildDistributionItem('已售服务器', soldServers, totalItems),
          ],
        ),
      ),
    );
  }

  Widget _buildDistributionItem(String label, int count, int total) {
    final percentage = total > 0 ? (count / total * 100).toStringAsFixed(1) : '0.0';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label),
          ),
          Expanded(
            flex: 3,
            child: LinearProgressIndicator(
              value: total > 0 ? count / total : 0,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: Text('$count ($percentage%)'),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryList(
    BuildContext context,
    String title,
    List<dynamic> items,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            if (items.isEmpty)
              const Text('暂无数据')
            else
              ...items.map((item) => ListTile(
                    title: Text(item.model),
                    subtitle: Text('序列号: ${item.serialNumber}'),
                    trailing: Text(
                      '¥${item.purchaseCost.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
          ],
        ),
      ),
    );
  }

  Future<void> _handleExport(BuildContext context) async {
    final provider = context.read<InventoryProvider>();
    final parts = provider.parts;
    final servers = provider.servers;

    try {
      final filePath = await ExportService.exportToCsv(
        parts: parts,
        servers: servers,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('导出成功：$filePath')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('导出失败：$e')),
        );
      }
    }
  }
} 