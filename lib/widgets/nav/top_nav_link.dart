import 'package:flutter/material.dart';
import '../../core/constants.dart';

class TopNavLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  /// Optionnel : si fourni, le lien se met en "actif" automatiquement
  /// quand la route courante = routeName.
  final String? routeName;

  /// Optionnel : icône à gauche du texte.
  final IconData? icon;

  /// Optionnel : forcer l’état actif sans routeName.
  final bool? isActive;

  const TopNavLink({
    super.key,
    required this.label,
    required this.onTap,
    this.routeName,
    this.icon,
    this.isActive,
  });

  @override
  State<TopNavLink> createState() => _TopNavLinkState();
}

class _TopNavLinkState extends State<TopNavLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final current = ModalRoute.of(context)?.settings.name;
    final active = widget.isActive ?? (widget.routeName != null && widget.routeName == current);

    final fg = active ? Colors.white : Colors.white.withOpacity(0.92);
    final bg = active
        ? kSecondaryColor.withOpacity(0.22)
        : (_hover ? Colors.white.withOpacity(0.10) : Colors.transparent);

    final border = active ? kSecondaryColor.withOpacity(0.45) : Colors.white.withOpacity(0.08);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: border, width: 1),
              boxShadow: active
                  ? [
                      BoxShadow(
                        color: kSecondaryColor.withOpacity(0.18),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ]
                  : const [],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, size: 18, color: fg),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      widget.label,
                      style: TextStyle(
                        color: fg,
                        fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  curve: Curves.easeOut,
                  height: 3,
                  width: active ? 22 : (_hover ? 12 : 0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(active ? 0.95 : 0.75),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
