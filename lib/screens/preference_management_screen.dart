import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/preference_provider.dart';

class PreferenceManagementScreen extends StatefulWidget {
  const PreferenceManagementScreen({super.key});

  @override
  State<PreferenceManagementScreen> createState() => _PreferenceManagementScreenState();
}

class _PreferenceManagementScreenState extends State<PreferenceManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PreferenceProvider>(context, listen: false).loadAllPreferences();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferenceProvider>(
      builder: (context, provider, child) {
        return DefaultTabController(
          length: 8,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('预选项管理'),
              bottom: const TabBar(
                isScrollable: true,
                tabs: [
                  Tab(text: '配件类型'),
                  Tab(text: '制造商'),
                  Tab(text: '位置'),
                  Tab(text: '供应商'),
                  Tab(text: '保修期'),
                  Tab(text: '状态类型'),
                  Tab(text: '支付方式'),
                  Tab(text: '操作类型'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _PreferenceList(
                  title: '配件类型',
                  fields: ['名称', '描述'],
                  onAdd: (values) async {
                    await provider.addPartType(values[0], values[1]);
                  },
                  onEdit: (id, values) async {
                    await provider.updatePartType(id, values[0], values[1]);
                  },
                  onDelete: (id) async {
                    await provider.deletePartType(id);
                  },
                  data: provider.partTypes,
                ),
                _PreferenceList(
                  title: '制造商',
                  fields: ['名称', '网站', '联系信息'],
                  onAdd: (values) async {
                    await provider.addManufacturer(values[0], values[1], values[2]);
                  },
                  onEdit: (id, values) async {
                    await provider.updateManufacturer(id, values[0], values[1], values[2]);
                  },
                  onDelete: (id) async {
                    await provider.deleteManufacturer(id);
                  },
                  data: provider.manufacturers,
                ),
                _PreferenceList(
                  title: '位置',
                  fields: ['名称', '地址', '容量'],
                  onAdd: (values) async {
                    final capacity = int.tryParse(values[2]);
                    if (capacity != null) {
                      await provider.addLocation(values[0], values[1], capacity);
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('请输入有效的容量值')),
                        );
                      }
                    }
                  },
                  onEdit: (id, values) async {
                    final capacity = int.tryParse(values[2]);
                    if (capacity != null) {
                      await provider.updateLocation(id, values[0], values[1], capacity);
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('请输入有效的容量值')),
                        );
                      }
                    }
                  },
                  onDelete: (id) async {
                    await provider.deleteLocation(id);
                  },
                  data: provider.locations,
                ),
                _PreferenceList(
                  title: '供应商',
                  fields: ['名称', '联系人', '电话', '邮箱', '地址'],
                  onAdd: (values) async {
                    await provider.addSupplier(values[0], values[1], values[2], values[3], values[4]);
                  },
                  onEdit: (id, values) async {
                    await provider.updateSupplier(id, values[0], values[1], values[2], values[3], values[4]);
                  },
                  onDelete: (id) async {
                    await provider.deleteSupplier(id);
                  },
                  data: provider.suppliers,
                ),
                _PreferenceList(
                  title: '保修期',
                  fields: ['名称', '月数', '描述'],
                  onAdd: (values) async {
                    await provider.addWarrantyPeriod(values[0], int.parse(values[1]), values[2]);
                  },
                  onEdit: (id, values) async {
                    await provider.updateWarrantyPeriod(id, values[0], int.parse(values[1]), values[2]);
                  },
                  onDelete: (id) async {
                    await provider.deleteWarrantyPeriod(id);
                  },
                  data: provider.warrantyPeriods,
                ),
                _PreferenceList(
                  title: '状态类型',
                  fields: ['名称', '描述'],
                  onAdd: (values) async {
                    await provider.addStatusType(values[0], values[1]);
                  },
                  onEdit: (id, values) async {
                    await provider.updateStatusType(id, values[0], values[1]);
                  },
                  onDelete: (id) async {
                    await provider.deleteStatusType(id);
                  },
                  data: provider.statusTypes,
                ),
                _PreferenceList(
                  title: '支付方式',
                  fields: ['名称', '描述'],
                  onAdd: (values) async {
                    await provider.addPaymentMethod(values[0], values[1]);
                  },
                  onEdit: (id, values) async {
                    await provider.updatePaymentMethod(id, values[0], values[1]);
                  },
                  onDelete: (id) async {
                    await provider.deletePaymentMethod(id);
                  },
                  data: provider.paymentMethods,
                ),
                _PreferenceList(
                  title: '操作类型',
                  fields: ['名称', '描述'],
                  onAdd: (values) async {
                    await provider.addOperationType(values[0], values[1]);
                  },
                  onEdit: (id, values) async {
                    await provider.updateOperationType(id, values[0], values[1]);
                  },
                  onDelete: (id) async {
                    await provider.deleteOperationType(id);
                  },
                  data: provider.operationTypes,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PreferenceList extends StatelessWidget {
  final String title;
  final List<String> fields;
  final Function(List<String>) onAdd;
  final Function(int, List<String>) onEdit;
  final Function(int) onDelete;
  final List<Map<String, dynamic>> data;

  const _PreferenceList({
    required this.title,
    required this.fields,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
    required this.data,
  });

  String _toStr(dynamic v) {
    if (v == null) return '';
    if (v is String) return v;
    if (v is List<int>) return String.fromCharCodes(v);
    return v.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('添加'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(_toStr(item['name'])),
                  subtitle: Text(_toStr(item['description'])),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showEditDialog(context, item['id']),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _showDeleteDialog(context, item['id']),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showAddDialog(BuildContext context) {
    final controllers = List.generate(
      fields.length,
      (index) => TextEditingController(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('添加$title'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < fields.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: controllers[i],
                    decoration: InputDecoration(
                      labelText: fields[i],
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              final values = controllers.map((c) => c.text).toList();
              onAdd(values);
              Navigator.pop(context);
            },
            child: const Text('添加'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, int id) {
    final item = data.firstWhere((item) => item['id'] == id);
    final controllers = List.generate(
      fields.length,
      (index) => TextEditingController(text: _toStr(item[fields[index].toLowerCase()]?.toString()) ?? ''),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('编辑$title'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < fields.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: controllers[i],
                    decoration: InputDecoration(
                      labelText: fields[i],
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              final values = controllers.map((c) => c.text).toList();
              onEdit(id, values);
              Navigator.pop(context);
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('删除$title'),
        content: const Text('确定要删除这个项目吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              onDelete(id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
} 