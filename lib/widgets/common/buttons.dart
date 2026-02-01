import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants.dart';

/// ✅ Bouton principal (CTA) — très visible
class CtaButton extends StatelessWidget {
  const CtaButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
    this.foregroundColor = Colors.white,
    this.fullWidth = false,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  final Color? backgroundColor;
  final Color foregroundColor;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? kSecondaryColor;

    final btn = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: foregroundColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 14),
      ).copyWith(
        overlayColor: WidgetStateProperty.all(Colors.white.withOpacity(0.10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );

    if (!fullWidth) return btn;

    return SizedBox(width: double.infinity, child: btn);
  }
}

/// ✅ Bouton secondaire (Ghost) — maintenant TRÈS visible
/// Utilisé pour "Devenir précepteur"
class GhostButton extends StatelessWidget {
  const GhostButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.fullWidth = false,
    this.color,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  final bool fullWidth;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? kSecondaryColor;

    final btn = OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: c,
        backgroundColor: Colors.white, // ✅ rend le bouton visible
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        side: BorderSide(
          color: c.withOpacity(0.75), // ✅ bordure plus “présente”
          width: 2,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 14),
      ).copyWith(
        overlayColor: WidgetStateProperty.all(c.withOpacity(0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );

    if (!fullWidth) return btn;
    return SizedBox(width: double.infinity, child: btn);
  }
}
