import 'package:flutter/material.dart';
import '../models/server.dart';
import '../models/part.dart';
import '../providers/inventory_provider.dart';
import 'package:provider/provider.dart';

class ServerForm extends StatefulWidget {
  final Server? server;
  final Function(Server) onSubmit;

  const ServerForm({
    Key? key,
    this.server,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _ServerFormState createState() => _ServerFormState();
}

class _ServerFormState extends State<ServerForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _serialNumberController;
  late TextEditingController _modelController;
  late TextEditingController _manufacturerController;
  late TextEditingController _specificationsController;
  late TextEditingController _purchaseCostController;
  late TextEditingController _sellingPriceController;
  late TextEditingController _quantityController;
  late TextEditingController _locationController;
  late TextEditingController _supplierController;
  late TextEditingController _warrantyController;
  late TextEditingController _currentStatusController;
  late TextEditingController _assemblyDateController;
  late List<String> _selectedPartSerialNumbers;

  @override
  void initState() {
    super.initState();
    _serialNumberController = TextEditingController(text: widget.server?.serialNumber ?? '');
    _modelController = TextEditingController(text: widget.server?.model ?? '');
    _manufacturerController = TextEditingController(text: widget.server?.manufacturerName ?? '');
    _specificationsController = TextEditingController(text: widget.server?.specifications ?? '');
    _purchaseCostController = TextEditingController(text: widget.server?.purchaseCost.toString() ?? '');
    _sellingPriceController = TextEditingController(text: widget.server?.sellingPrice.toString() ?? '');
    _quantityController = TextEditingController(text: widget.server?.quantity.toString() ?? '');
    _locationController = TextEditingController(text: widget.server?.locationName ?? '');
    _supplierController = TextEditingController(text: widget.server?.supplierName ?? '');
    _warrantyController = TextEditingController(text: widget.server?.warrantyName ?? '');
    _currentStatusController = TextEditingController(text: widget.server?.statusName ?? '');
    _assemblyDateController = TextEditingController(
      text: widget.server?.assemblyDate.toIso8601String().split('T')[0] ?? DateTime.now().toIso8601String().split('T')[0],
    );
    _selectedPartSerialNumbers = widget.server?.partSerialNumbers.split(',') ?? [];
  }

  @override
  void dispose() {
    _serialNumberController.dispose();
    _modelController.dispose();
    _manufacturerController.dispose();
    _specificationsController.dispose();
    _purchaseCostController.dispose();
    _sellingPriceController.dispose();
    _quantityController.dispose();
    _locationController.dispose();
    _supplierController.dispose();
    _warrantyController.dispose();
    _currentStatusController.dispose();
    _assemblyDateController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final server = Server(
        id: widget.server?.id,
        serialNumber: _serialNumberController.text,
        model: _modelController.text,
        manufacturerId: 0, // 需从下拉框获取
        manufacturerName: _manufacturerController.text,
        specifications: _specificationsController.text,
        purchaseCost: double.parse(_purchaseCostController.text),
        sellingPrice: double.parse(_sellingPriceController.text),
        quantity: int.parse(_quantityController.text),
        locationId: 0, // 需从下拉框获取
        locationName: _locationController.text,
        supplierId: 0, // 需从下拉框获取
        supplierName: _supplierController.text,
        warrantyId: 0, // 需从下拉框获取
        warrantyName: _warrantyController.text,
        statusId: 0, // 需从下拉框获取
        statusName: _currentStatusController.text,
        assemblyDate: DateTime.parse(_assemblyDateController.text),
        partSerialNumbers: _selectedPartSerialNumbers.join(','),
        lastModifiedDate: DateTime.now(),
      );
      widget.onSubmit(server);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _serialNumberController,
              decoration: const InputDecoration(labelText: '序列号'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入序列号';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _modelController,
              decoration: const InputDecoration(labelText: '型号'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入型号';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _manufacturerController,
              decoration: const InputDecoration(labelText: '制造商'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入制造商';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _specificationsController,
              decoration: const InputDecoration(labelText: '规格'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入规格';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _purchaseCostController,
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
            ),
            TextFormField(
              controller: _sellingPriceController,
              decoration: const InputDecoration(labelText: '销售价格'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入销售价格';
                }
                if (double.tryParse(value) == null) {
                  return '请输入有效的数字';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(labelText: '数量'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入数量';
                }
                if (int.tryParse(value) == null) {
                  return '请输入有效的整数';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: '位置'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入位置';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _supplierController,
              decoration: const InputDecoration(labelText: '供应商'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入供应商';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _warrantyController,
              decoration: const InputDecoration(labelText: '保修期'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入保修期';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _currentStatusController,
              decoration: const InputDecoration(labelText: '当前状态'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入当前状态';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _assemblyDateController,
              decoration: const InputDecoration(labelText: '组装日期'),
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.parse(_assemblyDateController.text),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() {
                    _assemblyDateController.text = date.toIso8601String().split('T')[0];
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            Consumer<InventoryProvider>(
              builder: (context, inventoryProvider, child) {
                final availableParts = inventoryProvider.parts.where((part) => part.currentServerId == null).toList();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('选择配件：'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: availableParts.map((part) {
                        final isSelected = _selectedPartSerialNumbers.contains(part.serialNumber);
                        return FilterChip(
                          label: Text(part.serialNumber),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedPartSerialNumbers.add(part.serialNumber);
                              } else {
                                _selectedPartSerialNumbers.remove(part.serialNumber);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text(widget.server == null ? '添加服务器' : '更新服务器'),
            ),
          ],
        ),
      ),
    );
  }
} 