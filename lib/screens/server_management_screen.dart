import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/inventory_provider.dart';
import '../models/server.dart';

class ServerManagementScreen extends StatefulWidget {
  const ServerManagementScreen({super.key});

  @override
  State<ServerManagementScreen> createState() => _ServerManagementScreenState();
}

class _ServerManagementScreenState extends State<ServerManagementScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<InventoryProvider>().loadServers(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('服务器管理'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddServerDialog(context),
          ),
        ],
      ),
      body: Consumer<InventoryProvider>(
        builder: (context, provider, child) {
          final servers = provider.servers;
          print('服务器总数: ${servers.length}');
          if (servers.isEmpty) {
            return const Center(
              child: Text('暂无服务器数据'),
            );
          }

          return ListView.builder(
            itemCount: servers.length,
            itemBuilder: (context, index) {
              final server = servers[index];
              print('服务器 ${index + 1}:');
              print('序列号: ${server.serialNumber}');
              print('型号: ${server.model}');
              print('状态: ${server.currentStatus}');
              print('采购成本: ${server.purchaseCost}');
              print('组装日期: ${server.assemblyDate}');
              print('配件数量: ${server.partSerialNumbers.length}');
              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: ListTile(
                  title: Text(server.model),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('序列号: ${server.serialNumber}'),
                      Text('状态: ${server.currentStatus}'),
                      Text('采购成本: ¥${server.purchaseCost.toStringAsFixed(2)}'),
                      Text('组装日期: ${server.assemblyDate.toString().split(' ')[0]}'),
                      Text('配件数量: ${server.partSerialNumbers.length}'),
                    ],
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('编辑'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('删除'),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showEditServerDialog(context, server);
                      } else if (value == 'delete') {
                        // TODO: 实现删除功能
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddServerDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String serialNumber = '';
    String model = '';
    double purchaseCost = 0.0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('添加新服务器'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: '序列号'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入序列号';
                  }
                  return null;
                },
                onSaved: (value) => serialNumber = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: '型号'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入型号';
                  }
                  return null;
                },
                onSaved: (value) => model = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: '采购成本'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入采购成本';
                  }
                  if (double.tryParse(value) == null) {
                    return '请输入有效的数字';
                  }
                  return null;
                },
                onSaved: (value) => purchaseCost = double.parse(value!),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                final server = Server(
                  serialNumber: serialNumber,
                  model: model,
                  purchaseCost: purchaseCost,
                  currentStatus: 'In Stock',
                  assemblyDate: DateTime.now(),
                  lastModifiedDate: DateTime.now(),
                  partSerialNumbers: [],
                );
                context.read<InventoryProvider>().addServer(server);
                Navigator.pop(context);
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  void _showEditServerDialog(BuildContext context, Server server) {
    final formKey = GlobalKey<FormState>();
    String model = server.model;
    double purchaseCost = server.purchaseCost;
    String currentStatus = server.currentStatus;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('编辑服务器'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: model,
                decoration: const InputDecoration(labelText: '型号'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入型号';
                  }
                  return null;
                },
                onSaved: (value) => model = value!,
              ),
              TextFormField(
                initialValue: purchaseCost.toString(),
                decoration: const InputDecoration(labelText: '采购成本'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入采购成本';
                  }
                  if (double.tryParse(value) == null) {
                    return '请输入有效的数字';
                  }
                  return null;
                },
                onSaved: (value) => purchaseCost = double.parse(value!),
              ),
              DropdownButtonFormField<String>(
                value: currentStatus,
                decoration: const InputDecoration(labelText: '状态'),
                items: const [
                  DropdownMenuItem(
                    value: 'In Stock',
                    child: Text('库存中'),
                  ),
                  DropdownMenuItem(
                    value: 'Assembled',
                    child: Text('已组装'),
                  ),
                  DropdownMenuItem(
                    value: 'Sold',
                    child: Text('已售出'),
                  ),
                  DropdownMenuItem(
                    value: 'Disassembled',
                    child: Text('已拆解'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    currentStatus = value;
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                final updatedServer = Server(
                  id: server.id,
                  serialNumber: server.serialNumber,
                  model: model,
                  purchaseCost: purchaseCost,
                  currentStatus: currentStatus,
                  assemblyDate: server.assemblyDate,
                  lastModifiedDate: DateTime.now(),
                  partSerialNumbers: server.partSerialNumbers,
                );
                context.read<InventoryProvider>().updateServer(updatedServer);
                Navigator.pop(context);
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }
} 