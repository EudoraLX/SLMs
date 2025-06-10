import '../config/database_config.dart';

class Sale {
  final int? id;
  final String itemType; // 'part' 或 'server'
  final String serialNumber;
  final double salePrice;
  final DateTime saleDate;
  final String? customer;
  final String? notes;

  Sale({
    this.id,
    required this.itemType,
    required this.serialNumber,
    required this.salePrice,
    required this.saleDate,
    this.customer,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      DatabaseConfig.columnSaleId: id,
      DatabaseConfig.columnSaleItemType: itemType,
      DatabaseConfig.columnSaleSerialNumber: serialNumber,
      DatabaseConfig.columnSalePrice: salePrice,
      DatabaseConfig.columnSaleDate: saleDate.toIso8601String(),
      DatabaseConfig.columnSaleCustomer: customer,
      DatabaseConfig.columnSaleNotes: notes,
    };
  }

  factory Sale.fromMap(Map<String, dynamic> map) {
    return Sale(
      id: map[DatabaseConfig.columnSaleId],
      itemType: map[DatabaseConfig.columnSaleItemType],
      serialNumber: map[DatabaseConfig.columnSaleSerialNumber],
      salePrice: map[DatabaseConfig.columnSalePrice],
      saleDate: DateTime.parse(map[DatabaseConfig.columnSaleDate]),
      customer: map[DatabaseConfig.columnSaleCustomer],
      notes: map[DatabaseConfig.columnSaleNotes],
    );
  }

  Sale copyWith({
    int? id,
    String? itemType,
    String? serialNumber,
    double? salePrice,
    DateTime? saleDate,
    String? customer,
    String? notes,
  }) {
    return Sale(
      id: id ?? this.id,
      itemType: itemType ?? this.itemType,
      serialNumber: serialNumber ?? this.serialNumber,
      salePrice: salePrice ?? this.salePrice,
      saleDate: saleDate ?? this.saleDate,
      customer: customer ?? this.customer,
      notes: notes ?? this.notes,
    );
  }
} 