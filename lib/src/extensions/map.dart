part of luoyi_dart_base;

extension DartMapExtension<K, V> on Map<K, V> {
  /// 根据条件返回一个新的Map
  Map<K, V> filter(bool Function(K key, V value) test) {
    Map map = Map.from(this);
    Map<K, V> newMap = {};
    for (K k in keys) {
      if (test(k, map[k])) {
        newMap[k] = map[k];
      }
    }
    return newMap;
  }

  /// 根据keys集合，返回一个新的Map
  Map<K, V> filterFromKeys(List<K> keys) {
    Map<K, V> newMap = {};
    for (K key in keys) {
      newMap[key] = this[key] as V;
    }
    return newMap;
  }

  /// 将当前Map声明的属性转换成实际类型，例如：
  /// ```dart
  /// Map<dynamic, dynamic> map = {'name': 'hihi', 'age': 20};
  /// Map<String, dynamic> map2 = map.toPractical();
  /// ```
  ///
  /// 吐槽：dart的类型系统感觉十分愚蠢，而且很死板，在开发过程中你会遇到各种各样的类型转换错误
  Map toPractical() {
    Map<String, bool> keyTypeMap = {
      'dynamic': false,
      'string': false,
      'int': false,
      'double': false,
      'num': false,
      'bool': false,
    };

    Map<String, bool> valueTypeMap = {
      'dynamic': false,
      'string': false,
      'int': false,
      'double': false,
      'num': false,
      'bool': false,
      'null': false,
      'object': false,
    };

    forEach((k, v) {
      dynamic key = DartUtil.dynamicToBaseType(k, true);
      assert(key != null, 'Map key不是基础数据类型，autoCast失败');
      if (key is int) {
        keyTypeMap['int'] = true;
      } else if (key is double) {
        keyTypeMap['double'] = true;
      } else if (key is bool) {
        keyTypeMap['bool'] = true;
      } else {
        keyTypeMap['string'] = true;
      }

      dynamic value = DartUtil.dynamicToBaseType(v);
      if (value == null) {
        valueTypeMap['null'] = true;
      } else if (value is int) {
        valueTypeMap['int'] = true;
      } else if (value is double) {
        valueTypeMap['double'] = true;
      } else if (value is bool) {
        valueTypeMap['bool'] = true;
      } else if (value is String) {
        valueTypeMap['string'] = true;
      } else {
        valueTypeMap['object'] = true;
      }
    });

    keyTypeMap = keyTypeMap.filter((k, v) => v == true);
    valueTypeMap = valueTypeMap.filter((k, v) => v == true);

    late String targetKeyType;
    late String targetValueType;

    if (keyTypeMap.length == 1) {
      targetKeyType = keyTypeMap.keys.first;
    } else if (keyTypeMap.length == 3 && keyTypeMap['num'] == true) {
      targetKeyType = 'num';
    } else {
      targetKeyType = 'dynamic';
    }

    if (valueTypeMap.length == 1) {
      targetValueType = valueTypeMap.keys.first;
    } else if (valueTypeMap.length == 3 && valueTypeMap['num'] == true) {
      targetValueType = 'num';
    } else {
      targetValueType = valueTypeMap['null'] == true ? 'dynamic' : 'object';
    }

    if (targetKeyType == 'dynamic') {
      if (targetValueType == 'object') return LinkedHashMap<Object, Object>.from(this);
      if (targetValueType == 'string') return LinkedHashMap<Object, String>.from(this);
      if (targetValueType == 'int') return LinkedHashMap<Object, int>.from(this);
      if (targetValueType == 'double') return LinkedHashMap<Object, double>.from(this);
      if (targetValueType == 'num') return LinkedHashMap<Object, num>.from(this);
      if (targetValueType == 'bool') return LinkedHashMap<Object, bool>.from(this);
      return LinkedHashMap<Object, dynamic>.from(this);
    } else {
      if (targetKeyType == 'string') {
        if (targetValueType == 'object') return LinkedHashMap<String, Object>.from(this);
        if (targetValueType == 'string') return LinkedHashMap<String, String>.from(this);
        if (targetValueType == 'int') return LinkedHashMap<String, int>.from(this);
        if (targetValueType == 'double') return LinkedHashMap<String, double>.from(this);
        if (targetValueType == 'num') return LinkedHashMap<String, num>.from(this);
        if (targetValueType == 'bool') return LinkedHashMap<String, bool>.from(this);
        return LinkedHashMap<String, dynamic>.from(this);
      }
      if (targetKeyType == 'int') {
        if (targetValueType == 'object') return LinkedHashMap<int, Object>.from(this);
        if (targetValueType == 'string') return LinkedHashMap<int, String>.from(this);
        if (targetValueType == 'int') return LinkedHashMap<int, int>.from(this);
        if (targetValueType == 'double') return LinkedHashMap<int, double>.from(this);
        if (targetValueType == 'num') return LinkedHashMap<int, num>.from(this);
        if (targetValueType == 'bool') return LinkedHashMap<int, bool>.from(this);
        return LinkedHashMap<int, dynamic>.from(this);
      }

      if (targetKeyType == 'double') {
        if (targetValueType == 'object') return LinkedHashMap<double, Object>.from(this);
        if (targetValueType == 'string') return LinkedHashMap<double, String>.from(this);
        if (targetValueType == 'int') return LinkedHashMap<double, int>.from(this);
        if (targetValueType == 'double') return LinkedHashMap<double, double>.from(this);
        if (targetValueType == 'num') return LinkedHashMap<double, num>.from(this);
        if (targetValueType == 'bool') return LinkedHashMap<double, bool>.from(this);
        return LinkedHashMap<double, dynamic>.from(this);
      }
      if (targetKeyType == 'bool') {
        if (targetValueType == 'object') return LinkedHashMap<bool, Object>.from(this);
        if (targetValueType == 'string') return LinkedHashMap<bool, String>.from(this);
        if (targetValueType == 'int') return LinkedHashMap<bool, int>.from(this);
        if (targetValueType == 'double') return LinkedHashMap<bool, double>.from(this);
        if (targetValueType == 'num') return LinkedHashMap<bool, num>.from(this);
        if (targetValueType == 'bool') return LinkedHashMap<bool, bool>.from(this);
        return LinkedHashMap<bool, dynamic>.from(this);
      }

      if (targetValueType == 'object') return LinkedHashMap<num, Object>.from(this);
      if (targetValueType == 'string') return LinkedHashMap<num, String>.from(this);
      if (targetValueType == 'int') return LinkedHashMap<num, int>.from(this);
      if (targetValueType == 'double') return LinkedHashMap<num, double>.from(this);
      if (targetValueType == 'num') return LinkedHashMap<num, num>.from(this);
      if (targetValueType == 'bool') return LinkedHashMap<num, bool>.from(this);
      return LinkedHashMap<num, dynamic>.from(this);
    }
  }
}
