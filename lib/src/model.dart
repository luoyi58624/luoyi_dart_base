part of luoyi_dart_base;

/// 包含label-value结构的简单数据模型
class LabelModel {
  final String label;
  final String value;

  LabelModel(this.label, this.value);
}

class SizeModel {
  final double width;
  final double height;

  SizeModel(this.width, this.height);

  @override
  String toString() {
    return 'SizeModel{width: $width, height: $height}';
  }
}
