import '../config/database_config.dart';

class Sale {
  final int? id;
  final String itemType;
  final String serialNumber;
  final String customer;
  final int quantity;
  final double unitPrice;
  final double totalAmount;
  final DateTime saleDate;
  final String paymentMethod;
  final String notes;

  Sale({
    this.id,
    required this.itemType,
    required this.serialNumber,
    required this.customer,
    required this.quantity,
    required this.unitPrice,
    required this.totalAmount,
    required this.saleDate,
    required this.paymentMethod,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'item_type': itemType,
      'serial_number': serialNumber,
      'customer': customer,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_amount': totalAmount,
      'sale_date': saleDate.toIso8601String(),
      'payment_method': paymentMethod,
      'notes': notes,
    };
  }

  factory Sale.fromMap(Map<String, dynamic> map) {
    String _toStr(dynamic v) {
      if (v == null) return '';
      if (v is String) return v;
      if (v is List<int>) return String.fromCharCodes(v);
      return v.toString();
    }
    DateTime _toDate(dynamic v) {
      if (v == null) return DateTime.now();
      if (v is DateTime) return v;
      if (v is String) return DateTime.tryParse(v) ?? DateTime.now();
      return DateTime.now();
    }
    return Sale(
      id: map['id'],
      itemType: _toStr(map['item_type']),
      serialNumber: _toStr(map['serial_number']),
      customer: _toStr(map['customer']),
      quantity: map['quantity'] is int ? map['quantity'] : int.tryParse(map['quantity'].toString()) ?? 0,
      unitPrice: map['unit_price'] is num ? (map['unit_price'] as num).toDouble() : double.tryParse(map['unit_price'].toString()) ?? 0.0,
      totalAmount: map['total_amount'] is num ? (map['total_amount'] as num).toDouble() : double.tryParse(map['total_amount'].toString()) ?? 0.0,
      saleDate: _toDate(map['sale_date']),
      paymentMethod: _toStr(map['payment_method']),
      notes: _toStr(map['notes']),
    );
  }

  Sale copyWith({
    int? id,
    String? itemType,
    String? serialNumber,
    String? customer,
    int? quantity,
    double? unitPrice,
    double? totalAmount,
    DateTime? saleDate,
    String? paymentMethod,
    String? notes,
  }) {
    return Sale(
      id: id ?? this.id,
      itemType: itemType ?? this.itemType,
      serialNumber: serialNumber ?? this.serialNumber,
      customer: customer ?? this.customer,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalAmount: totalAmount ?? this.totalAmount,
      saleDate: saleDate ?? this.saleDate,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      notes: notes ?? this.notes,
    );
  }
} 