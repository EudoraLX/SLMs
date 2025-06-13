import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:server_parts_management/models/server.dart';
import 'package:server_parts_management/providers/inventory_provider.dart';
import 'package:server_parts_management/widgets/server_form.dart';

class ServerManagementScreen extends StatelessWidget {
  const ServerManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<InventoryProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '服务器管理',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('添加服务器'),
                          content: SingleChildScrollView(
                            child: ServerForm(
                              onSubmit: (server) async {
                                try {
                                  await provider.addServer(server);
                                  Navigator.pop(context);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('添加服务器失败: $e')),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('添加服务器'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Card(
                  elevation: 2,
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('序列号')),
                        DataColumn(label: Text('型号')),
                        DataColumn(label: Text('状态')),
                        DataColumn(label: Text('配件数量')),
                        DataColumn(label: Text('操作')),
                      ],
                      rows: provider.servers.map((server) {
                        return DataRow(
                          cells: [
                            DataCell(Text(server.serialNumber)),
                            DataCell(Text(server.model)),
                            DataCell(Text(server.statusName ?? '')),
                            DataCell(Text(server.partSerialNumbers.length.toString())),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('编辑服务器'),
                                          content: SingleChildScrollView(
                                            child: ServerForm(
                                              server: server,
                                              onSubmit: (updatedServer) async {
                                                try {
                                                  await provider.updateServer(updatedServer);
                                                  Navigator.pop(context);
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('更新服务器失败: $e')),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('确认删除'),
                                          content: Text('确定要删除服务器 ${server.serialNumber} 吗？'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text('取消'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                try {
                                                  await provider.deleteServer(server.id!);
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('服务器已删除')),
                                                  );
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('删除服务器失败: $e')),
                                                  );
                                                }
                                              },
                                              child: const Text('删除'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 