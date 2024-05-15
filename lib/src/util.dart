part of luoyi_dart_base;

/// 适用用dart、flutter通用工具类
class DartUtil {
  DartUtil._();

  static final Codec<String, String> _base64Codec = utf8.fuse(base64);

  /// 是否为release版
  static const bool isRelease = bool.fromEnvironment("dart.vm.product");

  /// 获取当前时间的毫秒
  static int get currentMilliseconds => DateTime.now().millisecondsSinceEpoch;

  /// 判断一个变量是否为空，例如：null、''、[]、{}
  ///
  /// checkNum - 若为true，则判断数字是否为0
  /// checkString - 若为true，则判断字符串是否为 'null'
  static bool isEmpty(
    dynamic value, {
    bool? checkNum,
    bool? checkString,
  }) {
    if (null == value) {
      return true;
    } else if (value is String) {
      var str = value.trim();
      if (checkString == true) {
        return str.isEmpty || str == 'null';
      } else {
        return str.isEmpty;
      }
    } else if (checkNum == true && value is num) {
      return value == 0;
    } else if (value is List) {
      return value.isEmpty;
    } else if (value is Map) {
      return value.isEmpty;
    } else if (value is Object) {
      return value == {};
    } else {
      return false;
    }
  }

  /// 判断变量是否是基本数据类型
  static bool isBaseType(dynamic value) {
    return (value is num || value is String || value is bool);
  }

  /// 检查传入的类型字符串是否是基本类型字符串
  static bool isBaseTypeString(String typeString) {
    return ['String', 'num', 'int', 'double', 'bool'].contains(typeString);
  }

  /// 获取Map-key泛型类型
  static String getMapKeyType(dynamic value) {
    if (value is Map) {
      var strList = value.runtimeType.toString().split(',');
      return strList.first.trim().replaceAll('_Map<', '');
    } else {
      return 'dynamic';
    }
  }

  /// 获取Map-value泛型类型
  static String getMapValueType(Map value) {
    var typeString = value.runtimeType.toString();
    var index = typeString.indexOf(',');
    var str = typeString.substring(index + 1, typeString.length).trim();
    return str.substring(0, str.length - 1);
  }

  /// 将动态类型转换成实际基础类型：String、int、double、num、bool，如果
  /// * strict 如果为true，对于非基础类型将一律返回null
  static dynamic dynamicToBaseType(dynamic value, [bool? strict]) {
    String type = value.runtimeType.toString();
    if (type == 'String') {
      dynamic v = int.tryParse(value);
      if (v != null) return v;
      v = double.tryParse(value);
      if (v != null) return v;
      v = bool.tryParse(value);
      if (v != null) return v;
      return value;
    }
    if (type == 'int') return value;
    if (type == 'double') return value;
    if (type == 'bool') return value;
    if (type == 'num') return value;
    return strict == true ? null : value;
  }

  /// 安全解析String，如果传递的value为空，则返回一个默认值
  static String safeString(
    dynamic value, {
    String defaultValue = '',
    String? suffixText, // 字符串后缀文字 (如果返回的字符串不为空)
  }) {
    if (isEmpty(value)) {
      return defaultValue;
    } else {
      if (suffixText == null) {
        return value.toString();
      } else {
        return value.toString() + suffixText;
      }
    }
  }

  /// 安全解析int，如果传递的value不是num类型，则返回默认值
  static int safeInt(dynamic value, {int defaultValue = 0}) {
    if (value is int) {
      return value.isNaN ? defaultValue : value;
    } else if (value is double) {
      return int.parse(value.toString());
    } else if (value is String && int.tryParse(value) != null) {
      return int.parse(value);
    } else {
      return defaultValue;
    }
  }

  /// 安全解析double，如果传递的value不是num类型，则返回默认值
  static double safeDouble(dynamic value, {double defaultValue = 0.0}) {
    if (value is double) {
      return value.isNaN ? defaultValue : value;
    } else if (value is int) {
      return double.parse(value.toString());
    } else if (value is String && double.tryParse(value) != null) {
      return double.parse(value);
    } else {
      return defaultValue;
    }
  }

  /// 安全解析bool类型
  static bool safeBool(dynamic value, {bool defaultValue = false}) {
    if (value is String) {
      try {
        return bool.parse(value, caseSensitive: false);
      } catch (e) {
        return false;
      }
    } else if (value is bool) {
      return value;
    }
    return defaultValue;
  }

  /// 安全解析List，若解析失败则返回空List
  static List<T> safeList<T>(dynamic value, {List<T> defaultValue = const []}) {
    if (value is List) {
      try {
        return value.cast<T>();
      } catch (e) {
        w(e, 'List case $T 转换失败，将返回空[]');
        return defaultValue;
      }
    } else {
      return defaultValue;
    }
  }

  /// 安全解析日期，支持字符串、时间戳等格式解析，如果格式不正确则返回defaultValue，
  /// 如果defaultValue为空，则会返回当前时间。
  static DateTime safeDate(
    dynamic value, {
    dynamic defaultValue,
  }) {
    if (isEmpty(value)) {
      return _defaultDate(defaultValue);
    } else if (value is String) {
      var date = DateTime.tryParse(value);
      return date ?? _defaultDate(defaultValue);
    } else if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    } else if (value is DateTime) {
      return value;
    } else {
      return _defaultDate(defaultValue);
    }
  }

  static DateTime _defaultDate(dynamic value) {
    if (isEmpty(value)) {
      return DateTime.now();
    } else if (value is String) {
      var date = DateTime.tryParse(value);
      return date ?? DateTime.now();
    } else if (value is DateTime) {
      return value;
    } else {
      return DateTime.now();
    }
  }

  /// 安全地比较两个字符
  static bool compareString(dynamic value1, dynamic value2) {
    return safeString(value1) == safeString(value2);
  }

  /// 安全地比较两个数字：小于、等于、大于、小于等于、大于等于。
  static bool compareNum(
    dynamic value1,
    dynamic value2, {
    CompareType compareType = CompareType.equal,
  }) {
    return _compareResult(compareType, safeDouble(value1) - safeDouble(value2));
  }

  /// 安全地比较两个日期，允许传入2个任意类型的数据，它们都会安全地转化为DateTime类型进行比较
  static bool compareDate(
    dynamic date1,
    dynamic date2, {
    CompareType compareType = CompareType.equal,
  }) {
    late int result; // 比较结果
    int nullValue1 = isEmpty(date1) ? 0 : 1;
    int nullValue2 = isEmpty(date2) ? 0 : 1;

    // 如果有一个值为空，则直接获取比较结果
    if (nullValue1 == 0 || nullValue2 == 0) {
      result = nullValue1 - nullValue2;
    } else {
      DateTime? dateTime1;
      DateTime? dateTime2;
      if (date1 is String) {
        dateTime1 = DateTime.tryParse(date1);
      } else if (date1 is DateTime) {
        dateTime1 = date1;
      } else {
        throw Exception('传入的date1类型错误');
      }
      if (date2 is String) {
        dateTime2 = DateTime.tryParse(date2);
      } else if (date2 is DateTime) {
        dateTime2 = date2;
      } else {
        throw Exception('传入的date2类型错误');
      }
      if (dateTime1 != null && dateTime2 != null) {
        result = dateTime1.compareTo(dateTime2);
      } else {
        result = (dateTime1 == null ? 0 : 1) - (dateTime2 == null ? 0 : 1);
      }
    }
    return _compareResult(compareType, result);
  }

  /// 比较两个日期，如果为true，则返回date1，否则返回date2。
  static DateTime getCompareDate(
    DateTime date1,
    DateTime date2, {
    CompareType compareType = CompareType.equal,
  }) {
    return compareDate(date1, date2, compareType: compareType) ? date1 : date2;
  }

  /// 获取date1和date2相差的时间，单位：毫秒
  static int diffDate(
    dynamic date1,
    dynamic date2,
  ) {
    return ((safeDate(date1).millisecondsSinceEpoch - safeDate(date2).millisecondsSinceEpoch)).truncate();
  }

  /// 获取date1和date2相差的天数
  static int diffDay(
    dynamic date1,
    dynamic date2,
  ) {
    return ((safeDate(date1).millisecondsSinceEpoch - safeDate(date2).millisecondsSinceEpoch) / 1000 / 60 / 60 / 24)
        .truncate();
  }

  /// 时间戳转倒计时
  static String millisecondToCountDown(int milliseconds) {
    assert(milliseconds > 0, '时间戳必须大于0');
    var duration = Duration(milliseconds: milliseconds);
    int days = duration.inDays;
    int hours = duration.inHours.remainder(24);
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);
    String hourText = hours.toString().padLeft(2, '0');
    String minuteText = minutes.toString().padLeft(2, '0');
    String secondText = seconds.toString().padLeft(2, '0');
    if (days > 0) {
      return '$days天$hourText时$minuteText分$secondText秒';
    } else if (hours > 0) {
      return '$hourText时$minuteText分$secondText秒';
    } else if (minutes > 0) {
      return '$minuteText分$secondText秒';
    } else {
      return '$secondText秒';
    }
  }

  /// 以指定格式解析日期
  static String formatDate(dynamic value, {String format = 'yyyy-MM-dd HH:mm:ss'}) {
    var dateTime = safeDate(value);
    if (format.contains('yy')) {
      String year = dateTime.year.toString();
      if (format.contains('yyyy')) {
        format = format.replaceAll('yyyy', year);
      } else {
        format = format.replaceAll('yy', year.substring(year.length - 2, year.length));
      }
    }

    format = _comFormat(dateTime.month, format, 'M', 'MM');
    format = _comFormat(dateTime.day, format, 'd', 'dd');
    format = _comFormat(dateTime.hour, format, 'H', 'HH');
    format = _comFormat(dateTime.minute, format, 'm', 'mm');
    format = _comFormat(dateTime.second, format, 's', 'ss');
    format = _comFormat(dateTime.millisecond, format, 'S', 'SSS');

    return format;
  }

  static String _comFormat(int value, String format, String single, String full) {
    if (format.contains(single)) {
      if (format.contains(full)) {
        format = format.replaceAll(full, value < 10 ? '0$value' : value.toString());
      } else {
        format = format.replaceAll(single, value.toString());
      }
    }
    return format;
  }

  /// 格式化大小
  static String formatSize(size) {
    if (size == null || size == '' || size == 0) {
      return '0KB';
    }
    const unitArr = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
    int index;
    var $size = safeDouble(size);
    index = (math.log($size) / math.log(1024)).floor();
    return '${($size / math.pow(1024, index)).toStringAsFixed(2)}${unitArr[index]}';
  }

  /// 获取地址中的文件名
  static String? getUrlFileName(String? url) {
    return p.basename(url ?? '');
  }

  /// 获取地址中的文件名但不包含扩展名
  static String? getUrlFileNameNoExtension(String? url) {
    return p.basenameWithoutExtension(url ?? '');
  }

  /// 获取文件名后缀
  static String? getFileSuffix(String fileName) {
    String suffixName = p.extension(fileName);
    if (!isEmpty(suffixName) && suffixName.startsWith('.')) {
      return suffixName.replaceFirst('.', '');
    } else {
      return null;
    }
  }

  /// 判断文件名是否是图片
  static bool isImage(String fileName) {
    String? suffixName = getFileSuffix(fileName);
    return ['jpg', 'jpeg', 'png', 'gif'].contains(suffixName);
  }

  /// 判断文件名是否是静态图片
  static bool isStaticImage(String fileName) {
    String? suffixName = getFileSuffix(fileName);
    return ['jpg', 'jpeg', 'png'].contains(suffixName);
  }

  /// 判断文件名是否是视频
  static bool isVideo(String fileName) {
    String? suffixName = getFileSuffix(fileName);
    return ['mkv', 'mp4', 'avi', 'mov', 'wmv'].contains(suffixName);
  }

  /// 判断list集合中是否包含满足某个条件的元素
  static bool listContains<E>(List<E> list, bool Function(E element) action) {
    for (var listItem in list) {
      if (action(listItem)) {
        return true;
      }
    }
    return false;
  }

  /// 拼接上级地址，返回新的path，主要过滤新地址尾部多余的/
  static String joinParentPath(String path, [String? parentPath]) {
    String $path = parentPath != null ? parentPath + path : path;
    if ($path.endsWith('/') && parentPath != null) {
      $path = $path.substring(0, $path.length - 1);
    }
    return $path;
  }

  /// 计算限制后的元素尺寸，返回类似于自适应大小的图片尺寸
  static SizeModel calcConstraintsSize(
    double width,
    double height,
    double maxWidth,
    double maxHeight,
  ) {
    late double newWidth;
    late double newHeight;
    if (width > height) {
      if (width > maxWidth) {
        newWidth = maxWidth;
        double aspect = maxWidth / width;
        newHeight = (height * aspect).ceilToDouble();
      } else {
        newWidth = width;
        newHeight = height;
      }
    } else {
      if (height > maxHeight) {
        newHeight = maxHeight;
        double aspect = maxHeight / height;
        newWidth = (width * aspect).ceilToDouble();
      } else {
        newWidth = width;
        newHeight = height;
      }
    }
    return SizeModel(newWidth, newHeight);
  }

  /// 循环获取列表的内容，如果其索引大于列表的长度，则重头开始继续获取
  static T loopGetListContent<T>(List<T> list, int index) {
    if (index <= 0) {
      return list[0];
    } else if (index < list.length) {
      return list[index];
    } else {
      return loopGetListContent(list, index - list.length);
    }
  }

  /// 使用md5加密字符串
  static String md5(String str) {
    return crypto.md5.convert(utf8.encode(str)).toString();
  }

  /// 字符串转base64
  static String toBase64(String str) {
    return _base64Codec.encode(str);
  }

  /// base64转字符串
  static String formBase64(String base64Str) {
    return _base64Codec.decode(base64Str);
  }

  /// 将字符串编码压缩
  static String encodeString(String str) {
    List<int> stringBytes = utf8.encode(str);
    List<int> gzipBytes = GZipEncoder().encode(stringBytes)!;
    return base64UrlEncode(gzipBytes);
  }

  /// 将字符串编码压缩
  static String decodeString(String str) {
    List<int> stringBytes = base64Url.decode(str);
    List<int> gzipBytes = GZipDecoder().decodeBytes(stringBytes);
    return utf8.decode(gzipBytes);
  }

  /// 给定一个包含任意类型的变量数组，判断内部变量是否仅有一个元素不为null
  /// * allowAllNull 允许所有变量均为null
  static bool onlyOneNotNull(
    List values, {
    bool allowAllNull = false,
  }) {
    final l = values.where((e) => e != null).length;
    return allowAllNull ? l == 0 || l == 1 : l == 1;
  }
}

/// 比较两个值的条件类型
enum CompareType {
  /// 小于
  less,

  /// 小于等于
  lessEqual,

  /// 等于
  equal,

  /// 大于等于
  thanEqual,

  /// 大于
  than,
}

bool _compareResult(CompareType compareType, num result) {
  switch (compareType) {
    case CompareType.equal:
      return result == 0;
    case CompareType.less:
      return result < 0;
    case CompareType.lessEqual:
      return result <= 0;
    case CompareType.than:
      return result > 0;
    case CompareType.thanEqual:
      return result >= 0;
  }
}

/// 自动转换Map的实际类型
Map _autoCastMap<K, V>(Map<K, V> map) {
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

  map.forEach((k, v) {
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
    } else if (value is Map) {
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
    if (targetValueType == 'object') return LinkedHashMap<Object, Object>.from(map);
    if (targetValueType == 'string') return LinkedHashMap<Object, String>.from(map);
    if (targetValueType == 'int') return LinkedHashMap<Object, int>.from(map);
    if (targetValueType == 'double') return LinkedHashMap<Object, double>.from(map);
    if (targetValueType == 'num') return LinkedHashMap<Object, num>.from(map);
    if (targetValueType == 'bool') return LinkedHashMap<Object, bool>.from(map);
    return map.cast<Object, dynamic>();
  } else {
    if (targetKeyType == 'string') {
      if (targetValueType == 'object') return LinkedHashMap<String, Object>.from(map);
      if (targetValueType == 'string') return LinkedHashMap<String, String>.from(map);
      if (targetValueType == 'int') return LinkedHashMap<String, int>.from(map);
      if (targetValueType == 'double') return LinkedHashMap<String, double>.from(map);
      if (targetValueType == 'num') return LinkedHashMap<String, num>.from(map);
      if (targetValueType == 'bool') return LinkedHashMap<String, bool>.from(map);
      return LinkedHashMap<String, dynamic>.from(map);
    }
    if (targetKeyType == 'int') {
      if (targetValueType == 'object') return LinkedHashMap<int, Object>.from(map);
      if (targetValueType == 'string') return LinkedHashMap<int, String>.from(map);
      if (targetValueType == 'int') return LinkedHashMap<int, int>.from(map);
      if (targetValueType == 'double') return LinkedHashMap<int, double>.from(map);
      if (targetValueType == 'num') return LinkedHashMap<int, num>.from(map);
      if (targetValueType == 'bool') return LinkedHashMap<int, bool>.from(map);
      return LinkedHashMap<int, dynamic>.from(map);
    }

    if (targetKeyType == 'double') {
      if (targetValueType == 'object') return LinkedHashMap<double, Object>.from(map);
      if (targetValueType == 'string') return LinkedHashMap<double, String>.from(map);
      if (targetValueType == 'int') return LinkedHashMap<double, int>.from(map);
      if (targetValueType == 'double') return LinkedHashMap<double, double>.from(map);
      if (targetValueType == 'num') return LinkedHashMap<double, num>.from(map);
      if (targetValueType == 'bool') return LinkedHashMap<double, bool>.from(map);
      return LinkedHashMap<double, dynamic>.from(map);
    }
    if (targetKeyType == 'bool') {
      if (targetValueType == 'object') return LinkedHashMap<bool, Object>.from(map);
      if (targetValueType == 'string') return LinkedHashMap<bool, String>.from(map);
      if (targetValueType == 'int') return LinkedHashMap<bool, int>.from(map);
      if (targetValueType == 'double') return LinkedHashMap<bool, double>.from(map);
      if (targetValueType == 'num') return LinkedHashMap<bool, num>.from(map);
      if (targetValueType == 'bool') return LinkedHashMap<bool, bool>.from(map);
      return LinkedHashMap<bool, dynamic>.from(map);
    }

    if (targetValueType == 'object') return LinkedHashMap<num, Object>.from(map);
    if (targetValueType == 'string') return LinkedHashMap<num, String>.from(map);
    if (targetValueType == 'int') return LinkedHashMap<num, int>.from(map);
    if (targetValueType == 'double') return LinkedHashMap<num, double>.from(map);
    if (targetValueType == 'num') return LinkedHashMap<num, num>.from(map);
    if (targetValueType == 'bool') return LinkedHashMap<num, bool>.from(map);
    return LinkedHashMap<num, dynamic>.from(map);
  }
}
