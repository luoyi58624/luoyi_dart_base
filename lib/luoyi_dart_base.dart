library luoyi_dart_base;

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math' as math;
import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import 'package:crypto/crypto.dart' as crypto;
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

export 'package:logger/logger.dart' show Level;

part 'src/extension.dart';

part 'src/logger.dart';

part 'src/util.dart';

part 'src/model.dart';

part 'src/uuid.dart';

class DartBase {
  DartBase._();

  /// 设置日志打印实例
  /// * level 显示的日志级别，如果为null，则在开发模式下显示所有的日志，生产模式下则屏蔽所有日志；
  /// 如果指定了日志级别，那么在开发模式下和生产模式下将显示指定的日志级别之上的所有日志。
  /// 例：
  /// ``` dart
  ///   // 开发、生产模式下显示info级别及以上的日志
  ///   initLogger(level: Level.info);
  ///
  ///   // 开发模式下显示info级别及以上的日志，生产模式不显示日志
  ///   initLogger(level: DartUtil.isRelease ? null : Level.info);
  /// ```
  /// * logger 完全自定义日志实例，请自行添加依赖包，本库仅导出 Level Api
  static void setLogger({Level? level, Logger? logger}) {
    _logger = logger ??
        Logger(
          printer: _prettyPrinter,
          filter: _LogFilter(loggerLevel: level),
        );
  }
}
