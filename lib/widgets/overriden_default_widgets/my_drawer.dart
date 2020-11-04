import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum DrawerAlignment {
  start,
  end,
}

const double _kWidth = 240.0; //304
const double _kEdgeDragWidth = 20.0;
const double _kMinFlingVelocity = 365.0;
const Duration _kBaseSettleDuration = Duration(milliseconds: 246);

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key key,
    this.elevation = 16.0,
    this.child,
    this.semanticLabel,
  })  : assert(elevation != null && elevation >= 0.0),
        super(key: key);

  final double elevation;

  final Widget child;

  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    String label = semanticLabel;
    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        label = semanticLabel;
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        label = semanticLabel ?? MaterialLocalizations.of(context)?.drawerLabel;
    }
    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: label,
      child: ConstrainedBox(
        constraints: const BoxConstraints.expand(width: _kWidth),
        child: Material(
          color: Colors.grey[200],
          elevation: elevation,
          child: child,
        ),
      ),
    );
  }
}

typedef DrawerCallback = void Function(bool isOpened);

class DrawerController extends StatefulWidget {
  const DrawerController({
    GlobalKey key,
    @required this.child,
    @required this.alignment,
    this.drawerCallback,
    this.dragStartBehavior = DragStartBehavior.start,
    this.scrimColor,
    this.edgeDragWidth,
    this.enableOpenDragGesture = true,
  })  : assert(child != null),
        assert(dragStartBehavior != null),
        assert(alignment != null),
        super(key: key);

  final Widget child;

  final DrawerAlignment alignment;

  final DrawerCallback drawerCallback;

  final DragStartBehavior dragStartBehavior;

  final Color scrimColor;

  final bool enableOpenDragGesture;

  final double edgeDragWidth;

  @override
  DrawerControllerState createState() => DrawerControllerState();
}

class DrawerControllerState extends State<DrawerController> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _scrimColorTween = _buildScrimColorTween();
    _controller = AnimationController(duration: _kBaseSettleDuration, vsync: this)
      ..addListener(_animationChanged)
      ..addStatusListener(_animationStatusChanged);
  }

  @override
  void dispose() {
    _historyEntry?.remove();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(DrawerController oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scrimColor != oldWidget.scrimColor) _scrimColorTween = _buildScrimColorTween();
  }

  void _animationChanged() {
    setState(() {});
  }

  LocalHistoryEntry _historyEntry;
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  void _ensureHistoryEntry() {
    if (_historyEntry == null) {
      final ModalRoute<dynamic> route = ModalRoute.of(context);
      if (route != null) {
        _historyEntry = LocalHistoryEntry(onRemove: _handleHistoryEntryRemoved);
        route.addLocalHistoryEntry(_historyEntry);
        FocusScope.of(context).setFirstFocus(_focusScopeNode);
      }
    }
  }

  void _animationStatusChanged(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.forward:
        _ensureHistoryEntry();
        break;
      case AnimationStatus.reverse:
        _historyEntry?.remove();
        _historyEntry = null;
        break;
      case AnimationStatus.dismissed:
        break;
      case AnimationStatus.completed:
        break;
    }
  }

  void _handleHistoryEntryRemoved() {
    _historyEntry = null;
    close();
  }

  AnimationController _controller;

  void _handleDragDown(DragDownDetails details) {
    _controller.stop();
    _ensureHistoryEntry();
  }

  void _handleDragCancel() {
    if (_controller.isDismissed || _controller.isAnimating) return;
    if (_controller.value < 0.5) {
      close();
    } else {
      open();
    }
  }

  final GlobalKey _drawerKey = GlobalKey();

  double get _width {
    final RenderBox box = _drawerKey.currentContext?.findRenderObject() as RenderBox;
    if (box != null) return box.size.width;
    return _kWidth; // drawer not being shown currently
  }

  bool _previouslyOpened = false;

  void _move(DragUpdateDetails details) {
    double delta = details.primaryDelta / _width;
    switch (widget.alignment) {
      case DrawerAlignment.start:
        break;
      case DrawerAlignment.end:
        delta = -delta;
        break;
    }
    switch (Directionality.of(context)) {
      case TextDirection.rtl:
        _controller.value -= delta;
        break;
      case TextDirection.ltr:
        _controller.value += delta;
        break;
    }

    final bool opened = _controller.value > 0.5;
    if (opened != _previouslyOpened && widget.drawerCallback != null) widget.drawerCallback(opened);
    _previouslyOpened = opened;
  }

  void _settle(DragEndDetails details) {
    if (_controller.isDismissed) return;
    if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx / _width;
      switch (widget.alignment) {
        case DrawerAlignment.start:
          break;
        case DrawerAlignment.end:
          visualVelocity = -visualVelocity;
          break;
      }
      switch (Directionality.of(context)) {
        case TextDirection.rtl:
          _controller.fling(velocity: -visualVelocity);
          if (widget.drawerCallback != null) widget.drawerCallback(visualVelocity < 0.0);
          break;
        case TextDirection.ltr:
          _controller.fling(velocity: visualVelocity);
          if (widget.drawerCallback != null) widget.drawerCallback(visualVelocity > 0.0);
          break;
      }
    } else if (_controller.value < 0.5) {
      close();
    } else {
      open();
    }
  }

  void open() {
    _controller.fling(velocity: 1.0);
    if (widget.drawerCallback != null) widget.drawerCallback(true);
  }

  void close() {
    _controller.fling(velocity: -1.0);
    if (widget.drawerCallback != null) widget.drawerCallback(false);
  }

  ColorTween _scrimColorTween;
  final GlobalKey _gestureDetectorKey = GlobalKey();

  ColorTween _buildScrimColorTween() {
    return ColorTween(begin: Colors.transparent, end: widget.scrimColor ?? Colors.black54);
  }

  AlignmentDirectional get _drawerOuterAlignment {
    assert(widget.alignment != null);
    switch (widget.alignment) {
      case DrawerAlignment.start:
        return AlignmentDirectional.centerStart;
      case DrawerAlignment.end:
        return AlignmentDirectional.centerEnd;
    }
    return null;
  }

  AlignmentDirectional get _drawerInnerAlignment {
    assert(widget.alignment != null);
    switch (widget.alignment) {
      case DrawerAlignment.start:
        return AlignmentDirectional.centerEnd;
      case DrawerAlignment.end:
        return AlignmentDirectional.centerStart;
    }
    return null;
  }

  Widget _buildDrawer(BuildContext context) {
    final bool drawerIsStart = widget.alignment == DrawerAlignment.start;
    final EdgeInsets padding = MediaQuery.of(context).padding;
    final TextDirection textDirection = Directionality.of(context);

    double dragAreaWidth = widget.edgeDragWidth;
    if (widget.edgeDragWidth == null) {
      switch (textDirection) {
        case TextDirection.ltr:
          dragAreaWidth = _kEdgeDragWidth + (drawerIsStart ? padding.left : padding.right);
          break;
        case TextDirection.rtl:
          dragAreaWidth = _kEdgeDragWidth + (drawerIsStart ? padding.right : padding.left);
          break;
      }
    }

    if (_controller.status == AnimationStatus.dismissed) {
      if (widget.enableOpenDragGesture) {
        return Align(
          alignment: _drawerOuterAlignment,
          child: GestureDetector(
            key: _gestureDetectorKey,
            onHorizontalDragUpdate: _move,
            onHorizontalDragEnd: _settle,
            behavior: HitTestBehavior.translucent,
            excludeFromSemantics: true,
            dragStartBehavior: widget.dragStartBehavior,
            child: Container(width: dragAreaWidth),
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    } else {
      bool platformHasBackButton;
      switch (Theme.of(context).platform) {
        case TargetPlatform.android:
          platformHasBackButton = true;
          break;
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          platformHasBackButton = false;
          break;
      }
      assert(platformHasBackButton != null);
      return GestureDetector(
        key: _gestureDetectorKey,
        onHorizontalDragDown: _handleDragDown,
        onHorizontalDragUpdate: _move,
        onHorizontalDragEnd: _settle,
        onHorizontalDragCancel: _handleDragCancel,
        excludeFromSemantics: true,
        dragStartBehavior: widget.dragStartBehavior,
        child: RepaintBoundary(
          child: Stack(
            children: <Widget>[
              BlockSemantics(
                child: ExcludeSemantics(
                  // On Android, the back button is used to dismiss a modal.
                  excluding: platformHasBackButton,
                  child: GestureDetector(
                    onTap: close,
                    child: Semantics(
                      label: MaterialLocalizations.of(context)?.modalBarrierDismissLabel,
                      child: MouseRegion(
                        opaque: true,
                        child: Container(
                          // The drawer's "scrim"
                          color: _scrimColorTween.evaluate(_controller),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: _drawerOuterAlignment,
                child: Align(
                  alignment: _drawerInnerAlignment,
                  widthFactor: _controller.value,
                  child: RepaintBoundary(
                    child: FocusScope(
                      key: _drawerKey,
                      node: _focusScopeNode,
                      child: widget.child,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    return ListTileTheme(
      style: ListTileStyle.drawer,
      child: _buildDrawer(context),
    );
  }
}
