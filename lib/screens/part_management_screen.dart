import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/inventory_provider.dart';
import '../models/part.dart';

class PartManagementScreen extends StatefulWidget {
  const PartManagementScreen({super.key});

  @override
  State<PartManagementScreen> createState() => _PartManagementScreenState();
}

class _PartManagementScreenState extends State<PartManagementScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<InventoryProvider>().loadParts(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('配件管理'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddPartDialog(context),
          ),
        ],
      ),
      body: Consumer<InventoryProvider>(
        builder: (context, provider, child) {
          final parts = provider.parts;
          print('配件总数: ${parts.length}');
          if (parts.isEmpty) {
            return const Center(
              child: Text('暂无配件数据'),
            );
          }

          return ListView.builder(
            itemCount: parts.length,
            itemBuilder: (context, index) {
              final part = parts[index];
              print('配件 ${index + 1}:');
              print('序列号: ${part.serialNumber}');
              print('型号: ${part.model}');
              print('类型: ${part.type}');
              print('状态: ${part.currentStatus}');
              print('采购成本: ${part.purchaseCost}');
              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: ListTile(
                  title: Text(part.model),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('序列号: ${part.serialNumber}'),
                      Text('类型: ${part.type}'),
                      Text('状态: ${part.currentStatus}'),
                      Text('采购成本: ¥${part.purchaseCost.toStringAsFixed(2)}'),
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
                        _showEditPartDialog(context, part);
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

  void _showAddPartDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String serialNumber = '';
    String type = '';
    String model = '';
    double purchaseCost = 0.0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('添加新配件'),
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
                decoration: const InputDecoration(labelText: '类型'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入类型';
                  }
                  return null;
                },
                onSaved: (value) => type = value!,
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
                final part = Part(
                  serialNumber: serialNumber,
                  type: type,
                  model: model,
                  purchaseCost: purchaseCost,
                  currentStatus: 'In Stock',
                  purchaseDate: DateTime.now(),
                  lastModifiedDate: DateTime.now(),
                );
                context.read<InventoryProvider>().addPart(part);
                Navigator.pop(context);
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  void _showEditPartDialog(BuildContext context, Part part) {
    final formKey = GlobalKey<FormState>();
    String type = part.type;
    String model = part.model;
    double purchaseCost = part.purchaseCost;
    String currentStatus = part.currentStatus;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('编辑配件'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: type,
                decoration: const InputDecoration(labelText: '类型'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入类型';
                  }
                  return null;
                },
                onSaved: (value) => type = value!,
              ),
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
                    value: 'Scrapped',
                    child: Text('已报废'),
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
                final updatedPart = Part(
                  id: part.id,
                  serialNumber: part.serialNumber,
                  type: type,
                  model: model,
                  purchaseCost: purchaseCost,
                  currentStatus: currentStatus,
                  sourceServerId: part.sourceServerId,
                  currentServerId: part.currentServerId,
                  purchaseDate: part.purchaseDate,
                  lastModifiedDate: DateTime.now(),
                );
                context.read<InventoryProvider>().updatePart(updatedPart);
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