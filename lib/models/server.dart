class Server {
  final int? id;
  final String serialNumber;
  final String model;
  final double purchaseCost;
  final String currentStatus; // 'In Stock', 'Sold', 'Disassembled'
  final DateTime assemblyDate;
  final DateTime lastModifiedDate;
  final List<String> partSerialNumbers; // 组装在服务器上的配件序列号列表

  Server({
    this.id,
    required this.serialNumber,
    required this.model,
    required this.purchaseCost,
    required this.currentStatus,
    required this.assemblyDate,
    required this.lastModifiedDate,
    required this.partSerialNumbers,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serial_number': serialNumber,
      'model': model,
      'purchase_cost': purchaseCost,
      'current_status': currentStatus,
      'assembly_date': assemblyDate.toIso8601String(),
      'last_modified_date': lastModifiedDate.toIso8601String(),
      'part_serial_numbers': partSerialNumbers.join(','),
    };
  }

  factory Server.fromMap(Map<String, dynamic> map) {
    String partSerialNumbersStr = '';
    if (map['part_serial_numbers'] != null) {
      if (map['part_serial_numbers'] is String) {
        partSerialNumbersStr = map['part_serial_numbers'] as String;
      } else if (map['part_serial_numbers'] is List<int>) {
        // 处理 Blob 类型
        partSerialNumbersStr = String.fromCharCodes(map['part_serial_numbers'] as List<int>);
      }
    }

    return Server(
      id: map['id'] as int?,
      serialNumber: map['serial_number'] as String,
      model: map['model'] as String,
      purchaseCost: (map['purchase_cost'] as num).toDouble(),
      currentStatus: map['current_status'] as String,
      assemblyDate: map['assembly_date'] is DateTime 
          ? map['assembly_date'] as DateTime 
          : DateTime.parse(map['assembly_date'] as String),
      lastModifiedDate: map['last_modified_date'] is DateTime 
          ? map['last_modified_date'] as DateTime 
          : DateTime.parse(map['last_modified_date'] as String),
      partSerialNumbers: partSerialNumbersStr.split(',').where((s) => s.isNotEmpty).toList(),
    );
  }

  Server copyWith({
    int? id,
    String? serialNumber,
    String? model,
    double? purchaseCost,
    String? currentStatus,
    DateTime? assemblyDate,
    DateTime? lastModifiedDate,
    List<String>? partSerialNumbers,
  }) {
    return Server(
      id: id ?? this.id,
      serialNumber: serialNumber ?? this.serialNumber,
      model: model ?? this.model,
      purchaseCost: purchaseCost ?? this.purchaseCost,
      currentStatus: currentStatus ?? this.currentStatus,
      assemblyDate: assemblyDate ?? this.assemblyDate,
      lastModifiedDate: lastModifiedDate ?? this.lastModifiedDate,
      partSerialNumbers: partSerialNumbers ?? this.partSerialNumbers,
    );
  }
} 