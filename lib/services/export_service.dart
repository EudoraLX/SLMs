import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/part.dart';
import '../models/server.dart';

class ExportService {
  static Future<String> exportToCsv({
    required List<Part> parts,
    required List<Server> servers,
  }) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/inventory_export_${DateTime.now().millisecondsSinceEpoch}.csv');
    final sink = file.openWrite();

    // 导出配件数据
    sink.writeln('配件数据');
    sink.writeln('序列号,类型,型号,采购成本,状态,来源服务器,当前服务器,采购日期,最后修改日期');
    for (var part in parts) {
      sink.writeln([
        part.serialNumber,
        part.type,
        part.model,
        part.purchaseCost,
        part.currentStatus,
        part.sourceServerId ?? '',
        part.currentServerId ?? '',
        part.purchaseDate.toIso8601String(),
        part.lastModifiedDate?.toIso8601String() ?? '',
      ].join(','));
    }

    // 导出服务器数据
    sink.writeln('\n服务器数据');
    sink.writeln('序列号,型号,采购成本,状态,组装日期,最后修改日期,配件数量');
    for (var server in servers) {
      sink.writeln([
        server.serialNumber,
        server.model,
        server.purchaseCost,
        server.currentStatus,
        server.assemblyDate.toIso8601String(),
        server.lastModifiedDate?.toIso8601String() ?? '',
        server.partSerialNumbers.length,
      ].join(','));
    }

    await sink.close();
    return file.path;
  }
} 