part of luoyi_dart_base;

/// 数据模型序列化，一般用于本地持久化缓存
/// ```dart
/// class UserModel extends ModelSerialize {
///   UserModel({this.name, this.age});
///
///   String? name;
///   int? age;
///
///   factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
///         name: json['name'],
///         age: DartUtil.safeInt(json['age']),
///       );
///
///   @override
///   UserModel fromJson(Map<String, dynamic> json) => UserModel.fromJson(json);
///
///   @override
///   Map<String, dynamic> toJson() => {'name': name, 'age': age};
/// }
/// ```
abstract class ModelSerialize {
  ModelSerialize fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson();
}

/// 包含 label-value 结构的简单数据模型
class LabelModel {
  final String label;
  final String value;

  LabelModel(this.label, this.value);

  @override
  String toString() {
    return 'LabelModel{label: $label, value: $value}';
  }
}

/// 尺寸 Model 数据模型
class SizeModel {
  final double width;
  final double height;

  SizeModel(this.width, this.height);

  @override
  String toString() {
    return 'SizeModel{width: $width, height: $height}';
  }
}
