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
      print("Storage loaded: token=$_token, model=$_model");
    } catch (e) {
      print("Error loading storage: $e");
    }
  }

  @override
  Future<void> save(String newToken, dynamic newModel) async {
    try {
      _token = newToken;
      _model = newModel;
      await _secureStorage.write(key: 'auth_token', value: newToken);
      await _secureStorage.write(key: 'auth_model', value: json.encode(newModel));
      print("Storage saved: token=$_token, model=$_model");
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
      print("Storage removed");
    } catch (e) {
      print("Error removing storage: $e");
    }
  }

  @override
  String get token => _token;

  @override
  Map<String, dynamic>? get model => _model;
}
