import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

import 'logger.dart';

/// 是否为release版
const bool isRelease = bool.fromEnvironment("dart.vm.product");

/// 获取当前时间的毫秒
int get currentMilliseconds => DateTime.now().millisecondsSinceEpoch;

/// uuid实例对象
///
/// ```dart
/// // Generate a v1 (time-based) id
/// uuid.v1(); // -> '6c84fb90-12c4-11e1-840d-7b25c5ee775a'
///
/// // Generate a v4 (random) id
/// uuid.v4(); // -> '110ec58a-a0f2-4ac4-8393-c866d813b8d1'
///
/// // Generate a v5 (namespace-name-sha1-based) id
/// uuid.v5(Uuid.NAMESPACE_URL, 'www.google.com'); // -> 'c74a196f-f19d-5ea9-bffd-a2742432fc9c'
/// ```
const Uuid uuid = Uuid();

/// 生成不带 '-' 符号的uuid字符串
String get uuidStr => uuid.v4().replaceAll('-', '');

/// 设置打印日志实例
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
void setLogger({Level? level, Logger? logger}) {
  loggerInstance = logger ??
      Logger(
        printer: prettyPrinter,
        filter: LoggerFilter(loggerLevel: level),
      );
}
