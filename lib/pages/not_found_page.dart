import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants.dart';
import '../widgets/common/simple_page_scaffold.dart';
import '../widgets/common/buttons.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SimplePageScaffold(
      title: 'Page introuvable',
      subtitle: 'Cette adresse n’existe pas (ou a été déplacée).',
      showBack: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _NotFoundBanner(),
          const SizedBox(height: 18),

          Text(
            'Quelques pistes :',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: kDarkColor,
            ),
          ),
          const SizedBox(height: 10),

          _Bullet(text: 'Vérifie le lien (une faute de frappe arrive vite).'),
          _Bullet(text: 'Essaie de revenir à l’accueil puis navigue depuis le menu.'),
          _Bullet(text: 'Si le problème persiste, contacte-nous et on t’aide.'),

          const SizedBox(height: 22),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              CtaButton(
                label: 'Aller à l’accueil',
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false);
                },
              ),
              GhostButton(
                label: 'Nous contacter',
                onPressed: () => Navigator.pushNamed(context, '/contact'),
              ),
              GhostButton(
                label: 'Devenir précepteur',
                onPressed: () => Navigator.pushNamed(context, '/devenir-precepteur'),
              ),
            ],
          ),

          const SizedBox(height: 18),

          TextButton.icon(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back),
            label: Text(
              'Retour',
              style: GoogleFonts.inter(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotFoundBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            kPrimaryColor.withOpacity(0.12),
            kSecondaryColor.withOpacity(0.10),
          ],
        ),
        border: Border.all(color: kPrimaryColor.withOpacity(0.18), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: kAccentColor.withOpacity(0.14),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: kAccentColor.withOpacity(0.35), width: 1),
            ),
            child: const Icon(Icons.search_off_rounded, color: kAccentColor, size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '404 — Page introuvable',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: kDarkColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Pas de panique : on te ramène vers une page utile.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: kTextLight,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_rounded, size: 18, color: kSecondaryColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: kTextDark,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
