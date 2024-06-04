import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pocketbase/pocketbase.dart';

class storagemanager extends AuthStore {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  String _token = "";
  Map<String, dynamic>? _model;

  storagemanager() {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    try {
      _token = (await _secureStorage.read(key: 'auth_token')) ?? "";
      final modelString = await _secureStorage.read(key: 'auth_model');
      if (modelString != null) {
        _model = json.decode(modelString);
      }
    } catch (e) {
      print("Error loading storage: $e");
    }
  }

  @override
  Future<void> save(String newToken, dynamic newModel) async {
    try {
        if (newModel is RecordModel) {
          Map<String, dynamic> dataMap = newModel.toJson();
          _model = dataMap;
          await _secureStorage.write(key: 'auth_model', value: json.encode(dataMap));
        } else {
          throw Exception('Invalid data type');
        }

      _token = newToken;
      await _secureStorage.write(key: 'auth_token', value: newToken);
    } catch (e) {
      print("Error saving storage: $e");
    }
  }

  Future<void> remove() async {
    try {
      _token = "";
      _model = null;
      await _secureStorage.delete(key: 'auth_token');
      await _secureStorage.delete(key: 'auth_model');
    } catch (e) {
      print("Error removing storage: $e");
    }
  }

  @override
  String get token => _token;

  @override
  dynamic get model => _model;
}
