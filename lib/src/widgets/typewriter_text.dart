import 'package:flutter/material.dart';

class TypewriterText extends StatefulWidget {
  const TypewriterText({super.key, required this.text, this.speed = const Duration(milliseconds: 36), this.onComplete});
  final String text;
  final Duration speed;
  final VoidCallback? onComplete;

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.speed * widget.text.length)
      ..addListener(() {
        if (_controller.isCompleted && widget.onComplete != null) widget.onComplete!();
      })
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final count = (_controller.value * widget.text.length).floor();
        final visible = widget.text.substring(0, count.clamp(0, widget.text.length));
        return Text(
          visible,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(height: 1.4),
        );
      },
    );
  }
}
