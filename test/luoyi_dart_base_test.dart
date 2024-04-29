import 'package:luoyi_dart_base/luoyi_dart_base.dart';
import 'package:test/test.dart';

void main() {
  group('DartUtil', () {
    test('onlyOneNotNull', () {
      expect(DartUtil.onlyOneNotNull(['x', null]), isTrue);
      expect(DartUtil.onlyOneNotNull(['x', null, 1]), isFalse);
      expect(DartUtil.onlyOneNotNull([null, null]), isFalse);
      expect(DartUtil.onlyOneNotNull([null, null, 1]), isTrue);
      expect(DartUtil.onlyOneNotNull([null, null, null]), isFalse);
      expect(DartUtil.onlyOneNotNull([null, null, null], allowAllNull: true), isTrue);
    });
  });
}
