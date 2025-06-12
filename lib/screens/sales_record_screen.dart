import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:server_parts_management/providers/inventory_provider.dart';
import 'package:server_parts_management/models/sale.dart';

class SalesRecordScreen extends StatelessWidget {
  const SalesRecordScreen({super.key});

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
                '销售记录',
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
                          DataColumn(label: Text('项目类型')),
                          DataColumn(label: Text('序列号')),
                          DataColumn(label: Text('客户')),
                          DataColumn(label: Text('数量')),
                          DataColumn(label: Text('单价')),
                          DataColumn(label: Text('总金额')),
                          DataColumn(label: Text('销售日期')),
                          DataColumn(label: Text('支付方式')),
                          DataColumn(label: Text('备注')),
                        ],
                        rows: provider.sales.map((sale) {
                          return DataRow(
                            cells: [
                              DataCell(Text(sale.itemType)),
                              DataCell(Text(sale.serialNumber)),
                              DataCell(Text(sale.customer)),
                              DataCell(Text(sale.quantity.toString())),
                              DataCell(Text(sale.unitPrice.toString())),
                              DataCell(Text(sale.totalAmount.toString())),
                              DataCell(Text(sale.saleDate.toString())),
                              DataCell(Text(sale.paymentMethod)),
                              DataCell(Text(sale.notes)),
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