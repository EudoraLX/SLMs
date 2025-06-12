class OperationLog {
  final int? id;
  final String operationType;
  final String itemType;
  final String serialNumber;
  final DateTime operationDate;
  final String operator;
  final String details;

  OperationLog({
    this.id,
    required this.operationType,
    required this.itemType,
    required this.serialNumber,
    required this.operationDate,
    required this.operator,
    required this.details,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'operation_type': operationType,
      'item_type': itemType,
      'serial_number': serialNumber,
      'operation_date': operationDate.toIso8601String(),
      'operator': operator,
      'details': details,
    };
  }

  factory OperationLog.fromMap(Map<String, dynamic> map) {
    String _toStr(dynamic v) {
      if (v == null) return '';
      if (v is String) return v;
      if (v is List<int>) return String.fromCharCodes(v);
      return v.toString();
    }
    return OperationLog(
      id: map['id'],
      operationType: _toStr(map['operation_type']),
      itemType: _toStr(map['item_type']),
      serialNumber: _toStr(map['serial_number']),
      operationDate: map['operation_date'] is DateTime ? map['operation_date'] : DateTime.tryParse(map['operation_date'].toString()) ?? DateTime.now(),
      operator: _toStr(map['operator']),
      details: _toStr(map['details']),
    );
  }
} 