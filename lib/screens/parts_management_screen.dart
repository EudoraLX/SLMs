import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:server_parts_management/models/part.dart';
import 'package:server_parts_management/providers/inventory_provider.dart';
import 'package:server_parts_management/widgets/part_form.dart';

class PartsManagementScreen extends StatelessWidget {
  const PartsManagementScreen({super.key});

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
                    '配件管理',
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
                          title: const Text('添加配件'),
                          content: SingleChildScrollView(
                            child: PartForm(
                              onSubmit: (part) async {
                                try {
                                  await provider.addPart(part);
                                  Navigator.pop(context);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('添加配件失败: $e')),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('添加配件'),
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
                        DataColumn(label: Text('类型')),
                        DataColumn(label: Text('型号')),
                        DataColumn(label: Text('数量')),
                        DataColumn(label: Text('状态')),
                        DataColumn(label: Text('操作')),
                      ],
                      rows: provider.parts.map((part) {
                        return DataRow(
                          cells: [
                            DataCell(Text(part.serialNumber)),
                            DataCell(Text(part.typeName ?? '')),
                            DataCell(Text(part.model)),
                            DataCell(Text(part.quantity.toString())),
                            DataCell(Text(part.statusName ?? '')),
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
                                          title: const Text('编辑配件'),
                                          content: SingleChildScrollView(
                                            child: PartForm(
                                              part: part,
                                              onSubmit: (updatedPart) async {
                                                try {
                                                  await provider.updatePart(updatedPart);
                                                  Navigator.pop(context);
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('更新配件失败: $e')),
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
                                    onPressed: () async {
                                      try {
                                        await provider.deletePart(part.id!);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('配件已删除')),
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('删除配件失败: $e')),
                                        );
                                      }
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