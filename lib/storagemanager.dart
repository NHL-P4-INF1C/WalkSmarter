import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageManager
{
  static final StorageManager _instance = StorageManager._internal();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  factory StorageManager()
  {
    return _instance;
  }

  StorageManager._internal();

  Future<String?> getData(String key) async
  {
    return await _storage.read(key: key);
  }

  Future<void> setData(String key, String value) async
  {
    await _storage.write(key: key, value: value);
  }
}