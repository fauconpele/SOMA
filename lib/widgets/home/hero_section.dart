import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import '../../core/constants.dart';
import '../common/buttons.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  late final VideoPlayerController _video;
  late final Future<void> _init;

  @override
  void initState() {
    super.initState();
    _video = VideoPlayerController.asset(kHeroVideoAsset);
    _init = _video.initialize().then((_) {
      _video
        ..setLooping(true)
        ..setVolume(0)
        ..play();
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _video.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final small = isSmallScreen(context);

    return SizedBox(
      height: size.height * 0.80,
      child: Stack(
        children: [
          Positioned.fill(
            child: FutureBuilder(
              future: _init,
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done || !_video.value.isInitialized) {
                  return Container(color: kDarkColor);
                }
                final vSize = _video.value.size;
                return FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: vSize.width,
                    height: vSize.height,
                    child: VideoPlayer(_video),
                  ),
                );
              },
            ),
          ),
          Positioned.fill(child: Container(color: Colors.black.withOpacity(0.40))),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [kDarkColor.withOpacity(0.65), kDarkColor.withOpacity(0.25)],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: small ? 22 : 48, vertical: small ? 40 : 80),
              width: small ? size.width : size.width * 0.62,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Plateforme éducative de confiance en RDC',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                        fontSize: small ? 14 : 18,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Parents, trouvez des précepteurs qualifiés.',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        height: 1.05,
                        fontWeight: FontWeight.w900,
                        fontSize: small ? 34 : 60,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'SOMA met en relation les parents et des précepteurs compétents pour un accompagnement scolaire personnalisé, sécurisé et orienté vers la réussite des élèves.',
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.92),
                        fontSize: small ? 15 : 19,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 26),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        CtaButton(
                          label: 'Trouver un précepteur',
                          onPressed: () => Navigator.pushNamed(context, '/nos-precepteurs'),
                        ),
                        GhostButton(
                          label: 'Découvrir nos services',
                          onPressed: () => Navigator.pushNamed(context, '/services'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
