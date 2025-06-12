import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:server_parts_management/providers/inventory_provider.dart';
import 'package:server_parts_management/models/operation_log.dart';

class OperationLogScreen extends StatelessWidget {
  const OperationLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<InventoryProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '操作日志',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Card(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('操作类型')),
                          DataColumn(label: Text('项目类型')),
                          DataColumn(label: Text('序列号')),
                          DataColumn(label: Text('操作日期')),
                          DataColumn(label: Text('操作人')),
                          DataColumn(label: Text('详细信息')),
                        ],
                        rows: provider.operationLogs.map((log) {
                          return DataRow(
                            cells: [
                              DataCell(Text(log.operationType)),
                              DataCell(Text(log.itemType)),
                              DataCell(Text(log.serialNumber)),
                              DataCell(Text(log.operationDate.toString())),
                              DataCell(Text(log.operator)),
                              DataCell(Text(log.details)),
                            ],
                          );
                        }).toList(),
                      ),
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