import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../widgets/common/brand_mark.dart';
import '../widgets/nav/top_nav_link.dart';
import '../widgets/nav/nav_sheet.dart';
import '../widgets/common/buttons.dart';

import '../widgets/home/hero_section.dart';
import '../widgets/home/about_section.dart';
import '../widgets/home/services_section.dart';
import '../widgets/home/why_section.dart';
import '../widgets/home/team_section.dart';
import '../widgets/home/testimonials_section.dart';
import '../widgets/home/cta_section.dart';
import '../widgets/home/footer_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  bool _showTop = false;
  bool _showBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_refreshFabVisibility);
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshFabVisibility());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_refreshFabVisibility);
    _scrollController.dispose();
    super.dispose();
  }

  void _refreshFabVisibility() {
    if (!mounted) return;
    if (!_scrollController.hasClients) return;

    final pos = _scrollController.position;
    final offset = pos.pixels;
    final max = pos.maxScrollExtent;

    final showTop = offset > 260;
    final showBottom = max > 260 && (max - offset) > 260;

    if (showTop != _showTop || showBottom != _showBottom) {
      setState(() {
        _showTop = showTop;
        _showBottom = showBottom;
      });
    }
  }

  void _goTop() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    );
  }

  void _goBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final small = isSmallScreen(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kDarkColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const BrandMark(textColor: Colors.white, logoHeight: 28),
        actions: [
          if (!small) ...[
            TopNavLink(
              label: 'Services',
              onTap: () => Navigator.pushNamed(context, '/services'),
            ),
            TopNavLink(
              label: 'Blog',
              onTap: () => Navigator.pushNamed(context, '/blog'),
            ),
            TopNavLink(
              label: 'À propos',
              onTap: () => Navigator.pushNamed(context, '/about'),
            ),
            TopNavLink(
              label: 'Contact',
              onTap: () => Navigator.pushNamed(context, '/contact'),
            ),
            const SizedBox(width: 10),

            // ✅ Devenir précepteur (bien visible)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
              child: GhostButton(
                label: 'Devenir précepteur',
                icon: Icons.person_add_alt_1_rounded,
                onPressed: () => Navigator.pushNamed(context, '/devenir-precepteur'),
              ),
            ),

            // ✅ Trouver un précepteur (CTA)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: CtaButton(
                label: 'Trouver un précepteur',
                icon: Icons.search_rounded,
                onPressed: () => Navigator.pushNamed(context, '/nos-precepteurs'),
              ),
            ),
            const SizedBox(width: 8),
          ] else ...[
            // ✅ Mobile: rendre "Devenir précepteur" visible même sans ouvrir le menu
            IconButton(
              tooltip: 'Devenir précepteur',
              icon: const Icon(Icons.person_add_alt_1_rounded),
              onPressed: () => Navigator.pushNamed(context, '/devenir-precepteur'),
            ),
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => NavSheet.open(context),
              tooltip: 'Menu',
            ),
          ],
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: const Column(
              children: [
                HeroSection(),
                AboutSection(),
                ServicesHomeSection(),
                WhySection(),
                TeamSection(),
                TestimonialsSection(),
                CtaSection(),
                FooterSection(),
              ],
            ),
          ),

          // ✅ Boutons haut / bas (Home aussi)
          Positioned(
            right: 16,
            bottom: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ScrollFab(
                  visible: _showTop,
                  tooltip: 'Aller en haut',
                  icon: Icons.keyboard_arrow_up_rounded,
                  onPressed: _goTop,
                ),
                const SizedBox(height: 10),
                _ScrollFab(
                  visible: _showBottom,
                  tooltip: 'Aller en bas',
                  icon: Icons.keyboard_arrow_down_rounded,
                  onPressed: _goBottom,
                ),
              ],
            ),
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
    required this.onPressed,
  });

  final bool visible;
  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

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
              onTap: onPressed,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: kDarkColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.12), width: 1),
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
