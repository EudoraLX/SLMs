class Part {
  final int? id;
  final String serialNumber;
  final int typeId;
  final String typeName;
  final String model;
  final int manufacturerId;
  final String manufacturerName;
  final String specifications;
  final double purchaseCost;
  final double sellingPrice;
  final int quantity;
  final int locationId;
  final String locationName;
  final int supplierId;
  final String supplierName;
  final int warrantyId;
  final String warrantyName;
  final int statusId;
  final String statusName;
  final int? sourceServerId;
  final int? currentServerId;
  final DateTime purchaseDate;
  final DateTime lastModifiedDate;

  Part({
    this.id,
    required this.serialNumber,
    required this.typeId,
    this.typeName = '',
    required this.model,
    required this.manufacturerId,
    this.manufacturerName = '',
    required this.specifications,
    required this.purchaseCost,
    required this.sellingPrice,
    required this.quantity,
    required this.locationId,
    this.locationName = '',
    required this.supplierId,
    this.supplierName = '',
    required this.warrantyId,
    this.warrantyName = '',
    required this.statusId,
    this.statusName = '',
    this.sourceServerId,
    this.currentServerId,
    required this.purchaseDate,
    required this.lastModifiedDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serial_number': serialNumber,
      'type_id': typeId,
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
      'source_server_id': sourceServerId,
      'current_server_id': currentServerId,
      'purchase_date': purchaseDate.toIso8601String(),
      'last_modified_date': lastModifiedDate.toIso8601String(),
    };
  }

  factory Part.fromMap(Map<String, dynamic> map) {
    String _toStr(dynamic v) {
      if (v == null) return '';
      if (v is String) return v;
      if (v is List<int>) return String.fromCharCodes(v);
      return v.toString();
    }
    return Part(
      id: map['id'],
      serialNumber: _toStr(map['serial_number']),
      typeId: map['type_id'] is int ? map['type_id'] : int.tryParse(map['type_id'].toString()) ?? 0,
      typeName: _toStr(map['type_name']),
      model: _toStr(map['model']),
      manufacturerId: map['manufacturer_id'] is int ? map['manufacturer_id'] : int.tryParse(map['manufacturer_id'].toString()) ?? 0,
      manufacturerName: _toStr(map['manufacturer_name']),
      specifications: _toStr(map['specifications']),
      purchaseCost: map['purchase_cost'] is num ? (map['purchase_cost'] as num).toDouble() : double.tryParse(map['purchase_cost'].toString()) ?? 0.0,
      sellingPrice: map['selling_price'] is num ? (map['selling_price'] as num).toDouble() : double.tryParse(map['selling_price'].toString()) ?? 0.0,
      quantity: map['quantity'] is int ? map['quantity'] : int.tryParse(map['quantity'].toString()) ?? 0,
      locationId: map['location_id'] is int ? map['location_id'] : int.tryParse(map['location_id'].toString()) ?? 0,
      locationName: _toStr(map['location_name']),
      supplierId: map['supplier_id'] is int ? map['supplier_id'] : int.tryParse(map['supplier_id'].toString()) ?? 0,
      supplierName: _toStr(map['supplier_name']),
      warrantyId: map['warranty_id'] is int ? map['warranty_id'] : int.tryParse(map['warranty_id'].toString()) ?? 0,
      warrantyName: _toStr(map['warranty_name']),
      statusId: map['status_id'] is int ? map['status_id'] : int.tryParse(map['status_id'].toString()) ?? 0,
      statusName: _toStr(map['status_name']),
      sourceServerId: map['source_server_id'] is int ? map['source_server_id'] : int.tryParse(map['source_server_id']?.toString() ?? ''),
      currentServerId: map['current_server_id'] is int ? map['current_server_id'] : int.tryParse(map['current_server_id']?.toString() ?? ''),
      purchaseDate: map['purchase_date'] is DateTime ? map['purchase_date'] : DateTime.tryParse(map['purchase_date'].toString()) ?? DateTime.now(),
      lastModifiedDate: map['last_modified_date'] is DateTime ? map['last_modified_date'] : DateTime.tryParse(map['last_modified_date'].toString()) ?? DateTime.now(),
    );
  }

  Part copyWith({
    int? id,
    String? serialNumber,
    int? typeId,
    String? typeName,
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
    int? sourceServerId,
    int? currentServerId,
    DateTime? purchaseDate,
    DateTime? lastModifiedDate,
  }) {
    return Part(
      id: id ?? this.id,
      serialNumber: serialNumber ?? this.serialNumber,
      typeId: typeId ?? this.typeId,
      typeName: typeName ?? this.typeName,
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
      sourceServerId: sourceServerId ?? this.sourceServerId,
      currentServerId: currentServerId ?? this.currentServerId,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      lastModifiedDate: lastModifiedDate ?? this.lastModifiedDate,
    );
  }
} 