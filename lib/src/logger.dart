import 'package:logger/logger.dart';

import 'common.dart';

PrettyPrinter _prettyPrinter = PrettyPrinter(
  methodCount: 2,
  errorMethodCount: 2,
  printEmojis: false,
  noBoxingByDefault: false,
);

var _loggerInstance = Logger(
  printer: _prettyPrinter,
  filter: _LoggerFilter(loggerLevel: null),
);

class _LoggerFilter extends LogFilter {
  final Level? loggerLevel;

  _LoggerFilter({this.loggerLevel});

  @override
  bool shouldLog(LogEvent event) {
    if (loggerLevel == null) {
      return !isRelease;
    } else {
      return event.level.value >= loggerLevel!.value;
    }
  }
}

/// 自定义设置打印日志实例，你需要自行引入 [logger] 依赖。
///
/// * level 显示的日志级别，如果为null，则在开发模式下显示所有的日志，生产模式下则屏蔽所有日志；
/// 如果指定了日志级别，那么在开发模式下和生产模式下将显示指定的日志级别之上的所有日志。
/// 例：
/// ``` dart
/// // 开发、生产模式下显示info级别以上日志
/// initLogger(level: Level.info);
///
/// // 开发模式下显示info级别以上日志，生产模式不显示日志
/// initLogger(level: isRelease ? null : Level.info);
/// ```
/// * logger 完全自定义日志实例
void setLogger({Level? level, Logger? logger}) {
  _loggerInstance = logger ??
      Logger(
        printer: _prettyPrinter,
        filter: _LoggerFilter(loggerLevel: level),
      );
}

/// debug 级别日志输出
void d(dynamic message, [dynamic title]) {
  _loggerInstance.d(message, error: title);
}

/// info 级别日志输出
void i(dynamic message, [dynamic title]) {
  _loggerInstance.i(message, error: title);
}

/// warning 级别日志输出
void w(dynamic message, [dynamic title]) {
  _loggerInstance.w(message, error: title);
}

/// error 级别日志输出
void e(dynamic message, [dynamic title]) {
  _loggerInstance.e(message, error: title);
}
