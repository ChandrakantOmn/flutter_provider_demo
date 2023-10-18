import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageProvider with ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  List<SecItem> items = [];
  String? accountName;

  String? _getAccountName() => accountName;

  Future<void> deleteAll() async {
    await _storage.deleteAll(
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
    readAll();
  }

  Future<void> addNewItem() async {
    final String key = _randomValue();
    final String value = _randomValue();
    await _storage.write(
      key: key,
      value: value,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
    readAll();
  }

  Future<void> readAll() async {
    final all = await _storage.readAll(
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );

    items = all.entries
        .map((entry) => SecItem(entry.key, entry.value))
        .toList(growable: false);
    notifyListeners();
  }

  IOSOptions _getIOSOptions() => IOSOptions(accountName: _getAccountName());

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
        // sharedPreferencesName: 'Test2',
        // preferencesKeyPrefix: 'Test'
      );

  String _randomValue() {
    final rand = Random();
    final codeUnits = List.generate(20, (index) {
      return rand.nextInt(26) + 65;
    });

    return String.fromCharCodes(codeUnits);
  }

  getItem(String key) async {
    return _storage.read(key: key, aOptions: _getAndroidOptions());
  }

  Future<bool> isItemPresent(String key) async {
    return await _storage.containsKey(key: key);
  }

  Future<void> deleteItem(String key) async {
    await _storage.delete(
      key: key,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
  }

  Future<void> updateItem(String key, String value) async {
    await _storage.write(
      key: key,
      value: value,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
  }
}

class SecItem {
  SecItem(this.key, this.value);

  final String key;
  final String value;
}

enum UserActions { deleteAll }

enum ItemActions { delete, edit, containsKey, read }
