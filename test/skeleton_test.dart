import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:g_skeleton/skeleton.dart';

void main() {
  test('skeleton controller increasing logic', () {
    final controller = SkeletonController();

    var index = controller.newGroupIndex(null);

    expect(index, 0);

    final key = UniqueKey();
    index = controller.newGroupIndex(key);
    expect(index, 1);

    index = controller.newGroupIndex(key);
    expect(index, 1);

    index = controller.newGroupIndex(UniqueKey());
    expect(index, 2);
  });
}
