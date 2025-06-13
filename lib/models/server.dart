class Server {
  final int? id;
  final String serialNumber;
  final String model;
  final int manufacturerId;
  final String? manufacturerName;
  final String specifications;
  final double purchaseCost;
  final double sellingPrice;
  final int quantity;
  final int locationId;
  final String? locationName;
  final int supplierId;
  final String? supplierName;
  final int warrantyId;
  final String? warrantyName;
  final int statusId;
  final String? statusName;
  final DateTime assemblyDate;
  final String partSerialNumbers;
  final DateTime lastModifiedDate;

  Server({
    this.id,
    required this.serialNumber,
    required this.model,
    required this.manufacturerId,
    this.manufacturerName,
    required this.specifications,
    required this.purchaseCost,
    required this.sellingPrice,
    required this.quantity,
    required this.locationId,
    this.locationName,
    required this.supplierId,
    this.supplierName,
    required this.warrantyId,
    this.warrantyName,
    required this.statusId,
    this.statusName,
    required this.assemblyDate,
    required this.partSerialNumbers,
    required this.lastModifiedDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serial_number': serialNumber,
      'model': model,
      'manufacturer_id': manufacturerId,
      'specifications': specifications,
      'purchase_cost': purchaseCost,
      'selling_price': sellingPrice,
      'quantity': quantity,
      'location_id': locationId,
      'supplier_id': supplierId,
      'warranty_id': warrantyId,
      'status_id': statusId,
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
      manufacturerId: map['manufacturer_id'] is int ? map['manufacturer_id'] : int.tryParse(map['manufacturer_id'].toString()) ?? 0,
      manufacturerName: map['manufacturer_name'] != null ? _toStr(map['manufacturer_name']) : null,
      specifications: _toStr(map['specifications']),
      purchaseCost: map['purchase_cost'] is num ? (map['purchase_cost'] as num).toDouble() : double.tryParse(map['purchase_cost'].toString()) ?? 0.0,
      sellingPrice: map['selling_price'] is num ? (map['selling_price'] as num).toDouble() : double.tryParse(map['selling_price'].toString()) ?? 0.0,
      quantity: map['quantity'] is int ? map['quantity'] : int.tryParse(map['quantity'].toString()) ?? 0,
      locationId: map['location_id'] is int ? map['location_id'] : int.tryParse(map['location_id'].toString()) ?? 0,
      locationName: map['location_name'] != null ? _toStr(map['location_name']) : null,
      supplierId: map['supplier_id'] is int ? map['supplier_id'] : int.tryParse(map['supplier_id'].toString()) ?? 0,
      supplierName: map['supplier_name'] != null ? _toStr(map['supplier_name']) : null,
      warrantyId: map['warranty_id'] is int ? map['warranty_id'] : int.tryParse(map['warranty_id'].toString()) ?? 0,
      warrantyName: map['warranty_name'] != null ? _toStr(map['warranty_name']) : null,
      statusId: map['status_id'] is int ? map['status_id'] : int.tryParse(map['status_id'].toString()) ?? 0,
      statusName: map['status_name'] != null ? _toStr(map['status_name']) : null,
      assemblyDate: map['assembly_date'] is DateTime ? map['assembly_date'] : DateTime.tryParse(map['assembly_date'].toString()) ?? DateTime.now(),
      partSerialNumbers: _toStr(map['part_serial_numbers']),
      lastModifiedDate: map['last_modified_date'] is DateTime ? map['last_modified_date'] : DateTime.tryParse(map['last_modified_date'].toString()) ?? DateTime.now(),
    );
  }

  Server copyWith({
    int? id,
    String? serialNumber,
    String? model,
    int? manufacturerId,
    String? manufacturerName,
    String? specifications,
    double? purchaseCost,
    double? sellingPrice,
    int? quantity,
    int? locationId,
    String? locationName,
    int? supplierId,
    String? supplierName,
    int? warrantyId,
    String? warrantyName,
    int? statusId,
    String? statusName,
    DateTime? assemblyDate,
    String? partSerialNumbers,
    DateTime? lastModifiedDate,
  }) {
    return Server(
      id: id ?? this.id,
      serialNumber: serialNumber ?? this.serialNumber,
      model: model ?? this.model,
      manufacturerId: manufacturerId ?? this.manufacturerId,
      manufacturerName: manufacturerName ?? this.manufacturerName,
      specifications: specifications ?? this.specifications,
      purchaseCost: purchaseCost ?? this.purchaseCost,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      quantity: quantity ?? this.quantity,
      locationId: locationId ?? this.locationId,
      locationName: locationName ?? this.locationName,
      supplierId: supplierId ?? this.supplierId,
      supplierName: supplierName ?? this.supplierName,
      warrantyId: warrantyId ?? this.warrantyId,
      warrantyName: warrantyName ?? this.warrantyName,
      statusId: statusId ?? this.statusId,
      statusName: statusName ?? this.statusName,
      assemblyDate: assemblyDate ?? this.assemblyDate,
      partSerialNumbers: partSerialNumbers ?? this.partSerialNumbers,
      lastModifiedDate: lastModifiedDate ?? this.lastModifiedDate,
    );
  }
} 