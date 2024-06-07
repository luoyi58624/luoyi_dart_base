import 'package:logger/logger.dart';

import 'global.dart';

PrettyPrinter prettyPrinter = PrettyPrinter(
  methodCount: 2,
  errorMethodCount: 2,
  printEmojis: false,
  noBoxingByDefault: false,
);

var loggerInstance = Logger(
  printer: prettyPrinter,
  filter: LoggerFilter(loggerLevel: null),
);

/// debug 级别日志输出
void d(dynamic message, [dynamic title]) {
  loggerInstance.d(message, error: title);
}

/// info 级别日志输出
void i(dynamic message, [dynamic title]) {
  loggerInstance.i(message, error: title);
}

/// warning 级别日志输出
void w(dynamic message, [dynamic title]) {
  loggerInstance.w(message, error: title);
}

/// error 级别日志输出
void e(dynamic message, [dynamic title]) {
  loggerInstance.e(message, error: title);
}

class LoggerFilter extends LogFilter {
  final Level? loggerLevel;

  LoggerFilter({this.loggerLevel});

  @override
  bool shouldLog(LogEvent event) {
    if (loggerLevel == null) {
      return !isRelease;
    } else {
      return event.level.value >= loggerLevel!.value;
    }
  }
}
