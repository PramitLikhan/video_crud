import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:uuid/uuid.dart';

import 'HiveServiceInterface.dart';

class HiveService implements HiveServiceInterface {
  static HiveService? _hiveDbService;

  // HiveService();

  static HiveService get hiveDbService => _hiveDbService ??= HiveService();

  late Box _box;
  var uuid = const Uuid();
  @override
  init() async {
    var dir = await path.getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    await Hive.initFlutter();
  }

  @override
  createBox(String boxName) async {
    await Hive.openBox(boxName);
  }

  @override
  bool hasData(String boxName) {
    if (readAll(boxName) != []) {
      return true;
    } else {
      return false;
    }
  }

  @override
  add({required dynamic data, required String boxName}) {
    // String id = uuid.v4();
    // data['id'] = id;
    _box = Hive.box(boxName);
    print('HiveService.add ${_box.length}');
    _box.add(data);
  }

  @override
  List<dynamic> readAll(String boxName) {
    _box = Hive.box(boxName);
    return _box.values.toList();
  }

  @override
  update(int id, dynamic newItem, String boxName) {
    _box = Hive.box(boxName);
    final item = _box.get(id);
    if (item != null) {
      item.delete();
      _box.add(newItem);
    }
  }

  updateByKey(key, dynamic newItem, String boxName) {
    _box = Hive.box(boxName);
    log('HiveService.updateAt ${_box.length} index $key==================================================');

    _box.put(key, newItem);
    // _box.deleteAt(index + 1);
  }

  @override
  delete(int index, String boxName) {
    _box = Hive.box(boxName);
    _box.deleteAt(index);
  }

  @override
  deleteAll(String boxName) {
    _box = Hive.box(boxName);
    _box.clear();
  }

  @override
  get(int index, String boxName) {
    _box = Hive.box(boxName);
    return _box.getAt(index)!;
  }

  getAll(String boxName) {
    return Hive.box(boxName);
  }

  getBox(String boxName) => Hive.box(boxName);

  @override
  addWithKey(dynamic key, dynamic value, String boxName) {
    _box = Hive.box(boxName);
    _box.put(key, value);
  }

  @override
  dynamic getByKey(dynamic key, String boxName) {
    _box = Hive.box(boxName);
    return _box.get(key);
  }

  @override
  deleteByKey(dynamic key, String boxName) async {
    _box = Hive.box(boxName);
    await _box.delete(key);
  }

  deleteAt(int index, String boxName) {
    _box = Hive.box(boxName);
    _box.deleteAt(index);
  }

  @override
  clear(String boxName) {
    _box = Hive.box(boxName);
    _box.clear();
  }

  @override
  List<dynamic> searchByName(String name, String boxName) {
    _box = Hive.box(boxName);
    return _box.values.where((item) => item['name'].toString().toLowerCase().contains(name.toLowerCase())).toList();
  }

  @override
  dynamic searchById(dynamic id, String boxName) {
    _box = Hive.box(boxName);
    return _box.values.firstWhere((item) => item['id'] == id, orElse: () => null);
  }

  @override
  close() {
    Hive.close();
  }
}
