import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/inventory_provider.dart';
import '../services/barcode_scanner_service.dart';
import '../models/part.dart';
import '../models/server.dart';

class ServerAssemblyScreen extends StatefulWidget {
  const ServerAssemblyScreen({super.key});

  @override
  State<ServerAssemblyScreen> createState() => _ServerAssemblyScreenState();
}

class _ServerAssemblyScreenState extends State<ServerAssemblyScreen> {
  Server? selectedServer;
  final List<Part> selectedParts = [];
  bool isDisassembly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isDisassembly ? '服务器拆解' : '服务器组装'),
        actions: [
          IconButton(
            icon: Icon(isDisassembly ? Icons.build : Icons.construction),
            onPressed: () {
              setState(() {
                isDisassembly = !isDisassembly;
                selectedServer = null;
                selectedParts.clear();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildServerSelection(),
          const Divider(),
          Expanded(
            child: _buildPartsList(),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildServerSelection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isDisassembly ? '选择要拆解的服务器' : '选择要组装的服务器',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  selectedServer?.serialNumber ?? '未选择服务器',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _scanServerBarcode,
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('扫描服务器条码'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPartsList() {
    if (selectedServer == null) {
      return const Center(
        child: Text('请先选择服务器'),
      );
    }

    return ListView.builder(
      itemCount: selectedParts.length,
      itemBuilder: (context, index) {
        final part = selectedParts[index];
        return ListTile(
          title: Text(part.model),
          subtitle: Text('序列号: ${part.serialNumber}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              setState(() {
                selectedParts.removeAt(index);
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            onPressed: _scanPartBarcode,
            icon: const Icon(Icons.qr_code_scanner),
            label: Text(isDisassembly ? '扫描拆解配件' : '扫描组装配件'),
          ),
          ElevatedButton(
            onPressed: selectedParts.isEmpty ? null : _processAssembly,
            child: Text(isDisassembly ? '确认拆解' : '确认组装'),
          ),
        ],
      ),
    );
  }

  Future<void> _scanServerBarcode() async {
    final barcode = await BarcodeScannerService.scanBarcode();
    if (barcode == null || barcode.isEmpty) return;

    final server = await context.read<InventoryProvider>().getServerBySerialNumber(barcode);
    if (server == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('未找到该服务器')),
        );
      }
      return;
    }

    setState(() {
      selectedServer = server;
      selectedParts.clear();
    });
  }

  Future<void> _scanPartBarcode() async {
    if (selectedServer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先选择服务器')),
      );
      return;
    }

    final barcode = await BarcodeScannerService.scanBarcode();
    if (barcode == null || barcode.isEmpty) return;

    final part = await context.read<InventoryProvider>().getPartBySerialNumber(barcode);
    if (part == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('未找到该配件')),
        );
      }
      return;
    }

    if (isDisassembly) {
      if (!selectedServer!.partSerialNumbers.contains(part.serialNumber)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('该配件不属于选中的服务器')),
          );
        }
        return;
      }
    } else {
      if (part.currentStatus != 'In Stock') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('该配件不在库存中')),
          );
        }
        return;
      }
    }

    setState(() {
      if (!selectedParts.any((p) => p.serialNumber == part.serialNumber)) {
        selectedParts.add(part);
      }
    });
  }

  Future<void> _processAssembly() async {
    if (selectedServer == null || selectedParts.isEmpty) return;

    final provider = context.read<InventoryProvider>();
    
    if (isDisassembly) {
      // 处理拆解
      for (var part in selectedParts) {
        final updatedPart = Part(
          id: part.id,
          serialNumber: part.serialNumber,
          type: part.type,
          model: part.model,
          purchaseCost: part.purchaseCost,
          currentStatus: 'In Stock',
          sourceServerId: selectedServer!.serialNumber,
          currentServerId: null,
          purchaseDate: part.purchaseDate,
          lastModifiedDate: DateTime.now(),
        );
        await provider.updatePart(updatedPart);
      }

      // 更新服务器状态
      final updatedServer = Server(
        id: selectedServer!.id,
        serialNumber: selectedServer!.serialNumber,
        model: selectedServer!.model,
        purchaseCost: selectedServer!.purchaseCost,
        currentStatus: 'Disassembled',
        assemblyDate: selectedServer!.assemblyDate,
        lastModifiedDate: DateTime.now(),
        partSerialNumbers: selectedServer!.partSerialNumbers
            .where((sn) => !selectedParts.any((p) => p.serialNumber == sn))
            .toList(),
      );
      await provider.updateServer(updatedServer);
    } else {
      // 处理组装
      for (var part in selectedParts) {
        final updatedPart = Part(
          id: part.id,
          serialNumber: part.serialNumber,
          type: part.type,
          model: part.model,
          purchaseCost: part.purchaseCost,
          currentStatus: 'Assembled',
          sourceServerId: null,
          currentServerId: selectedServer!.serialNumber,
          purchaseDate: part.purchaseDate,
          lastModifiedDate: DateTime.now(),
        );
        await provider.updatePart(updatedPart);
      }

      // 更新服务器状态
      final updatedServer = Server(
        id: selectedServer!.id,
        serialNumber: selectedServer!.serialNumber,
        model: selectedServer!.model,
        purchaseCost: selectedServer!.purchaseCost,
        currentStatus: 'In Stock',
        assemblyDate: DateTime.now(),
        lastModifiedDate: DateTime.now(),
        partSerialNumbers: [
          ...selectedServer!.partSerialNumbers,
          ...selectedParts.map((p) => p.serialNumber),
        ],
      );
      await provider.updateServer(updatedServer);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isDisassembly ? '拆解完成' : '组装完成'),
        ),
      );
      Navigator.pop(context);
    }
  }
} 