import 'package:flutter/material.dart';
import '../../core/constants.dart';

class SectionBase extends StatelessWidget {
  final Widget child;
  final Color? background;

  const SectionBase({super.key, required this.child, this.background});

  @override
  Widget build(BuildContext context) {
    final small = isMediumScreen(context);
    return Container(
      color: background,
      padding: EdgeInsets.symmetric(horizontal: small ? 20 : 48, vertical: 80),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: child,
        ),
      ),
    );
  }
}
