import 'package:flutter/material.dart';

class HoverCard extends StatefulWidget {
  final Widget child;

  const HoverCard({required this.child});

  @override
  _HoverCardState createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        transform: _hover ? Matrix4.translationValues(0, -5, 0) : Matrix4.identity(),
        child: widget.child,
      ),
    );
  }
}
