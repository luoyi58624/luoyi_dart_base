part of luoyi_dart_base;

PrettyPrinter _prettyPrinter = PrettyPrinter(
  methodCount: 2,
  errorMethodCount: 2,
  printEmojis: false,
  noBoxingByDefault: false,
);

var _logger = Logger(
  printer: _prettyPrinter,
  filter: _LogFilter(loggerLevel: null),
);

/// 自定义初始化日志
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
/// * logger 自定义logger
void initLogger({Level? level, Logger? logger}) {
  _logger = logger ??
      Logger(
        printer: _prettyPrinter,
        filter: _LogFilter(loggerLevel: level),
      );
}

/// debug 级别日志输出
void d(dynamic message, [dynamic title]) {
  _logger.d(message, error: title);
}

/// info 级别日志输出
void i(dynamic message, [dynamic title]) {
  _logger.i(message, error: title);
}

/// warning 级别日志输出
void w(dynamic message, [dynamic title]) {
  _logger.w(message, error: title);
}

/// error 级别日志输出
void e(dynamic message, [dynamic title]) {
  _logger.e(message, error: title);
}

class _LogFilter extends LogFilter {
  final Level? loggerLevel;

  _LogFilter({this.loggerLevel});

  @override
  bool shouldLog(LogEvent event) {
    if (loggerLevel == null) {
      return !DartUtil.isRelease;
    } else {
      return event.level.value >= loggerLevel!.value;
    }
  }
}
