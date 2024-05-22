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
