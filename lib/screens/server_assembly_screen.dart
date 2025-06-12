import 'package:flutter/material.dart';
import '../models/server.dart';
import '../models/part.dart';
import '../providers/inventory_provider.dart';
import '../widgets/server_form.dart';
import 'package:provider/provider.dart';

class ServerAssemblyScreen extends StatelessWidget {
  const ServerAssemblyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<InventoryProvider>(
      builder: (context, inventoryProvider, child) {
        final servers = inventoryProvider.servers;
        return Scaffold(
          appBar: AppBar(
            title: const Text('服务器组装'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _showServerDialog(context, inventoryProvider),
              ),
            ],
          ),
          body: ListView.builder(
            itemCount: servers.length,
            itemBuilder: (context, index) {
              final server = servers[index];
              return ListTile(
                title: Text(server.model),
                subtitle: Text('${server.serialNumber} - ${server.manufacturer}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(server.currentStatus),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showServerDialog(context, inventoryProvider, server),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteServer(context, inventoryProvider, server),
                    ),
                  ],
                ),
                onTap: () => _showServerDetails(context, server),
              );
            },
          ),
        );
      },
    );
  }

  void _showServerDialog(BuildContext context, InventoryProvider inventoryProvider, [Server? server]) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(server == null ? '添加服务器' : '编辑服务器'),
        content: SizedBox(
          width: 600,
          child: ServerForm(
            server: server,
            onSubmit: (updatedServer) async {
              if (server == null) {
                await inventoryProvider.addServer(updatedServer);
              } else {
                await inventoryProvider.updateServer(updatedServer);
              }
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
      ),
    );
  }

  void _deleteServer(BuildContext context, InventoryProvider inventoryProvider, Server server) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除服务器 ${server.model} 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              await inventoryProvider.deleteServer(server.id!);
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  void _showServerDetails(BuildContext context, Server server) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(server.model),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('序列号: ${server.serialNumber}'),
              Text('制造商: ${server.manufacturer}'),
              Text('规格: ${server.specifications}'),
              Text('采购成本: ${server.purchaseCost}'),
              Text('销售价格: ${server.sellingPrice}'),
              Text('数量: ${server.quantity}'),
              Text('位置: ${server.location}'),
              Text('供应商: ${server.supplier}'),
              Text('保修期: ${server.warranty}'),
              Text('当前状态: ${server.currentStatus}'),
              Text('组装日期: ${server.assemblyDate.toIso8601String().split('T')[0]}'),
              Text('最后修改日期: ${server.lastModifiedDate.toIso8601String().split('T')[0]}'),
              const SizedBox(height: 16),
              const Text('配件列表:'),
              const SizedBox(height: 8),
              Consumer<InventoryProvider>(
                builder: (context, inventoryProvider, child) {
                  final parts = inventoryProvider.parts
                      .where((part) => server.partSerialNumbers.contains(part.serialNumber))
                      .toList();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: parts.map((part) => Text('${part.serialNumber} - ${part.model}')).toList(),
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }
} 