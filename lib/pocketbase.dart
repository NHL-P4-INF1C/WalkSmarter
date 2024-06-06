import 'package:pocketbase/pocketbase.dart';
import 'storagemanager.dart';

class PocketBaseSingleton {
  static final PocketBaseSingleton _instance = PocketBaseSingleton._internal();
  late PocketBase _pocketBase;

  factory PocketBaseSingleton() {
    return _instance;
  }

  PocketBaseSingleton._internal() {
    _pocketBase = PocketBase(
      'https://inf1c-p4-pocketbase-backup.bramsuurd.nl',  // Replace with your PocketBase URL
      authStore: storagemanager(),
    );
  }

  PocketBase get instance => _pocketBase;
}