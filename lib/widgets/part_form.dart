import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:server_parts_management/models/part.dart';
import 'package:server_parts_management/providers/inventory_provider.dart';
import 'package:server_parts_management/providers/preference_provider.dart';

class PartForm extends StatefulWidget {
  final Part? part;
  final Function(Part) onSubmit;

  const PartForm({Key? key, this.part, required this.onSubmit}) : super(key: key);

  @override
  _PartFormState createState() => _PartFormState();
}

class _PartFormState extends State<PartForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _serialNumberController;
  late TextEditingController _typeController;
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
  late TextEditingController _sourceServerIdController;
  late TextEditingController _currentServerIdController;
  late DateTime _purchaseDate;
  late DateTime _lastModifiedDate;

  @override
  void initState() {
    super.initState();
    _serialNumberController = TextEditingController(text: widget.part?.serialNumber ?? '');
    _typeController = TextEditingController(text: widget.part?.typeName ?? '');
    _modelController = TextEditingController(text: widget.part?.model ?? '');
    _manufacturerController = TextEditingController(text: widget.part?.manufacturerName ?? '');
    _specificationsController = TextEditingController(text: widget.part?.specifications ?? '');
    _purchaseCostController = TextEditingController(text: widget.part?.purchaseCost.toString() ?? '');
    _sellingPriceController = TextEditingController(text: widget.part?.sellingPrice.toString() ?? '');
    _quantityController = TextEditingController(text: widget.part?.quantity.toString() ?? '');
    _locationController = TextEditingController(text: widget.part?.locationName ?? '');
    _supplierController = TextEditingController(text: widget.part?.supplierName ?? '');
    _warrantyController = TextEditingController(text: widget.part?.warrantyName ?? '');
    _currentStatusController = TextEditingController(text: widget.part?.statusName ?? '');
    _sourceServerIdController = TextEditingController(text: widget.part?.sourceServerId?.toString() ?? '');
    _currentServerIdController = TextEditingController(text: widget.part?.currentServerId?.toString() ?? '');
    _purchaseDate = widget.part?.purchaseDate ?? DateTime.now();
    _lastModifiedDate = widget.part?.lastModifiedDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _serialNumberController.dispose();
    _typeController.dispose();
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
    _sourceServerIdController.dispose();
    _currentServerIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final preferenceProvider = Provider.of<PreferenceProvider>(context);
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _serialNumberController,
              decoration: const InputDecoration(labelText: '序列号'),
              validator: (value) => value?.isEmpty ?? true ? '请输入序列号' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: widget.part?.typeId,
              decoration: const InputDecoration(labelText: '类型'),
              items: preferenceProvider.partTypes
                .map<DropdownMenuItem<int>>((type) => DropdownMenuItem<int>(
                  value: type['id'] as int,
                  child: Text(type['name']),
                )).toList(),
              onChanged: (value) {
                setState(() {
                  _typeController.text = preferenceProvider.partTypes.firstWhere((t) => t['id'] == value)['name'];
                });
              },
              validator: (value) => value == null ? '请选择类型' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _modelController,
              decoration: const InputDecoration(labelText: '型号'),
              validator: (value) => value?.isEmpty ?? true ? '请输入型号' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: widget.part?.manufacturerId,
              decoration: const InputDecoration(labelText: '制造商'),
              items: preferenceProvider.manufacturers
                .map<DropdownMenuItem<int>>((m) => DropdownMenuItem<int>(
                  value: m['id'] as int,
                  child: Text(m['name']),
                )).toList(),
              onChanged: (value) {
                setState(() {
                  _manufacturerController.text = preferenceProvider.manufacturers.firstWhere((m) => m['id'] == value)['name'];
                });
              },
              validator: (value) => value == null ? '请选择制造商' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _specificationsController,
              decoration: const InputDecoration(labelText: '规格'),
              maxLines: 3,
              validator: (value) => value?.isEmpty ?? true ? '请输入规格' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _purchaseCostController,
              decoration: const InputDecoration(labelText: '采购成本'),
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true ? '请输入采购成本' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _sellingPriceController,
              decoration: const InputDecoration(labelText: '销售价格'),
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true ? '请输入销售价格' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(labelText: '数量'),
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true ? '请输入数量' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: widget.part?.locationId,
              decoration: const InputDecoration(labelText: '位置'),
              items: preferenceProvider.locations
                .map<DropdownMenuItem<int>>((l) => DropdownMenuItem<int>(
                  value: l['id'] as int,
                  child: Text(l['name']),
                )).toList(),
              onChanged: (value) {
                setState(() {
                  _locationController.text = preferenceProvider.locations.firstWhere((l) => l['id'] == value)['name'];
                });
              },
              validator: (value) => value == null ? '请选择位置' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: widget.part?.supplierId,
              decoration: const InputDecoration(labelText: '供应商'),
              items: preferenceProvider.suppliers
                .map<DropdownMenuItem<int>>((s) => DropdownMenuItem<int>(
                  value: s['id'] as int,
                  child: Text(s['name']),
                )).toList(),
              onChanged: (value) {
                setState(() {
                  _supplierController.text = preferenceProvider.suppliers.firstWhere((s) => s['id'] == value)['name'];
                });
              },
              validator: (value) => value == null ? '请选择供应商' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: widget.part?.warrantyId,
              decoration: const InputDecoration(labelText: '保修期'),
              items: preferenceProvider.warrantyPeriods
                .map<DropdownMenuItem<int>>((w) => DropdownMenuItem<int>(
                  value: w['id'] as int,
                  child: Text(w['name']),
                )).toList(),
              onChanged: (value) {
                setState(() {
                  _warrantyController.text = preferenceProvider.warrantyPeriods.firstWhere((w) => w['id'] == value)['name'];
                });
              },
              validator: (value) => value == null ? '请选择保修期' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: widget.part?.statusId,
              decoration: const InputDecoration(labelText: '状态'),
              items: preferenceProvider.statusTypes
                .map<DropdownMenuItem<int>>((st) => DropdownMenuItem<int>(
                  value: st['id'] as int,
                  child: Text(st['name']),
                )).toList(),
              onChanged: (value) {
                setState(() {
                  _currentStatusController.text = preferenceProvider.statusTypes.firstWhere((st) => st['id'] == value)['name'];
                });
              },
              validator: (value) => value == null ? '请选择状态' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _sourceServerIdController,
              decoration: const InputDecoration(labelText: '来源服务器ID'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _currentServerIdController,
              decoration: const InputDecoration(labelText: '当前服务器ID'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('采购日期'),
              subtitle: Text(_purchaseDate.toString().split('.')[0]),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _purchaseDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() {
                    _purchaseDate = date;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('提交'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final preferenceProvider = Provider.of<PreferenceProvider>(context, listen: false);
      final part = Part(
        id: widget.part?.id,
        serialNumber: _serialNumberController.text,
        typeId: preferenceProvider.partTypes.firstWhere((t) => t['name'] == _typeController.text)['id'],
        typeName: _typeController.text,
        model: _modelController.text,
        manufacturerId: preferenceProvider.manufacturers.firstWhere((m) => m['name'] == _manufacturerController.text)['id'],
        manufacturerName: _manufacturerController.text,
        specifications: _specificationsController.text,
        purchaseCost: double.parse(_purchaseCostController.text),
        sellingPrice: double.parse(_sellingPriceController.text),
        quantity: int.parse(_quantityController.text),
        locationId: preferenceProvider.locations.firstWhere((l) => l['name'] == _locationController.text)['id'],
        locationName: _locationController.text,
        supplierId: preferenceProvider.suppliers.firstWhere((s) => s['name'] == _supplierController.text)['id'],
        supplierName: _supplierController.text,
        warrantyId: preferenceProvider.warrantyPeriods.firstWhere((w) => w['name'] == _warrantyController.text)['id'],
        warrantyName: _warrantyController.text,
        statusId: preferenceProvider.statusTypes.firstWhere((st) => st['name'] == _currentStatusController.text)['id'],
        statusName: _currentStatusController.text,
        sourceServerId: int.tryParse(_sourceServerIdController.text),
        currentServerId: int.tryParse(_currentServerIdController.text),
        purchaseDate: _purchaseDate,
        lastModifiedDate: _lastModifiedDate,
      );
      widget.onSubmit(part);
    }
  }
} 