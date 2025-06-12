import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:server_parts_management/models/part.dart';
import 'package:server_parts_management/providers/inventory_provider.dart';

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

  // 预选项列表
  final List<String> _partTypes = ['CPU', '内存', '存储', '电源', '主板', '网卡', '显卡', '散热器', '机箱'];
  final List<String> _manufacturers = ['Intel', 'AMD', 'Samsung', 'Dell', 'HPE', 'Lenovo', 'Cisco', 'NVIDIA', '其他'];
  final List<String> _locations = ['仓库A', '仓库B', '仓库C', '维修区', '展示区'];
  final List<String> _suppliers = ['Intel官方', 'AMD官方', 'Samsung官方', 'Dell官方', 'HPE官方', 'Lenovo官方', '其他'];
  final List<String> _warrantyPeriods = ['1年', '2年', '3年', '5年', '终身'];
  final List<String> _statuses = ['In Stock', 'In Use', 'Sold', 'Repair', 'Scrapped'];

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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final part = Part(
        id: widget.part?.id,
        serialNumber: _serialNumberController.text,
        typeId: 0, // 需要从预选项获取id
        typeName: _typeController.text,
        model: _modelController.text,
        manufacturerId: 0, // 需要从预选项获取id
        manufacturerName: _manufacturerController.text,
        specifications: _specificationsController.text,
        purchaseCost: double.parse(_purchaseCostController.text),
        sellingPrice: double.parse(_sellingPriceController.text),
        quantity: int.parse(_quantityController.text),
        locationId: 0, // 需要从预选项获取id
        locationName: _locationController.text,
        supplierId: 0, // 需要从预选项获取id
        supplierName: _supplierController.text,
        warrantyId: 0, // 需要从预选项获取id
        warrantyName: _warrantyController.text,
        statusId: 0, // 需要从预选项获取id
        statusName: _currentStatusController.text,
        sourceServerId: int.tryParse(_sourceServerIdController.text),
        currentServerId: int.tryParse(_currentServerIdController.text),
        purchaseDate: _purchaseDate,
        lastModifiedDate: _lastModifiedDate,
      );
      widget.onSubmit(part);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            DropdownButtonFormField<String>(
              value: _typeController.text.isEmpty ? null : _typeController.text,
              decoration: const InputDecoration(labelText: '类型'),
              items: _partTypes.map((type) => DropdownMenuItem(
                value: type,
                child: Text(type),
              )).toList(),
              onChanged: (value) {
                if (value != null) {
                  _typeController.text = value;
                }
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
            DropdownButtonFormField<String>(
              value: _manufacturerController.text.isEmpty ? null : _manufacturerController.text,
              decoration: const InputDecoration(labelText: '制造商'),
              items: _manufacturers.map((manufacturer) => DropdownMenuItem(
                value: manufacturer,
                child: Text(manufacturer),
              )).toList(),
              onChanged: (value) {
                if (value != null) {
                  _manufacturerController.text = value;
                }
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
            DropdownButtonFormField<String>(
              value: _locationController.text.isEmpty ? null : _locationController.text,
              decoration: const InputDecoration(labelText: '位置'),
              items: _locations.map((location) => DropdownMenuItem(
                value: location,
                child: Text(location),
              )).toList(),
              onChanged: (value) {
                if (value != null) {
                  _locationController.text = value;
                }
              },
              validator: (value) => value == null ? '请选择位置' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _supplierController.text.isEmpty ? null : _supplierController.text,
              decoration: const InputDecoration(labelText: '供应商'),
              items: _suppliers.map((supplier) => DropdownMenuItem(
                value: supplier,
                child: Text(supplier),
              )).toList(),
              onChanged: (value) {
                if (value != null) {
                  _supplierController.text = value;
                }
              },
              validator: (value) => value == null ? '请选择供应商' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _warrantyController.text.isEmpty ? null : _warrantyController.text,
              decoration: const InputDecoration(labelText: '保修期'),
              items: _warrantyPeriods.map((warranty) => DropdownMenuItem(
                value: warranty,
                child: Text(warranty),
              )).toList(),
              onChanged: (value) {
                if (value != null) {
                  _warrantyController.text = value;
                }
              },
              validator: (value) => value == null ? '请选择保修期' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _currentStatusController.text.isEmpty ? null : _currentStatusController.text,
              decoration: const InputDecoration(labelText: '当前状态'),
              items: _statuses.map((status) => DropdownMenuItem(
                value: status,
                child: Text(status),
              )).toList(),
              onChanged: (value) {
                if (value != null) {
                  _currentStatusController.text = value;
                }
              },
              validator: (value) => value == null ? '请选择当前状态' : null,
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
              child: Text(widget.part == null ? '添加配件' : '更新配件'),
            ),
          ],
        ),
      ),
    );
  }
} 