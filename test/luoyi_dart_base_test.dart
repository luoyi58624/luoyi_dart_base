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

    test('mapAutoCast', () {
      Map map = {'name': 'hihi', 'age': 20};
      Map<String, dynamic> castMap = DartUtil.mapAutoCast(map);
      expect(map.runtimeType.toString(), '_Map<dynamic, dynamic>');
      expect(castMap.runtimeType.toString(), '_Map<String, Object>');

      Map map2 = {'name': 'hihi', 'age': 20, 'demo': null};
      Map castMap2 = DartUtil.mapAutoCast(map2);
      expect(map2.runtimeType.toString(), '_Map<dynamic, dynamic>');
      expect(castMap2.runtimeType.toString(), '_Map<String, dynamic>');
    });
  });
}
