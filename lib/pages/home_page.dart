// lib/pages/home_page.dart
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
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshFabVisibility());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() => _refreshFabVisibility();

  void _refreshFabVisibility() {
    if (!mounted) return;
    if (!_scrollController.hasClients) return;

    final pos = _scrollController.position;
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
    if (!_scrollController.hasClients) return;
    await _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _goBottom() async {
    if (!_scrollController.hasClients) return;
    await _scrollController.animateTo(
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
            const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              child: CtaButton(
                label: 'Trouver un précepteur',
                onPressed: () => Navigator.pushNamed(context, '/nos-precepteurs'),
              ),
            ),
            const SizedBox(width: 8),
          ] else ...[
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => NavSheet.open(context),
              tooltip: 'Menu',
            ),
          ],
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Scrollbar(
              controller: _scrollController,
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
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
                    SizedBox(height: 80), // espace pour ne pas gêner les boutons flottants
                  ],
                ),
              ),
            ),

            // ✅ Boutons "Haut" / "Bas" pour la page d'accueil aussi
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
  final Future<void> Function() onPressed;

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
              onTap: () => onPressed(),
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
