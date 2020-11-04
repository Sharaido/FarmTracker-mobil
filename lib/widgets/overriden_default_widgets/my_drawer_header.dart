import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/pages/user_profile.dart';

const double _kDrawerHeaderHeight = 155.0 + 1.0; // bottom edge

class MyDrawerHeader extends StatelessWidget {
  const MyDrawerHeader({
    Key key,
    this.decoration,
    this.margin = const EdgeInsets.only(bottom: 0.0),
    this.padding =
        const EdgeInsets.fromLTRB(16.0, 3.0, 16.0, 8.0), // 16,16,16,8
    this.duration = const Duration(milliseconds: 250),
    this.curve = Curves.fastOutSlowIn,
    @required this.child,
  }) : super(key: key);

  final Decoration decoration;

  final EdgeInsetsGeometry padding;

  final EdgeInsetsGeometry margin;

  final Duration duration;

  final Curve curve;

  final Widget child;
  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMediaQuery(context));
    final ThemeData theme = Theme.of(context);
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      height: statusBarHeight + _kDrawerHeaderHeight,
      margin: margin,
      decoration: BoxDecoration(
        border: Border(
            //bottom: Divider.createBorderSide(context),
            ),
      ),
      child: AnimatedContainer(
        padding: padding.add(EdgeInsets.only(top: statusBarHeight)),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.7),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 6), // changes position of shadow
              ),
            ],
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50))),
        duration: duration,
        curve: curve,
        child: child == null
            ? null
            : DefaultTextStyle(
                style: theme.textTheme.bodyText1,
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: child,
                ),
              ),
      ),
    );
  }
}
