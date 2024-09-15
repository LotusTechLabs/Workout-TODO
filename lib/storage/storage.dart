import 'package:get_storage/get_storage.dart';

class Storage {
  static final Storage _singleton = Storage._internal();

  static Storage get instance => _singleton;

  Storage._internal();

  static Storage getInstance() {
    return _singleton;
  }

  final GetStorage _storageBox = GetStorage("work_out");

  dynamic read(String key) {
    return _storageBox.read(key);
  }

  Future<dynamic> write(String key, dynamic data) async {
    return _storageBox.write(key, data);
  }

  Future<void> cleanData() async {
    return _storageBox.erase();
  }
}

class StorageKey {
  static const String workouts = "Workouts";
}
