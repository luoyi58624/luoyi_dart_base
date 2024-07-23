import 'dart:async';

extension DartNumExtension on num {
  /// 延迟指定时间再执行任务，单位：秒
  Future delay([FutureOr Function()? callback]) async => Future.delayed(
        Duration(milliseconds: (this * 1000).round()),
        callback,
      );
}
