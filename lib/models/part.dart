class Part {
  final int? id;
  final String serialNumber;
  final String type;
  final String model;
  final double purchaseCost;
  final String currentStatus; // 'In Stock', 'Assembled', 'Sold', 'Scrapped'
  final String? sourceServerId;
  final String? currentServerId;
  final DateTime purchaseDate;
  final DateTime lastModifiedDate;

  Part({
    this.id,
    required this.serialNumber,
    required this.type,
    required this.model,
    required this.purchaseCost,
    required this.currentStatus,
    this.sourceServerId,
    this.currentServerId,
    required this.purchaseDate,
    required this.lastModifiedDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serial_number': serialNumber,
      'type': type,
      'model': model,
      'purchase_cost': purchaseCost,
      'current_status': currentStatus,
      'source_server_id': sourceServerId,
      'current_server_id': currentServerId,
      'purchase_date': purchaseDate.toIso8601String(),
      'last_modified_date': lastModifiedDate.toIso8601String(),
    };
  }

  factory Part.fromMap(Map<String, dynamic> map) {
    return Part(
      id: map['id'] as int?,
      serialNumber: map['serial_number'] as String,
      type: map['type'] as String,
      model: map['model'] as String,
      purchaseCost: (map['purchase_cost'] as num).toDouble(),
      currentStatus: map['current_status'] as String,
      sourceServerId: map['source_server_id'] as String?,
      currentServerId: map['current_server_id'] as String?,
      purchaseDate: map['purchase_date'] is DateTime 
          ? map['purchase_date'] as DateTime 
          : DateTime.parse(map['purchase_date'] as String),
      lastModifiedDate: map['last_modified_date'] is DateTime 
          ? map['last_modified_date'] as DateTime 
          : DateTime.parse(map['last_modified_date'] as String),
    );
  }

  Part copyWith({
    int? id,
    String? serialNumber,
    String? type,
    String? model,
    double? purchaseCost,
    String? currentStatus,
    String? sourceServerId,
    String? currentServerId,
    DateTime? purchaseDate,
    DateTime? lastModifiedDate,
  }) {
    return Part(
      id: id ?? this.id,
      serialNumber: serialNumber ?? this.serialNumber,
      type: type ?? this.type,
      model: model ?? this.model,
      purchaseCost: purchaseCost ?? this.purchaseCost,
      currentStatus: currentStatus ?? this.currentStatus,
      sourceServerId: sourceServerId ?? this.sourceServerId,
      currentServerId: currentServerId ?? this.currentServerId,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      lastModifiedDate: lastModifiedDate ?? this.lastModifiedDate,
    );
  }
} 