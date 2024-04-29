/// Support for doing something awesome.
///
/// More dartdocs go here.
library luoyi_dart_base;

import 'dart:convert';
import 'dart:math' as math;
import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import 'package:crypto/crypto.dart' as crypto;
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

/// Dart官方库，对List、Map做增强
export 'package:collection/collection.dart';

/// 生成假数据
export 'package:faker/faker.dart';

part 'src/model.dart';

part 'src/util.dart';

part 'src/logger.dart';

part 'src/uuid.dart';
