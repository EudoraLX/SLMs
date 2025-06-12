class Server {
  final int? id;
  final String serialNumber;
  final String model;
  final String manufacturer;
  final String specifications;
  final double purchaseCost;
  final double sellingPrice;
  final int quantity;
  final String location;
  final String supplier;
  final String warranty;
  final String currentStatus;
  final DateTime assemblyDate;
  final String partSerialNumbers;
  final DateTime lastModifiedDate;

  Server({
    this.id,
    required this.serialNumber,
    required this.model,
    required this.manufacturer,
    required this.specifications,
    required this.purchaseCost,
    required this.sellingPrice,
    required this.quantity,
    required this.location,
    required this.supplier,
    required this.warranty,
    required this.currentStatus,
    required this.assemblyDate,
    required this.partSerialNumbers,
    required this.lastModifiedDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serial_number': serialNumber,
      'model': model,
      'manufacturer': manufacturer,
      'specifications': specifications,
      'purchase_cost': purchaseCost,
      'selling_price': sellingPrice,
      'quantity': quantity,
      'location': location,
      'supplier': supplier,
      'warranty': warranty,
      'current_status': currentStatus,
      'assembly_date': assemblyDate.toIso8601String(),
      'part_serial_numbers': partSerialNumbers,
      'last_modified_date': lastModifiedDate.toIso8601String(),
    };
  }

  factory Server.fromMap(Map<String, dynamic> map) {
    String _toStr(dynamic v) {
      if (v == null) return '';
      if (v is String) return v;
      if (v is List<int>) return String.fromCharCodes(v);
      return v.toString();
    }
    return Server(
      id: map['id'],
      serialNumber: _toStr(map['serial_number']),
      model: _toStr(map['model']),
      manufacturer: _toStr(map['manufacturer']),
      specifications: _toStr(map['specifications']),
      purchaseCost: map['purchase_cost'] is num ? (map['purchase_cost'] as num).toDouble() : double.tryParse(map['purchase_cost'].toString()) ?? 0.0,
      sellingPrice: map['selling_price'] is num ? (map['selling_price'] as num).toDouble() : double.tryParse(map['selling_price'].toString()) ?? 0.0,
      quantity: map['quantity'] is int ? map['quantity'] : int.tryParse(map['quantity'].toString()) ?? 0,
      location: _toStr(map['location']),
      supplier: _toStr(map['supplier']),
      warranty: _toStr(map['warranty']),
      currentStatus: _toStr(map['current_status']),
      assemblyDate: map['assembly_date'] is DateTime ? map['assembly_date'] : DateTime.tryParse(map['assembly_date'].toString()) ?? DateTime.now(),
      partSerialNumbers: _toStr(map['part_serial_numbers']),
      lastModifiedDate: map['last_modified_date'] is DateTime ? map['last_modified_date'] : DateTime.tryParse(map['last_modified_date'].toString()) ?? DateTime.now(),
    );
  }

  Server copyWith({
    int? id,
    String? serialNumber,
    String? model,
    String? manufacturer,
    String? specifications,
    double? purchaseCost,
    double? sellingPrice,
    int? quantity,
    String? location,
    String? supplier,
    String? warranty,
    String? currentStatus,
    DateTime? assemblyDate,
    String? partSerialNumbers,
    DateTime? lastModifiedDate,
  }) {
    return Server(
      id: id ?? this.id,
      serialNumber: serialNumber ?? this.serialNumber,
      model: model ?? this.model,
      manufacturer: manufacturer ?? this.manufacturer,
      specifications: specifications ?? this.specifications,
      purchaseCost: purchaseCost ?? this.purchaseCost,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      quantity: quantity ?? this.quantity,
      location: location ?? this.location,
      supplier: supplier ?? this.supplier,
      warranty: warranty ?? this.warranty,
      currentStatus: currentStatus ?? this.currentStatus,
      assemblyDate: assemblyDate ?? this.assemblyDate,
      partSerialNumbers: partSerialNumbers ?? this.partSerialNumbers,
      lastModifiedDate: lastModifiedDate ?? this.lastModifiedDate,
    );
  }
} 