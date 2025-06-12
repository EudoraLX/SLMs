import 'package:flutter/material.dart';
import '../models/part.dart';
import '../providers/inventory_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/part_form.dart';

class PartManagementScreen extends StatelessWidget {
  const PartManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<InventoryProvider>(
      builder: (context, inventoryProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('配件管理'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => inventoryProvider.loadParts(),
              ),
            ],
          ),
          body: ListView.builder(
            itemCount: inventoryProvider.parts.length,
            itemBuilder: (context, index) {
              final part = inventoryProvider.parts[index];
              return ListTile(
                title: Text('${part.model} (${part.serialNumber})'),
                subtitle: Text('${part.typeName} - ${part.manufacturerName}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showPartDialog(context, part),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deletePart(context, part),
                    ),
                  ],
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showPartDialog(context, null),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _showPartDialog(BuildContext context, Part? part) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(part == null ? '添加配件' : '编辑配件'),
        content: SizedBox(
          width: 400,
          child: PartForm(
            part: part,
            onSubmit: (updatedPart) {
              if (part == null) {
                context.read<InventoryProvider>().addPart(updatedPart);
              } else {
                context.read<InventoryProvider>().updatePart(updatedPart);
              }
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }

  void _deletePart(BuildContext context, Part part) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除配件 ${part.serialNumber} 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              context.read<InventoryProvider>().deletePart(part.id!);
              Navigator.of(context).pop();
            },
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
} 