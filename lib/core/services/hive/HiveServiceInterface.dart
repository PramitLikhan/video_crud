import 'package:hive_flutter/hive_flutter.dart';

abstract class HiveServiceInterface {
  init() {}

  createBox(String boxName) {}

  bool hasData(String boxName);

  add({required dynamic data, required String boxName});

  readAll(String boxName);

  update(int id, dynamic newItem, String boxName);

  delete(int index, String boxName);

  deleteAll(String boxName);

  get(int index, String boxName);

  addWithKey(dynamic key, dynamic value, String boxName);

  dynamic getByKey(dynamic key, String boxName);

  deleteByKey(dynamic key, String boxName);

  clear(String boxName);

  searchByName(String name, String boxName);

  dynamic searchById(dynamic id, String boxName);

  close();
}
