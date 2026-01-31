import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants.dart';
import '../../utils/launch.dart';
import '../common/brand_mark.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final year = DateTime.now().year;
    final small = isMediumScreen(context);

    Widget col1() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BrandMark(textColor: Colors.white, logoHeight: 30),
            const SizedBox(height: 18),
            Text(
              'SOMA est une plateforme éducative qui met en relation les parents et des précepteurs qualifiés pour un accompagnement scolaire fiable, structuré et orienté vers la réussite des élèves.',
              style: GoogleFonts.inter(color: Colors.white.withOpacity(0.80), fontSize: 13, height: 1.7),
            ),
          ],
        );

    Widget col2() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _FooterTitle('Liens utiles'),
            const SizedBox(height: 14),
            _FooterLink('Accueil', onTap: () => Navigator.pushNamed(context, '/')),
            _FooterLink('Services', onTap: () => Navigator.pushNamed(context, '/services')),
            _FooterLink('Blog', onTap: () => Navigator.pushNamed(context, '/blog')),
            _FooterLink('À propos', onTap: () => Navigator.pushNamed(context, '/about')),
            _FooterLink('Contact', onTap: () => Navigator.pushNamed(context, '/contact')),
          ],
        );

    Widget col3() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _FooterTitle('Contact'),
            const SizedBox(height: 14),
            _ContactInfo(
              icon: Icons.email,
              text: 'contact@soma-rdc.org',
              onTap: () => launchSmart(context, 'mailto:contact@soma-rdc.org'),
            ),
            const _ContactInfo(icon: Icons.location_on, text: 'Kinshasa, République Démocratique du Congo'),
            _ContactInfo(
              icon: Icons.phone,
              text: '+243 999 867 334',
              onTap: () => launchSmart(context, 'tel:+243999867334'),
            ),
          ],
        );

    return Container(
      color: kDarkColor,
      padding: EdgeInsets.symmetric(horizontal: small ? 20 : 48, vertical: 70),
      child: Column(
        children: [
          if (small)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                col1(),
                const SizedBox(height: 26),
                col2(),
                const SizedBox(height: 26),
                col3(),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: col1()),
                const SizedBox(width: 40),
                Expanded(child: col2()),
                const SizedBox(width: 40),
                Expanded(child: col3()),
              ],
            ),
          const SizedBox(height: 40),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('© $year SOMA. Tous droits réservés.',
                  style: GoogleFonts.inter(color: Colors.white.withOpacity(0.60), fontSize: 13)),
              if (!small)
                Text('Plateforme éducative', style: GoogleFonts.inter(color: Colors.white.withOpacity(0.60), fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}

class _FooterTitle extends StatelessWidget {
  final String text;
  const _FooterTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900));
  }
}

class _FooterLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _FooterLink(this.text, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
        child: Text(text, style: GoogleFonts.inter(color: Colors.white.withOpacity(0.80), fontSize: 13)),
      ),
    );
  }
}

class _ContactInfo extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;
  const _ContactInfo({required this.icon, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: Colors.white.withOpacity(0.80)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(text, style: GoogleFonts.inter(color: Colors.white.withOpacity(0.80), fontSize: 13, height: 1.5)),
            ),
          ],
        ),
      ),
    );
  }
}
