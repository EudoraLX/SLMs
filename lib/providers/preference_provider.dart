import 'package:flutter/foundation.dart';
import '../database/database_helper.dart';

class PreferenceProvider with ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;
  List<Map<String, dynamic>> _partTypes = [];
  List<Map<String, dynamic>> _manufacturers = [];
  List<Map<String, dynamic>> _locations = [];
  List<Map<String, dynamic>> _suppliers = [];
  List<Map<String, dynamic>> _warrantyPeriods = [];
  List<Map<String, dynamic>> _statusTypes = [];
  List<Map<String, dynamic>> _paymentMethods = [];
  List<Map<String, dynamic>> _operationTypes = [];

  List<Map<String, dynamic>> get partTypes => _partTypes;
  List<Map<String, dynamic>> get manufacturers => _manufacturers;
  List<Map<String, dynamic>> get locations => _locations;
  List<Map<String, dynamic>> get suppliers => _suppliers;
  List<Map<String, dynamic>> get warrantyPeriods => _warrantyPeriods;
  List<Map<String, dynamic>> get statusTypes => _statusTypes;
  List<Map<String, dynamic>> get paymentMethods => _paymentMethods;
  List<Map<String, dynamic>> get operationTypes => _operationTypes;

  Future<void> loadAllPreferences() async {
    await Future.wait([
      loadPartTypes(),
      loadManufacturers(),
      loadLocations(),
      loadSuppliers(),
      loadWarrantyPeriods(),
      loadStatusTypes(),
      loadPaymentMethods(),
      loadOperationTypes(),
    ]);
    print('Loaded all preferences: partTypes=${_partTypes.length}, manufacturers=${_manufacturers.length}, locations=${_locations.length}, suppliers=${_suppliers.length}, warrantyPeriods=${_warrantyPeriods.length}, statusTypes=${_statusTypes.length}, paymentMethods=${_paymentMethods.length}, operationTypes=${_operationTypes.length}');
  }

  Future<void> loadPartTypes() async {
    _partTypes = await _db.getAllPartTypes();
    notifyListeners();
  }

  Future<void> loadManufacturers() async {
    _manufacturers = await _db.getAllManufacturers();
    notifyListeners();
  }

  Future<void> loadLocations() async {
    _locations = await _db.getAllLocations();
    notifyListeners();
  }

  Future<void> loadSuppliers() async {
    _suppliers = await _db.getAllSuppliers();
    notifyListeners();
  }

  Future<void> loadWarrantyPeriods() async {
    _warrantyPeriods = await _db.getAllWarrantyPeriods();
    notifyListeners();
  }

  Future<void> loadStatusTypes() async {
    _statusTypes = await _db.getAllStatusTypes();
    notifyListeners();
  }

  Future<void> loadPaymentMethods() async {
    _paymentMethods = await _db.getAllPaymentMethods();
    notifyListeners();
  }

  Future<void> loadOperationTypes() async {
    _operationTypes = await _db.getAllOperationTypes();
    notifyListeners();
  }

  // 添加预选项
  Future<void> addPartType(String name, String description) async {
    print('addPartType: $name, $description');
    await _db.addPartType(name, description);
    await loadPartTypes();
    print('partTypes after add: ${_partTypes.length}');
  }

  Future<void> addManufacturer(String name, String website, String contactInfo) async {
    await _db.addManufacturer(name, website, contactInfo);
    await loadManufacturers();
  }

  Future<void> addLocation(String name, String address, int capacity) async {
    await _db.addLocation(name, address, capacity);
    await loadLocations();
  }

  Future<void> addSupplier(String name, String contactPerson, String phone, String email, String address) async {
    await _db.addSupplier(name, contactPerson, phone, email, address);
    await loadSuppliers();
  }

  Future<void> addWarrantyPeriod(String name, int months, String description) async {
    await _db.addWarrantyPeriod(name, months, description);
    await loadWarrantyPeriods();
  }

  Future<void> addStatusType(String name, String description) async {
    await _db.addStatusType(name, description);
    await loadStatusTypes();
  }

  Future<void> addPaymentMethod(String name, String description) async {
    await _db.addPaymentMethod(name, description);
    await loadPaymentMethods();
  }

  Future<void> addOperationType(String name, String description) async {
    await _db.addOperationType(name, description);
    await loadOperationTypes();
  }

  // 更新预选项
  Future<void> updatePartType(int id, String name, String description) async {
    await _db.updatePartType(id, name, description);
    await loadPartTypes();
  }

  Future<void> updateManufacturer(int id, String name, String website, String contactInfo) async {
    await _db.updateManufacturer(id, name, website, contactInfo);
    await loadManufacturers();
  }

  Future<void> updateLocation(int id, String name, String address, int capacity) async {
    await _db.updateLocation(id, name, address, capacity);
    await loadLocations();
  }

  Future<void> updateSupplier(int id, String name, String contactPerson, String phone, String email, String address) async {
    await _db.updateSupplier(id, name, contactPerson, phone, email, address);
    await loadSuppliers();
  }

  Future<void> updateWarrantyPeriod(int id, String name, int months, String description) async {
    await _db.updateWarrantyPeriod(id, name, months, description);
    await loadWarrantyPeriods();
  }

  Future<void> updateStatusType(int id, String name, String description) async {
    await _db.updateStatusType(id, name, description);
    await loadStatusTypes();
  }

  Future<void> updatePaymentMethod(int id, String name, String description) async {
    await _db.updatePaymentMethod(id, name, description);
    await loadPaymentMethods();
  }

  Future<void> updateOperationType(int id, String name, String description) async {
    await _db.updateOperationType(id, name, description);
    await loadOperationTypes();
  }

  // 删除预选项
  Future<void> deletePartType(int id) async {
    await _db.deletePartType(id);
    await loadPartTypes();
  }

  Future<void> deleteManufacturer(int id) async {
    await _db.deleteManufacturer(id);
    await loadManufacturers();
  }

  Future<void> deleteLocation(int id) async {
    await _db.deleteLocation(id);
    await loadLocations();
  }

  Future<void> deleteSupplier(int id) async {
    await _db.deleteSupplier(id);
    await loadSuppliers();
  }

  Future<void> deleteWarrantyPeriod(int id) async {
    await _db.deleteWarrantyPeriod(id);
    await loadWarrantyPeriods();
  }

  Future<void> deleteStatusType(int id) async {
    await _db.deleteStatusType(id);
    await loadStatusTypes();
  }

  Future<void> deletePaymentMethod(int id) async {
    await _db.deletePaymentMethod(id);
    await loadPaymentMethods();
  }

  Future<void> deleteOperationType(int id) async {
    await _db.deleteOperationType(id);
    await loadOperationTypes();
  }
} 