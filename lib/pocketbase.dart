import 'package:flutter_dotenv/flutter_dotenv.dart';
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
      dotenv.env["POCKETBASE_URL"]!,

      authStore: storagemanager(),
    );
  }

  PocketBase get instance => _pocketBase;
}
