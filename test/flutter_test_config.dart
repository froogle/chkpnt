import 'dart:async';

import 'package:flutter/foundation.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  debugPrint = (String? message, {int? wrapWidth}) {};
  await testMain();
}
