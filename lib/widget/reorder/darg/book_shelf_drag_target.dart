// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

typedef BookShelfDragAnchorStrategy = Offset Function(
    BookShelfDraggable<Object> draggable,
    BuildContext context,
    Offset position);

Offset childDragAnchorStrategy(BookShelfDraggable<Object> draggable,
    BuildContext context, Offset position) {
  final RenderBox renderObject = context.findRenderObject()! as RenderBox;
  return renderObject.globalToLocal(position);
}

Offset pointerDragAnchorStrategy(BookShelfDraggable<Object> draggable,
    BuildContext context, Offset position) {
  return Offset.zero;
}

class BookShelfDraggable<T extends Object> extends StatefulWidget {
  /// Creates a widget that can be dragged to a [BookShelfDragTarget].
  ///
  /// The [child] and [feedback] arguments must not be null. If
  /// [maxSimultaneousDrags] is non-null, it must be non-negative.
  const BookShelfDraggable({
    Key? key,
    required this.child,
    required this.feedback,
    this.data,
    this.axis,
    this.childWhenDragging,
    this.feedbackOffset = Offset.zero,
    this.dragAnchorStrategy,
    this.affinity,
    this.maxSimultaneousDrags,
    this.onDragStarted,
    this.onDragUpdate,
    this.onDraggableCanceled,
    this.onDragEnd,
    this.onDragCompleted,
    this.ignoringFeedbackSemantics = true,
    this.rootOverlay = false,
    this.hitTestBehavior = HitTestBehavior.deferToChild,
  })  : assert(child != null),
        assert(feedback != null),
        assert(ignoringFeedbackSemantics != null),
        assert(maxSimultaneousDrags == null || maxSimultaneousDrags >= 0),
        super(key: key);

  /// The data that will be dropped by this draggable.
  final T? data;

  /// The [Axis] to restrict this draggable's movement, if specified.
  ///
  /// When axis is set to [Axis.horizontal], this widget can only be dragged
  /// horizontally. Behavior is similar for [Axis.vertical].
  ///
  /// Defaults to allowing drag on both [Axis.horizontal] and [Axis.vertical].
  ///
  /// When null, allows drag on both [Axis.horizontal] and [Axis.vertical].
  ///
  /// For the direction of gestures this widget competes with to start a drag
  /// event, see [BookShelfDraggable.affinity].
  final Axis? axis;

  /// The widget below this widget in the tree.
  ///
  /// This widget displays [child] when zero drags are under way. If
  /// [childWhenDragging] is non-null, this widget instead displays
  /// [childWhenDragging] when one or more drags are underway. Otherwise, this
  /// widget always displays [child].
  ///
  /// The [feedback] widget is shown under the pointer when a drag is under way.
  ///
  /// To limit the number of simultaneous drags on multitouch devices, see
  /// [maxSimultaneousDrags].
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  /// The widget to display instead of [child] when one or more drags are under way.
  ///
  /// If this is null, then this widget will always display [child] (and so the
  /// drag source representation will not change while a drag is under
  /// way).
  ///
  /// The [feedback] widget is shown under the pointer when a drag is under way.
  ///
  /// To limit the number of simultaneous drags on multitouch devices, see
  /// [maxSimultaneousDrags].
  final Widget? childWhenDragging;

  /// The widget to show under the pointer when a drag is under way.
  ///
  /// See [child] and [childWhenDragging] for information about what is shown
  /// at the location of the [BookShelfDraggable] itself when a drag is under way.
  final Widget feedback;

  /// The feedbackOffset can be used to set the hit test target point for the
  /// purposes of finding a drag target. It is especially useful if the feedback
  /// is transformed compared to the child.
  final Offset feedbackOffset;

  /// A strategy that is used by this draggable to get the anchor offset when it
  /// is dragged.
  ///
  /// The anchor offset refers to the distance between the users' fingers and
  /// the [feedback] widget when this draggable is dragged.
  ///
  /// This property's value is a function that implements [BookShelfDragAnchorStrategy].
  /// There are two built-in functions that can be used:
  ///
  ///  * [childDragAnchorStrategy], which displays the feedback anchored at the
  ///    position of the original child.
  ///
  ///  * [pointerDragAnchorStrategy], which displays the feedback anchored at the
  ///    position of the touch that started the drag.
  ///
  /// Defaults to [childDragAnchorStrategy] if the deprecated [dragAnchor]
  /// property is set to [DragAnchor.child], and [pointerDragAnchorStrategy] if
  /// the [dragAnchor] is set to [DragAnchor.pointer].
  final BookShelfDragAnchorStrategy? dragAnchorStrategy;

  /// Whether the semantics of the [feedback] widget is ignored when building
  /// the semantics tree.
  ///
  /// This value should be set to false when the [feedback] widget is intended
  /// to be the same object as the [child].  Placing a [GlobalKey] on this
  /// widget will ensure semantic focus is kept on the element as it moves in
  /// and out of the feedback position.
  ///
  /// Defaults to true.
  final bool ignoringFeedbackSemantics;

  /// Controls how this widget competes with other gestures to initiate a drag.
  ///
  /// If affinity is null, this widget initiates a drag as soon as it recognizes
  /// a tap down gesture, regardless of any directionality. If affinity is
  /// horizontal (or vertical), then this widget will compete with other
  /// horizontal (or vertical, respectively) gestures.
  ///
  /// For example, if this widget is placed in a vertically scrolling region and
  /// has horizontal affinity, pointer motion in the vertical direction will
  /// result in a scroll and pointer motion in the horizontal direction will
  /// result in a drag. Conversely, if the widget has a null or vertical
  /// affinity, pointer motion in any direction will result in a drag rather
  /// than in a scroll because the draggable widget, being the more specific
  /// widget, will out-compete the [Scrollable] for vertical gestures.
  ///
  /// For the directions this widget can be dragged in after the drag event
  /// starts, see [BookShelfDraggable.axis].
  final Axis? affinity;

  /// How many simultaneous drags to support.
  ///
  /// When null, no limit is applied. Set this to 1 if you want to only allow
  /// the drag source to have one item dragged at a time. Set this to 0 if you
  /// want to prevent the draggable from actually being dragged.
  ///
  /// If you set this property to 1, consider supplying an "empty" widget for
  /// [childWhenDragging] to create the illusion of actually moving [child].
  final int? maxSimultaneousDrags;

  /// Called when the draggable starts being dragged.
  final VoidCallback? onDragStarted;

  /// Called when the draggable is dragged.
  ///
  /// This function will only be called while this widget is still mounted to
  /// the tree (i.e. [State.mounted] is true), and if this widget has actually moved.
  final DragUpdateCallback? onDragUpdate;

  /// Called when the draggable is dropped without being accepted by a [BookShelfDragTarget].
  ///
  /// This function might be called after this widget has been removed from the
  /// tree. For example, if a drag was in progress when this widget was removed
  /// from the tree and the drag ended up being canceled, this callback will
  /// still be called. For this reason, implementations of this callback might
  /// need to check [State.mounted] to check whether the state receiving the
  /// callback is still in the tree.
  final DraggableCanceledCallback? onDraggableCanceled;

  /// Called when the draggable is dropped and accepted by a [BookShelfDragTarget].
  ///
  /// This function might be called after this widget has been removed from the
  /// tree. For example, if a drag was in progress when this widget was removed
  /// from the tree and the drag ended up completing, this callback will
  /// still be called. For this reason, implementations of this callback might
  /// need to check [State.mounted] to check whether the state receiving the
  /// callback is still in the tree.
  final VoidCallback? onDragCompleted;

  /// Called when the draggable is dropped.
  ///
  /// The velocity and offset at which the pointer was moving when it was
  /// dropped is available in the [DraggableDetails]. Also included in the
  /// `details` is whether the draggable's [BookShelfDragTarget] accepted it.
  ///
  /// This function will only be called while this widget is still mounted to
  /// the tree (i.e. [State.mounted] is true).
  final DragEndCallback? onDragEnd;

  /// Whether the feedback widget will be put on the root [Overlay].
  ///
  /// When false, the feedback widget will be put on the closest [Overlay]. When
  /// true, the [feedback] widget will be put on the farthest (aka root)
  /// [Overlay].
  ///
  /// Defaults to false.
  final bool rootOverlay;

  /// How to behave during hit test.
  ///
  /// Defaults to [HitTestBehavior.deferToChild].
  final HitTestBehavior hitTestBehavior;

  /// Creates a gesture recognizer that recognizes the start of the drag.
  ///
  /// Subclasses can override this function to customize when they start
  /// recognizing a drag.
  @protected
  MultiDragGestureRecognizer createRecognizer(
      GestureMultiDragStartCallback onStart) {
    switch (affinity) {
      case Axis.horizontal:
        return HorizontalMultiDragGestureRecognizer()..onStart = onStart;
      case Axis.vertical:
        return VerticalMultiDragGestureRecognizer()..onStart = onStart;
      case null:
        return ImmediateMultiDragGestureRecognizer()..onStart = onStart;
    }
  }

  @override
  State<BookShelfDraggable<T>> createState() => _BookShelfDraggableState<T>();
}

class BookShelfLongPressDraggable<T extends Object>
    extends BookShelfDraggable<T> {
  /// Creates a widget that can be dragged starting from long press.
  ///
  /// The [child] and [feedback] arguments must not be null. If
  /// [maxSimultaneousDrags] is non-null, it must be non-negative.
  const BookShelfLongPressDraggable({
    Key? key,
    required Widget child,
    required Widget feedback,
    T? data,
    Axis? axis,
    Widget? childWhenDragging,
    Offset feedbackOffset = Offset.zero,
    BookShelfDragAnchorStrategy? dragAnchorStrategy,
    int? maxSimultaneousDrags,
    VoidCallback? onDragStarted,
    DragUpdateCallback? onDragUpdate,
    DraggableCanceledCallback? onDraggableCanceled,
    DragEndCallback? onDragEnd,
    VoidCallback? onDragCompleted,
    this.hapticFeedbackOnStart = true,
    bool ignoringFeedbackSemantics = true,
    this.delay = kLongPressTimeout,
  }) : super(
          key: key,
          child: child,
          feedback: feedback,
          data: data,
          axis: axis,
          childWhenDragging: childWhenDragging,
          feedbackOffset: feedbackOffset,
          dragAnchorStrategy: dragAnchorStrategy,
          maxSimultaneousDrags: maxSimultaneousDrags,
          onDragStarted: onDragStarted,
          onDragUpdate: onDragUpdate,
          onDraggableCanceled: onDraggableCanceled,
          onDragEnd: onDragEnd,
          onDragCompleted: onDragCompleted,
          ignoringFeedbackSemantics: ignoringFeedbackSemantics,
        );

  /// Whether haptic feedback should be triggered on drag start.
  final bool hapticFeedbackOnStart;

  /// The duration that a user has to press down before a long press is registered.
  ///
  /// Defaults to [kLongPressTimeout].
  final Duration delay;

  @override
  DelayedMultiDragGestureRecognizer createRecognizer(
      GestureMultiDragStartCallback onStart) {
    return DelayedMultiDragGestureRecognizer(delay: delay)
      ..onStart = (Offset position) {
        final Drag? result = onStart(position);
        if (result != null && hapticFeedbackOnStart)
          HapticFeedback.selectionClick();
        return result;
      };
  }
}

class _BookShelfDraggableState<T extends Object>
    extends State<BookShelfDraggable<T>> {
  @override
  void initState() {
    super.initState();
    _recognizer = widget.createRecognizer(_startDrag);
  }

  @override
  void dispose() {
    _disposeRecognizerIfInactive();
    super.dispose();
  }

  GestureRecognizer? _recognizer;
  int _activeCount = 0;

  void _disposeRecognizerIfInactive() {
    if (_activeCount > 0) return;
    _recognizer!.dispose();
    _recognizer = null;
  }

  void _routePointer(PointerDownEvent event) {
    if (widget.maxSimultaneousDrags != null &&
        _activeCount >= widget.maxSimultaneousDrags!) return;
    _recognizer!.addPointer(event);
  }

  _BookShelfDragAvatar<T>? _startDrag(Offset position) {
    if (widget.maxSimultaneousDrags != null &&
        _activeCount >= widget.maxSimultaneousDrags!) return null;
    final Offset dragStartPoint;
    if (widget.dragAnchorStrategy == null) {
      dragStartPoint = childDragAnchorStrategy(widget, context, position);
    } else {
      dragStartPoint = widget.dragAnchorStrategy!(widget, context, position);
    }
    setState(() {
      _activeCount += 1;
    });
    final _BookShelfDragAvatar<T> avatar = _BookShelfDragAvatar<T>(
      overlayState: Overlay.of(context,
          debugRequiredFor: widget, rootOverlay: widget.rootOverlay)!,
      data: widget.data,
      axis: widget.axis,
      initialPosition: position,
      dragStartPoint: dragStartPoint,
      feedback: widget.feedback,
      feedbackOffset: widget.feedbackOffset,
      ignoringFeedbackSemantics: widget.ignoringFeedbackSemantics,
      onDragUpdate: (DragUpdateDetails details) {
        if (mounted && widget.onDragUpdate != null) {
          widget.onDragUpdate!(details);
        }
      },
      onDragEnd: (Velocity velocity, Offset offset, bool wasAccepted) {
        if (mounted) {
          setState(() {
            _activeCount -= 1;
          });
        } else {
          _activeCount -= 1;
          _disposeRecognizerIfInactive();
        }
        if (mounted && widget.onDragEnd != null) {
          widget.onDragEnd!(DraggableDetails(
            wasAccepted: wasAccepted,
            velocity: velocity,
            offset: offset,
          ));
        }
        if (wasAccepted && widget.onDragCompleted != null)
          widget.onDragCompleted!();
        if (!wasAccepted && widget.onDraggableCanceled != null)
          widget.onDraggableCanceled!(velocity, offset);
      },
    );
    widget.onDragStarted?.call();
    return avatar;
  }

  @override
  Widget build(BuildContext context) {
    assert(Overlay.of(context,
            debugRequiredFor: widget, rootOverlay: widget.rootOverlay) !=
        null);
    final bool canDrag = widget.maxSimultaneousDrags == null ||
        _activeCount < widget.maxSimultaneousDrags!;
    final bool showChild =
        _activeCount == 0 || widget.childWhenDragging == null;
    return Listener(
      behavior: widget.hitTestBehavior,
      onPointerDown: canDrag ? _routePointer : null,
      child: showChild ? widget.child : widget.childWhenDragging,
    );
  }
}

class BookShelfDragTarget<T extends Object> extends StatefulWidget {
  /// Creates a widget that receives drags.
  ///
  /// The [builder] argument must not be null.
  const BookShelfDragTarget({
    Key? key,
    required this.builder,
    this.onWillAccept,
    this.delayAcceptDuration = const Duration(milliseconds: 500),
    this.onDelayWillAccept,
    this.onAccept,
    this.onAcceptWithDetails,
    this.onLeave,
    this.onMove,
    this.hitTestBehavior = HitTestBehavior.translucent,
  }) : super(key: key);

  /// Called to build the contents of this widget.
  ///
  /// The builder can build different widgets depending on what is being dragged
  /// into this drag target.
  final DragTargetBuilder<T> builder;

  /// Called to determine whether this widget is interested in receiving a given
  /// piece of data being dragged over this drag target.
  ///
  /// Called when a piece of data enters the target. This will be followed by
  /// either [onAccept] and [onAcceptWithDetails], if the data is dropped, or
  /// [onLeave], if the drag leaves the target.
  final DragTargetWillAccept<T>? onWillAccept;

  final Duration delayAcceptDuration;
  final DragTargetWillAccept<T>? onDelayWillAccept;

  /// Called when an acceptable piece of data was dropped over this drag target.
  ///
  /// Equivalent to [onAcceptWithDetails], but only includes the data.
  final DragTargetAccept<T>? onAccept;

  /// Called when an acceptable piece of data was dropped over this drag target.
  ///
  /// Equivalent to [onAccept], but with information, including the data, in a
  /// [DragTargetDetails].
  final DragTargetAcceptWithDetails<T>? onAcceptWithDetails;

  /// Called when a given piece of data being dragged over this target leaves
  /// the target.
  final DragTargetLeave<T>? onLeave;

  /// Called when a [BookShelfDraggable] moves within this [BookShelfDragTarget].
  ///
  /// Note that this includes entering and leaving the target.
  final DragTargetMove<T>? onMove;

  /// How to behave during hit testing.
  ///
  /// Defaults to [HitTestBehavior.translucent].
  final HitTestBehavior hitTestBehavior;

  @override
  State<BookShelfDragTarget<T>> createState() => _BookShelfDragTargetState<T>();
}

List<T?> _mapAvatarsToData<T extends Object>(
    List<_BookShelfDragAvatar<Object>> avatars) {
  return avatars
      .map<T?>((_BookShelfDragAvatar<Object> avatar) => avatar.data as T?)
      .toList();
}

class _BookShelfDragTargetState<T extends Object>
    extends State<BookShelfDragTarget<T>> {
  final List<_BookShelfDragAvatar<Object>> _candidateAvatars =
      <_BookShelfDragAvatar<Object>>[];
  final List<_BookShelfDragAvatar<Object>> _rejectedAvatars =
      <_BookShelfDragAvatar<Object>>[];

  Timer? _timer;

  @override
  void didUpdateWidget(covariant BookShelfDragTarget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _timer = null;
  }

  // On non-web platforms, checks if data Object is equal to type[T] or subtype of [T].
  // On web, it does the same, but requires a check for ints and doubles
  // because dart doubles and ints are backed by the same kind of object on web.
  // JavaScript does not support integers.
  bool isExpectedDataType(Object? data, Type type) {
    if (kIsWeb &&
        ((type == int && T == double) || (type == double && T == int)))
      return false;
    return data is T?;
  }

  bool didEnter(_BookShelfDragAvatar<Object> avatar) {
    assert(!_candidateAvatars.contains(avatar));
    assert(!_rejectedAvatars.contains(avatar));

    if (widget.onWillAccept == null ||
        widget.onWillAccept!(avatar.data as T?)) {
      setState(() {
        _candidateAvatars.add(avatar);
      });

      startDelayAcceptTimer(avatar);
      return true;
    } else {
      setState(() {
        _rejectedAvatars.add(avatar);
      });
      return false;
    }
  }

  void didLeave(_BookShelfDragAvatar<Object> avatar) {
    assert(_candidateAvatars.contains(avatar) ||
        _rejectedAvatars.contains(avatar));
    if (!mounted) return;
    setState(() {
      _candidateAvatars.remove(avatar);
      _rejectedAvatars.remove(avatar);
    });
    widget.onLeave?.call(avatar.data as T?);

    releaseTimer();
  }

  void didDrop(_BookShelfDragAvatar<Object> avatar) {
    assert(_candidateAvatars.contains(avatar));
    if (!mounted) return;
    setState(() {
      _candidateAvatars.remove(avatar);
    });
    widget.onAccept?.call(avatar.data! as T);
    widget.onAcceptWithDetails?.call(DragTargetDetails<T>(
        data: avatar.data! as T, offset: avatar._lastOffset!));

    releaseTimer();
  }

  void didMove(_BookShelfDragAvatar<Object> avatar) {
    if (!mounted) return;
    widget.onMove?.call(DragTargetDetails<T>(
        data: avatar.data! as T, offset: avatar._lastOffset!));

    startDelayAcceptTimer(avatar);
  }

  void startDelayAcceptTimer(_BookShelfDragAvatar<Object> avatar) {
    _timer?.cancel();
    _timer = Timer(widget.delayAcceptDuration, () {
      _onDelayAccept(avatar);
    });
  }

  void releaseTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _onDelayAccept(_BookShelfDragAvatar<Object> avatar) {
    widget.onDelayWillAccept?.call(avatar.data as T?);
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.builder != null);
    return MetaData(
      metaData: this,
      behavior: widget.hitTestBehavior,
      child: widget.builder(context, _mapAvatarsToData<T>(_candidateAvatars),
          _mapAvatarsToData<Object>(_rejectedAvatars)),
    );
  }
}

enum _BookShelfDragEndKind { dropped, canceled }
typedef _BookShelfOnDragEnd = void Function(
    Velocity velocity, Offset offset, bool wasAccepted);

// The lifetime of this object is a little dubious right now. Specifically, it
// lives as long as the pointer is down. Arguably it should self-immolate if the
// overlay goes away. _DraggableState has some delicate logic to continue
// needing this object pointer events even after it has been disposed.
class _BookShelfDragAvatar<T extends Object> extends Drag {
  _BookShelfDragAvatar({
    required this.overlayState,
    this.data,
    this.axis,
    required Offset initialPosition,
    this.dragStartPoint = Offset.zero,
    this.feedback,
    this.feedbackOffset = Offset.zero,
    this.onDragUpdate,
    this.onDragEnd,
    required this.ignoringFeedbackSemantics,
  })  : assert(overlayState != null),
        assert(ignoringFeedbackSemantics != null),
        assert(dragStartPoint != null),
        assert(feedbackOffset != null),
        _position = initialPosition {
    _entry = OverlayEntry(builder: _build);
    overlayState.insert(_entry!);
    updateDrag(initialPosition);
  }

  final T? data;
  final Axis? axis;
  final Offset dragStartPoint;
  final Widget? feedback;
  final Offset feedbackOffset;
  final DragUpdateCallback? onDragUpdate;
  final _BookShelfOnDragEnd? onDragEnd;
  final OverlayState overlayState;
  final bool ignoringFeedbackSemantics;

  _BookShelfDragTargetState<Object>? _activeTarget;
  final List<_BookShelfDragTargetState<Object>> _enteredTargets =
      <_BookShelfDragTargetState<Object>>[];
  Offset _position;
  Offset? _lastOffset;
  OverlayEntry? _entry;

  @override
  void update(DragUpdateDetails details) {
    final Offset oldPosition = _position;
    _position += _restrictAxis(details.delta);
    updateDrag(_position);
    if (onDragUpdate != null && _position != oldPosition) {
      onDragUpdate!(details);
    }
  }

  @override
  void end(DragEndDetails details) {
    finishDrag(
        _BookShelfDragEndKind.dropped, _restrictVelocityAxis(details.velocity));
  }

  @override
  void cancel() {
    finishDrag(_BookShelfDragEndKind.canceled);
  }

  void updateDrag(Offset globalPosition) {
    _lastOffset = globalPosition - dragStartPoint;
    _entry!.markNeedsBuild();
    final HitTestResult result = HitTestResult();
    WidgetsBinding.instance!.hitTest(result, globalPosition + feedbackOffset);

    final List<_BookShelfDragTargetState<Object>> targets =
        _getDragTargets(result.path).toList();

    bool listsMatch = false;
    if (targets.length >= _enteredTargets.length &&
        _enteredTargets.isNotEmpty) {
      listsMatch = true;
      final Iterator<_BookShelfDragTargetState<Object>> iterator =
          targets.iterator;
      for (int i = 0; i < _enteredTargets.length; i += 1) {
        iterator.moveNext();
        if (iterator.current != _enteredTargets[i]) {
          listsMatch = false;
          break;
        }
      }
    }

    // If everything's the same, report moves, and bail early.
    if (listsMatch) {
      for (final _BookShelfDragTargetState<Object> target in _enteredTargets) {
        target.didMove(this);
      }
      return;
    }

    // Leave old targets.
    _leaveAllEntered();

    // Enter new targets.
    final _BookShelfDragTargetState<Object>? newTarget =
        targets.cast<_BookShelfDragTargetState<Object>?>().firstWhere(
      (_BookShelfDragTargetState<Object>? target) {
        if (target == null) return false;
        _enteredTargets.add(target);
        return target.didEnter(this);
      },
      orElse: () => null,
    );

    // Report moves to the targets.
    for (final _BookShelfDragTargetState<Object> target in _enteredTargets) {
      target.didMove(this);
    }

    _activeTarget = newTarget;
  }

  Iterable<_BookShelfDragTargetState<Object>> _getDragTargets(
      Iterable<HitTestEntry> path) sync* {
    // Look for the RenderBoxes that corresponds to the hit target (the hit target
    // widgets build RenderMetaData boxes for us for this purpose).
    for (final HitTestEntry entry in path) {
      final HitTestTarget target = entry.target;
      if (target is RenderMetaData) {
        final dynamic metaData = target.metaData;
        if (metaData is _BookShelfDragTargetState &&
            metaData.isExpectedDataType(data, T)) yield metaData;
      }
    }
  }

  void _leaveAllEntered() {
    for (int i = 0; i < _enteredTargets.length; i += 1)
      _enteredTargets[i].didLeave(this);
    _enteredTargets.clear();
  }

  void finishDrag(_BookShelfDragEndKind endKind, [Velocity? velocity]) {
    bool wasAccepted = false;
    if (endKind == _BookShelfDragEndKind.dropped && _activeTarget != null) {
      _activeTarget!.didDrop(this);
      wasAccepted = true;
      _enteredTargets.remove(_activeTarget);
    }
    _leaveAllEntered();
    _activeTarget = null;
    _entry!.remove();
    _entry = null;
    // TODO(ianh): consider passing _entry as well so the client can perform an animation.
    onDragEnd?.call(velocity ?? Velocity.zero, _lastOffset!, wasAccepted);
  }

  Widget _build(BuildContext context) {
    final RenderBox box = overlayState.context.findRenderObject()! as RenderBox;
    final Offset overlayTopLeft = box.localToGlobal(Offset.zero);
    return Positioned(
      left: _lastOffset!.dx - overlayTopLeft.dx,
      top: _lastOffset!.dy - overlayTopLeft.dy,
      child: IgnorePointer(
        ignoringSemantics: ignoringFeedbackSemantics,
        child: feedback,
      ),
    );
  }

  Velocity _restrictVelocityAxis(Velocity velocity) {
    if (axis == null) {
      return velocity;
    }
    return Velocity(
      pixelsPerSecond: _restrictAxis(velocity.pixelsPerSecond),
    );
  }

  Offset _restrictAxis(Offset offset) {
    if (axis == null) {
      return offset;
    }
    if (axis == Axis.horizontal) {
      return Offset(offset.dx, 0.0);
    }
    return Offset(0.0, offset.dy);
  }
}
