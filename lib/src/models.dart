import 'common.dart';

/// 序列化模型接口
abstract interface class SerializeModel {
  /// 将 json 转成模型对象
  SerializeModel fromJson(Map<String, dynamic> json);

  /// 将模型对象转成 json
  Map<String, dynamic> toJson();
}

/// 包含 [width]、[height] 简单数据模型
class SizeModel implements SerializeModel {
  final double width;
  final double height;

  SizeModel(this.width, this.height);

  factory SizeModel.fromJson(Map<String, dynamic> json) => SizeModel(
        json['name'],
        json['age'],
      );

  @override
  SerializeModel fromJson(Map<String, dynamic> json) {
    return SizeModel.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return {'width': width, 'height': height};
  }

  @override
  String toString() {
    return 'SizeModel{width: $width, height: $height}';
  }
}

/// 包含 [label]、[value] 简单数据模型
class LabelModel implements SerializeModel {
  final String label;
  final String value;

  LabelModel(this.label, this.value);

  factory LabelModel.fromJson(Map<String, dynamic> json) => LabelModel(
        json['label'],
        json['value'],
      );

  @override
  SerializeModel fromJson(Map<String, dynamic> json) {
    return LabelModel.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return {'label': label, 'value': value};
  }

  @override
  String toString() {
    return 'LabelModel{label: $label, value: $value}';
  }
}

/// 包含过期时间数据模型
class ExpireDataModel implements SerializeModel {
  /// 存储的数据
  dynamic data;

  /// 过期时间，单位毫秒，如果为null或者小于等于0，[expire]将强制等于-1，表示没有过期时间，
  int? expire;

  ExpireDataModel(this.data, [int? expire]) {
    if (expire != null && expire > 0) {
      this.expire = currentMilliseconds + expire;
    } else {
      this.expire = -1;
    }
  }

  ExpireDataModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    expire = json['expire'];
  }

  @override
  SerializeModel fromJson(Map<String, dynamic> json) =>
      ExpireDataModel.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {'data': data, 'expire': expire};
}
