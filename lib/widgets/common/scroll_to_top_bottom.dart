import 'package:flutter/material.dart';
import '../../core/constants.dart';

class ScrollToTopBottom extends StatefulWidget {
  const ScrollToTopBottom({
    super.key,
    required this.controller,
    this.right = 16,
    this.bottom = 16,
    this.gap = 10,
  });

  final ScrollController controller;
  final double right;
  final double bottom;
  final double gap;

  @override
  State<ScrollToTopBottom> createState() => _ScrollToTopBottomState();
}

class _ScrollToTopBottomState extends State<ScrollToTopBottom> {
  bool _showTop = false;
  bool _showBottom = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_refresh);
    WidgetsBinding.instance.addPostFrameCallback((_) => _refresh());
  }

  @override
  void dispose() {
    widget.controller.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (!mounted) return;
    if (!widget.controller.hasClients) return;

    final pos = widget.controller.position;
    final offset = pos.pixels;
    final max = pos.maxScrollExtent;

    final showTop = offset > 220;
    final showBottom = max > 220 && (max - offset) > 220;

    if (showTop != _showTop || showBottom != _showBottom) {
      setState(() {
        _showTop = showTop;
        _showBottom = showBottom;
      });
    }
  }

  Future<void> _goTop() async {
    if (!widget.controller.hasClients) return;
    await widget.controller.animateTo(
      0,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _goBottom() async {
    if (!widget.controller.hasClients) return;
    await widget.controller.animateTo(
      widget.controller.position.maxScrollExtent,
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: widget.right,
      bottom: widget.bottom,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ScrollFab(
            visible: _showTop,
            tooltip: 'Aller en haut',
            icon: Icons.keyboard_arrow_up_rounded,
            onTap: _goTop,
          ),
          SizedBox(height: widget.gap),
          _ScrollFab(
            visible: _showBottom,
            tooltip: 'Aller en bas',
            icon: Icons.keyboard_arrow_down_rounded,
            onTap: _goBottom,
          ),
        ],
      ),
    );
  }
}

class _ScrollFab extends StatelessWidget {
  const _ScrollFab({
    required this.visible,
    required this.tooltip,
    required this.icon,
    required this.onTap,
  });

  final bool visible;
  final String tooltip;
  final IconData icon;
  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: const Duration(milliseconds: 160),
      child: IgnorePointer(
        ignoring: !visible,
        child: Tooltip(
          message: tooltip,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => onTap(),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: kDarkColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.14), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.18),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
