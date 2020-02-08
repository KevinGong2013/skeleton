library g_skeleton;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class Skeleton extends StatefulWidget {
  final SkeletonController controller;
  final Key increasing;

  Skeleton(this.controller, {this.increasing}) : assert(controller != null);

  @override
  _SkeletonState createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _colorTween;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: widget.controller.duration,
        reverseDuration: widget.controller.duration * 2,
        vsync: this);
    _colorTween =
        ColorTween(begin: widget.controller.begin, end: widget.controller.end)
            .animate(_controller);

    widget.controller.append(_SkeletonContext(
        _controller, widget.controller.newGroupIndex(widget.increasing)));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorTween,
      builder: (BuildContext context, Widget child) {
        return Container(
          color: _colorTween.value,
        );
      },
    );
  }
}

class _SkeletonContext {
  final AnimationController controller;
  final int groupIndex;

  _SkeletonContext(this.controller, this.groupIndex);
}

class SkeletonController {
  int _total = 1;
  bool _stop;
  Key _increasing;
  bool get hasStarted => (_stop == null) ? false : !_stop;

  // The length of time of skeleton animation.
  //
  // reverse duration = duration * 2
  //
  final Duration duration;

  // Skeleton animation repeat interval
  //
  //
  final Duration interval;

  // Skeleton animation colorTween
  final Color begin;
  final Color end;

  final Map<int, List<_SkeletonContext>> _contexts = {};

  SkeletonController(
      {this.duration = const Duration(milliseconds: 200),
      this.interval = const Duration(seconds: 2),
      this.begin = const Color(0xFFE5E5EA),
      this.end = const Color(0xFFEFEFF4)});

  // create index for new widget
  int newGroupIndex(Key increasing) {
    if (increasing == null) {
      return _total - 1;
    }
    if (_increasing != increasing) {
      _increasing = increasing;
      return _total++;
    }
    return _total - 1;
  }

  void append(_SkeletonContext context) {
    var contexts = _contexts[context.groupIndex] ?? [];
    contexts.add(context);
    _contexts[context.groupIndex] = contexts;
  }

  void _forward() async {
    if (_stop) {
      return;
    }

    for (final e in _contexts.entries) {
      await Future.wait(e.value.map(
          (c) => c.controller.forward().then((v) => c.controller.reverse())));
      await Future.delayed(Duration(milliseconds: 100));
    }

    await Future.delayed(this.interval + duration * _contexts.length);
    _forward();
  }

  void start() {
    assert(!hasStarted, 'already started');
    _stop = false;
    _forward();
  }

  void stop() {
    _stop = true;
  }
}
