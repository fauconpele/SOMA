import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';

// ====== CONSTANTES SOMA ======
const kBrandName = 'SOMA';
const kLogoAsset = 'assets/images/logo_soma.png';
const kLogoWhiteAsset = 'assets/images/logo_soma_white.png';
const kHeroVideoAsset = 'assets/videos/hero_bg.mp4';

// ====== COULEURS SOMA ======
const kPrimaryColor = Color(0xFF4A6FA5); // Bleu SOMA
const kSecondaryColor = Color(0xFF6ECB63); // Vert succès
const kAccentColor = Color(0xFFFFC107); // Jaune accent
const kDarkColor = Color(0xFF1A1F37); // Fond sombre
const kLightColor = Color(0xFFF8F9FA); // Fond clair
const kTextDark = Color(0xFF333333);
const kTextLight = Color(0xFF666666);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SomaApp());
}

// ====== APPLICATION SOMA ======
class SomaApp extends StatelessWidget {
  const SomaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData.light();
    final theme = base.copyWith(
      textTheme: GoogleFonts.interTextTheme(base.textTheme),
      scaffoldBackgroundColor: kLightColor,
      colorScheme: base.colorScheme.copyWith(
        primary: kPrimaryColor,
        secondary: kSecondaryColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: kDarkColor,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kSecondaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: kPrimaryColor),
          foregroundColor: kPrimaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      // Personnalisation de la barre de défilement
      scrollbarTheme: ScrollbarThemeData(
        thickness: MaterialStateProperty.all(8.0),
        thumbVisibility: MaterialStateProperty.all(true),
        thumbColor: MaterialStateProperty.all(kPrimaryColor.withOpacity(0.6)),
        trackColor: MaterialStateProperty.all(kPrimaryColor.withOpacity(0.1)),
        radius: const Radius.circular(4),
        minThumbLength: 50,
        interactive: true,
        crossAxisMargin: 2,
        mainAxisMargin: 2,
      ),
    );

    return MaterialApp(
      title: kBrandName,
      debugShowCheckedModeBanner: false,
      theme: theme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SomaLandingPage(),
        '/services': (context) => const ServicesPage(),
        '/blog': (context) => const BlogPage(),
        '/about': (context) => const AboutPage(),
        '/contact': (context) => const ContactPage(),
      },
    );
  }
}

// ====== PAGE PRINCIPALE SOMA ======
class SomaLandingPage extends StatelessWidget {
  const SomaLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kDarkColor,
        elevation: 0,
        title: const _BrandMark(textColor: Colors.white, logoHeight: 28),
        actions: [
          // Boutons de navigation pour desktop
          if (MediaQuery.of(context).size.width > 900) ...[
            TextButton(
              onPressed: () {
                // Navigation vers la page Services
                Navigator.pushNamed(context, '/services');
              },
              child: const Text(
                'Services',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            TextButton(
              onPressed: () {
                // Navigation vers la page Blog
                Navigator.pushNamed(context, '/blog');
              },
              child: const Text(
                'Blog',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            TextButton(
              onPressed: () {
                // Navigation vers la page À propos
                Navigator.pushNamed(context, '/about');
              },
              child: const Text(
                'À propos',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            TextButton(
              onPressed: () {
                // Navigation vers la page Contact
                Navigator.pushNamed(context, '/contact');
              },
              child: const Text(
                'Contact',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 24),
            _GhostButton(
              label: 'Trouver un précepteur',
              onPressed: () {
                // Ouvrir un formulaire pour trouver un précepteur
                _showFindTutorModal(context);
              },
            ),
            const SizedBox(width: 12),
            _CtaButton(
              label: 'Devenir précepteur',
              onPressed: () {
                // Ouvrir un formulaire pour devenir précepteur
                _showBecomeTutorModal(context);
              },
            ),
            const SizedBox(width: 24),
          ] else ...[
            // Menu burger pour mobile
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => _showNavSheet(context),
            ),
          ],
        ],
      ),
      body: ClipRect(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: kDarkColor,
              ),
            ),
            const _PageContent(),
          ],
        ),
      ),
    );
  }

  // Fonction pour ouvrir le modal "Trouver un précepteur"
  void _showFindTutorModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _TutorModal(
        title: 'Trouver un précepteur',
        description: 'Remplissez ce formulaire pour trouver le précepteur idéal pour votre enfant.',
        submitText: 'Rechercher',
        onSubmit: () {
          // Logique pour rechercher un précepteur
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Recherche de précepteur lancée !'),
              backgroundColor: kSecondaryColor,
              duration: Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }

  // Fonction pour ouvrir le modal "Devenir précepteur"
  void _showBecomeTutorModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _TutorModal(
        title: 'Devenir précepteur',
        description: 'Rejoignez notre plateforme et aidez les élèves à réussir.',
        submitText: 'Postuler',
        onSubmit: () {
          // Logique pour postuler comme précepteur
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Candidature envoyée avec succès !'),
              backgroundColor: kSecondaryColor,
              duration: Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }
}

// Modal réutilisable pour les formulaires
class _TutorModal extends StatefulWidget {
  final String title;
  final String description;
  final String submitText;
  final VoidCallback onSubmit;

  const _TutorModal({
    required this.title,
    required this.description,
    required this.submitText,
    required this.onSubmit,
  });

  @override
  State<_TutorModal> createState() => _TutorModalState();
}

class _TutorModalState extends State<_TutorModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: kDarkColor,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: kTextLight),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.description,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: kTextLight,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nom complet',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: Icon(Icons.person, color: kPrimaryColor),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre nom';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: Icon(Icons.email, color: kPrimaryColor),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre email';
                    }
                    if (!value.contains('@')) {
                      return 'Email invalide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Téléphone',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: Icon(Icons.phone, color: kPrimaryColor),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    labelText: 'Message',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: Icon(Icons.message, color: kPrimaryColor),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: kPrimaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Annuler',
                          style: GoogleFonts.inter(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            widget.onSubmit();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kSecondaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          widget.submitText,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ====== CONTENU PRINCIPAL ======
class _PageContent extends StatefulWidget {
  const _PageContent();

  @override
  State<_PageContent> createState() => _PageContentState();
}

class _PageContentState extends State<_PageContent> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;
  bool _showScrollToBottom = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    final double currentPosition = _scrollController.position.pixels;
    final double maxPosition = _scrollController.position.maxScrollExtent;

    setState(() {
      _showScrollToTop = currentPosition > 300;
      _showScrollToBottom = currentPosition < maxPosition - 300;
    });
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Wrapper avec Scrollbar personnalisée
        Positioned.fill(
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            trackVisibility: true,
            thickness: 10,
            radius: const Radius.circular(5),
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  _HeroSection(),
                  SizedBox(height: 80),
                  _AboutSection(),
                  SizedBox(height: 80),
                  _ServicesSection(),
                  SizedBox(height: 80),
                  _WhySection(),
                  SizedBox(height: 80),
                  _TeamSection(),
                  SizedBox(height: 80),
                  _TestimonialsSection(),
                  SizedBox(height: 80),
                  _CtaSection(),
                  SizedBox(height: 80),
                  _FooterSection(),
                ],
              ),
            ),
          ),
        ),
        if (_showScrollToTop)
          Positioned(
            bottom: 20,
            right: 20,
            child: _ScrollButton(
              icon: Icons.arrow_upward,
              onPressed: _scrollToTop,
              tooltip: 'Retour en haut',
            ),
          ),
        if (_showScrollToBottom)
          Positioned(
            bottom: 80,
            right: 20,
            child: _ScrollButton(
              icon: Icons.arrow_downward,
              onPressed: _scrollToBottom,
              tooltip: 'Aller en bas',
            ),
          ),
      ],
    );
  }
}

class _ScrollButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;

  const _ScrollButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      backgroundColor: Colors.white.withOpacity(0.9),
      foregroundColor: kDarkColor,
      onPressed: onPressed,
      tooltip: tooltip,
      child: Icon(icon),
    );
  }
}

// ====== BARRE DE NAVIGATION ======
class _BrandMark extends StatelessWidget {
  const _BrandMark({this.textColor = Colors.white, this.logoHeight = 24});
  final Color textColor;
  final double logoHeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          kLogoWhiteAsset,
          height: logoHeight,
          errorBuilder: (_, __, ___) => 
            Icon(Icons.school, color: textColor, size: logoHeight),
        ),
        const SizedBox(width: 12),
        Text(
          kBrandName,
          style: GoogleFonts.inter(
            color: textColor,
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
      ],
    );
  }
}

void _showNavSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: kDarkColor,
    showDragHandle: true,
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              _SheetItem(
                'Accueil',
                onTap: () {
                  Navigator.of(ctx).pop();
                  if (ModalRoute.of(ctx)?.settings.name != '/') {
                    Navigator.pushNamed(ctx, '/');
                  }
                },
              ),
              _SheetItem(
                'Services',
                onTap: () {
                  Navigator.of(ctx).pop();
                  Navigator.pushNamed(ctx, '/services');
                },
              ),
              _SheetItem(
                'Blog',
                onTap: () {
                  Navigator.of(ctx).pop();
                  Navigator.pushNamed(ctx, '/blog');
                },
              ),
              _SheetItem(
                'À propos',
                onTap: () {
                  Navigator.of(ctx).pop();
                  Navigator.pushNamed(ctx, '/about');
                },
              ),
              _SheetItem(
                'Contact',
                onTap: () {
                  Navigator.of(ctx).pop();
                  Navigator.pushNamed(ctx, '/contact');
                },
              ),
              _SheetItem(
                'Trouver un précepteur',
                onTap: () {
                  Navigator.of(ctx).pop();
                  // Ouvrir le modal pour trouver un précepteur
                  showDialog(
                    context: ctx,
                    builder: (context) => _TutorModal(
                      title: 'Trouver un précepteur',
                      description: 'Remplissez ce formulaire pour trouver le précepteur idéal pour votre enfant.',
                      submitText: 'Rechercher',
                      onSubmit: () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Recherche de précepteur lancée !'),
                            backgroundColor: kSecondaryColor,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              _SheetItem(
                'Devenir précepteur',
                onTap: () {
                  Navigator.of(ctx).pop();
                  // Ouvrir le modal pour devenir précepteur
                  showDialog(
                    context: ctx,
                    builder: (context) => _TutorModal(
                      title: 'Devenir précepteur',
                      description: 'Rejoignez notre plateforme et aidez les élèves à réussir.',
                      submitText: 'Postuler',
                      onSubmit: () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Candidature envoyée avec succès !'),
                            backgroundColor: kSecondaryColor,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              const Divider(color: Colors.white24),
              const SizedBox(height: 24),
              _CtaButton(
                label: 'Nous contacter',
                onPressed: () {
                  Navigator.of(ctx).pop();
                  _launch('mailto:contact@soma-rdc.org');
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _SheetItem extends StatelessWidget {
  const _SheetItem(this.label, {this.onTap});
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      onTap: () {
        Navigator.of(context).pop();
        if (onTap != null) onTap!();
      },
    );
  }
}

class _CtaButton extends StatelessWidget {
  const _CtaButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: kSecondaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

class _GhostButton extends StatelessWidget {
  const _GhostButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;
  
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.white70),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

// ====== SECTION HERO ======
class _HeroSection extends StatefulWidget {
  const _HeroSection();

  @override
  State<_HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<_HeroSection> {
  late VideoPlayerController _videoController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset(kHeroVideoAsset);
    _initializeVideoPlayerFuture = _videoController.initialize();
    _videoController.setLooping(true);
    _videoController.setVolume(0);
    _videoController.play();
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 900;

    return SizedBox(
      height: size.height * 0.8,
      child: Stack(
        children: [
          // VIDÉO DE FOND - Version agrandie à 120%
          Positioned.fill(
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Stack(
                    children: [
                      // Conteneur pour la vidéo avec 120% de largeur
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: size.width * 1.2, // 120% de la largeur
                            child: AspectRatio(
                              aspectRatio: _videoController.value.aspectRatio,
                              child: VideoPlayer(_videoController),
                            ),
                          ),
                        ),
                      ),
                      // Overlay d'opacité qui couvre toute la vidéo
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withOpacity(0.4),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container(color: kDarkColor);
                }
              },
            ),
          ),
          
          // DÉGRADÉ SUPPLÉMENTAIRE POUR L'EFFET VISUEL
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    kDarkColor.withOpacity(0.7),
                    kDarkColor.withOpacity(0.4),
                  ],
                ),
              ),
            ),
          ),
          
          // CONTENU TEXTUEL
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isSmall ? 24 : 48,
                vertical: isSmall ? 40 : 80,
              ),
              width: size.width * 0.6, // Limite la largeur du contenu textuel
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isSmall ? 700 : 900),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Plateforme éducative de confiance en RDC',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        height: 1.05,
                        fontWeight: FontWeight.w600,
                        fontSize: isSmall ? 16 : 20,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Parents, trouvez des précepteurs qualifiés.',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        height: 1.05,
                        fontWeight: FontWeight.w800,
                        fontSize: isSmall ? 36 : 60,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'SOMA met en relation les parents et des précepteurs compétents pour un accompagnement scolaire personnalisé, sécurisé et orienté vers la réussite des élèves.',
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.92),
                        fontSize: isSmall ? 16 : 20,
                        height: 1.6,
                      ),
                    ),
                    // LES BOUTONS ONT ÉTÉ RETIRÉS ICI
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

// ====== SECTION BASE ======
class _SectionBase extends StatelessWidget {
  const _SectionBase({required this.child, this.background});
  final Widget child;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 1000;
    return Container(
      color: background,
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 24 : 48,
        vertical: 80,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: child,
        ),
      ),
    );
  }
}

// ====== SECTION À PROPOS ======
class _AboutSection extends StatelessWidget {
  const _AboutSection();

  @override
  Widget build(BuildContext context) {
    return _SectionBase(
      background: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'À PROPOS DE SOMA',
            style: GoogleFonts.inter(
              color: kPrimaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'SOMA au service de la réussite scolaire',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: kDarkColor,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'SOMA est né d\'un constat simple : les parents ont besoin d\'un accompagnement scolaire fiable, et les précepteurs compétents manquent de visibilité.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 18,
              color: kTextLight,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 48),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: kPrimaryColor.withOpacity(0.1),
                  ),
                  child: Center(
                    child: Image.asset(
                      kLogoAsset,
                      height: 150,
                      errorBuilder: (_, __, ___) => 
                        Icon(Icons.school, size: 100, color: kPrimaryColor),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 48),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notre mission',
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: kDarkColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Nous avons créé une plateforme qui met en relation les familles et des précepteurs qualifiés, dans un cadre structuré, sécurisé et orienté résultats.',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: kTextLight,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 32),
                    const _FeatureList(
                      features: [
                        'Précepteurs sélectionnés et évalués',
                        'Accompagnement scolaire personnalisé',
                        'Suivi de la progression des élèves',
                        'Plateforme simple, transparente et fiable',
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureList extends StatelessWidget {
  final List<String> features;
  const _FeatureList({required this.features});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: features.map((feature) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.check_circle, color: kSecondaryColor, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                feature,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: kDarkColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }
}

// ====== SECTION SERVICES ======
class _ServicesSection extends StatefulWidget {
  const _ServicesSection();

  @override
  State<_ServicesSection> createState() => _ServicesSectionState();
}

class _ServicesSectionState extends State<_ServicesSection> {
  final List<_ServiceItem> _services = const [
    _ServiceItem(
      'Services pour les parents',
      'Trouvez des précepteurs qualifiés pour accompagner vos enfants, suivre leur progression et renforcer leur réussite scolaire.',
      Icons.family_restroom,
      details: '''
• Recherche de précepteurs selon vos critères
• Évaluation des compétences et expériences
• Mise en relation sécurisée
• Suivi régulier des progrès
• Facturation transparente
      ''',
    ),
    _ServiceItem(
      'Services pour les précepteurs',
      'Valorisez vos compétences, trouvez des élèves et gérez vos cours grâce à une plateforme éducative structurée et fiable.',
      Icons.school,
      details: '''
• Création de profil détaillé
• Mise en relation avec des élèves
• Gestion de votre emploi du temps
• Outils pédagogiques fournis
• Paiements sécurisés
      ''',
    ),
    _ServiceItem(
      'Accompagnement scolaire',
      'Soutien scolaire personnalisé pour le primaire et le secondaire, avec un suivi adapté au niveau et aux objectifs de l\'élève.',
      Icons.auto_stories,
      details: '''
• Évaluation initiale du niveau
• Programme personnalisé
• Cours particuliers à domicile
• Exercices et devoirs adaptés
• Bilans réguliers
      ''',
    ),
    _ServiceItem(
      'Orientation académique',
      'Aide à l\'orientation scolaire et académique pour guider les élèves vers des choix adaptés à leurs capacités et ambitions.',
      Icons.trending_up,
      details: '''
• Tests d\'orientation
• Analyse des compétences
• Information sur les filières
• Accompagnement aux choix
• Préparation aux examens
      ''',
    ),
    _ServiceItem(
      'Suivi et performance',
      'Suivez l\'évolution scolaire des élèves grâce à des indicateurs clairs, des rapports simples et une communication transparente.',
      Icons.analytics,
      details: '''
• Tableaux de bord personnalisés
• Rapports de progression
• Communication avec les parents
• Alertes en cas de difficultés
• Recommandations d\'amélioration
      ''',
    ),
    _ServiceItem(
      'Plateforme éducative',
      'Une plateforme simple et sécurisée pour organiser les cours, connecter parents et précepteurs, et structurer l\'accompagnement.',
      Icons.computer,
      details: '''
• Interface intuitive
• Messagerie sécurisée
• Planning interactif
• Documents partagés
• Support technique
      ''',
    ),
  ];

  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    return _SectionBase(
      background: const Color(0xFFF8F9FA),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'NOS SERVICES',
            style: GoogleFonts.inter(
              color: kPrimaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Des solutions éducatives adaptées',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: kDarkColor,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Découvrez nos services complets pour répondre à tous vos besoins éducatifs',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 18,
              color: kTextLight,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 48),
          LayoutBuilder(builder: (context, constraints) {
            final isWide = constraints.maxWidth > 900;
            final isMedium = constraints.maxWidth > 600;
            final crossCount = isWide ? 3 : (isMedium ? 2 : 1);
            
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossCount,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: _expandedIndex != null ? 1.3 : 1.1,
              ),
              itemCount: _services.length,
              itemBuilder: (_, index) => _ServiceCard(
                service: _services[index],
                isExpanded: _expandedIndex == index,
                onTap: () {
                  setState(() {
                    if (_expandedIndex == index) {
                      _expandedIndex = null;
                    } else {
                      _expandedIndex = index;
                    }
                  });
                },
              ),
            );
          }),
          const SizedBox(height: 48),
          _CtaButton(
            label: 'Découvrir tous les services',
            onPressed: () {
              // Action pour découvrir tous les services
              Navigator.pushNamed(context, '/services');
            },
          ),
        ],
      ),
    );
  }
}

class _ServiceItem {
  final String title;
  final String description;
  final IconData icon;
  final String details;
  const _ServiceItem(this.title, this.description, this.icon, {this.details = ''});
}

class _ServiceCard extends StatelessWidget {
  final _ServiceItem service;
  final bool isExpanded;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.service,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Card(
            elevation: isExpanded ? 4 : 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isExpanded ? kPrimaryColor.withOpacity(0.3) : Colors.grey.shade200,
                width: isExpanded ? 2 : 1,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isExpanded ? 0.1 : 0.05),
                    blurRadius: isExpanded ? 25 : 20,
                    offset: Offset(0, isExpanded ? 8 : 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: kPrimaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(service.icon, size: 32, color: kPrimaryColor),
                      ),
                      Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: kPrimaryColor,
                        size: 24,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    service.title,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: kDarkColor,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Text(
                      service.description,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: kTextLight,
                        height: 1.5,
                      ),
                    ),
                  ),
                  if (isExpanded) ...[
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.grey.shade200,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Détails du service :',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: kDarkColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      service.details,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: kTextLight,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              // Action pour en savoir plus
                              Navigator.pushNamed(context, '/services');
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(color: kPrimaryColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'En savoir plus',
                              style: GoogleFonts.inter(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // Action pour contacter
                              Navigator.pushNamed(context, '/contact');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kSecondaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Nous contacter',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: onTap,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        foregroundColor: kSecondaryColor,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Développer',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 16),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ====== SECTION POURQUOI SOMA ======
class _WhySection extends StatelessWidget {
  const _WhySection();

  @override
  Widget build(BuildContext context) {
    return _SectionBase(
      background: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'POURQUOI SOMA',
            style: GoogleFonts.inter(
              color: kPrimaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Pourquoi choisir SOMA pour l\'accompagnement scolaire',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: kDarkColor,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 48),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Des précepteurs sélectionnés avec rigueur',
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: kDarkColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: const [
                        _TagChip(label: 'Compétence'),
                        _TagChip(label: 'Expérience'),
                        _TagChip(label: 'Pédagogie'),
                        _TagChip(label: 'Fiabilité'),
                        _TagChip(label: 'Engagement'),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'SOMA sélectionne des précepteurs qualifiés et engagés afin de garantir un accompagnement scolaire sérieux, adapté au niveau de chaque élève et orienté vers des résultats concrets.',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: kTextLight,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _CtaButton(
                      label: 'Découvrir les services',
                      onPressed: () {
                        // Navigation vers les services
                        Navigator.pushNamed(context, '/services');
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 48),
              Expanded(
                child: Container(
                  height: 500,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: kSecondaryColor.withOpacity(0.1),
                  ),
                  child: Center(
                    child: Image.asset(
                      kLogoAsset,
                      height: 150,
                      errorBuilder: (_, __, ___) => 
                        Icon(Icons.groups, size: 100, color: kSecondaryColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: kPrimaryColor.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: kPrimaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
}

// ====== SECTION ÉQUIPE ======
class _TeamSection extends StatelessWidget {
  const _TeamSection();

  final List<_TeamMember> _teamMembers = const [
    _TeamMember(
      'Allain ALI M.',
      'Chief Executive Officer (CEO)',
      imagePath: 'assets/images/team/allain_ali.jpg',
    ),
    _TeamMember(
      'Raphaël MWELA K.',
      'Chief Operating Officer',
      imagePath: 'assets/images/team/raphael_mwela.jpg',
    ),
    _TeamMember(
      'Sarah Jessica',
      'Chargée de Marketing',
      imagePath: 'assets/images/team/sarah_jessica.jpg',
    ),
    _TeamMember(
      'Noëlla SIFA',
      'Secrétaire',
      imagePath: 'assets/images/team/noella_sifa.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return _SectionBase(
      background: const Color(0xFFF8F9FA),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'NOTRE ÉQUIPE',
            style: GoogleFonts.inter(
              color: kPrimaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Une équipe engagée pour votre réussite',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: kDarkColor,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 48),
          LayoutBuilder(builder: (context, constraints) {
            final isWide = constraints.maxWidth > 900;
            final isMedium = constraints.maxWidth > 600;
            final crossCount = isWide ? 4 : (isMedium ? 2 : 1);
            
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossCount,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: 0.75,
              ),
              itemCount: _teamMembers.length,
              itemBuilder: (_, index) => _TeamCard(member: _teamMembers[index]),
            );
          }),
        ],
      ),
    );
  }
}

class _TeamMember {
  final String name;
  final String role;
  final String? imagePath;
  const _TeamMember(this.name, this.role, {this.imagePath});
}

class _TeamCard extends StatelessWidget {
  final _TeamMember member;
  const _TeamCard({required this.member});

  @override
  Widget build(BuildContext context) {
    // Récupérer les initiales du nom
    final initials = member.name
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map((part) => part[0])
        .take(2)
        .join();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // SECTION AVATAR - Version avec image
            Expanded(
              flex: 3,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  color: Color(0xFFF8F9FA),
                ),
                child: Center(
                  child: member.imagePath != null
                      ? Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: kPrimaryColor.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              member.imagePath!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => 
                                _buildInitialsCircle(initials),
                            ),
                          ),
                        )
                      : _buildInitialsCircle(initials),
                ),
              ),
            ),
            // SECTION INFOS
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        member.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: kDarkColor,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Flexible(
                      child: Text(
                        member.role,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: kTextLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.facebook, size: 20),
                          onPressed: () {},
                          color: kPrimaryColor,
                        ),
                        IconButton(
                          icon: const Icon(Icons.link, size: 20),
                          onPressed: () {},
                          color: kPrimaryColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialsCircle(String initials) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: kPrimaryColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: GoogleFonts.inter(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: kPrimaryColor,
          ),
        ),
      ),
    );
  }
}

// ====== SECTION TÉMOIGNAGES ======
class _TestimonialsSection extends StatelessWidget {
  const _TestimonialsSection();

  final List<_Testimonial> _testimonials = const [
    _Testimonial(
      'Destin Nguomoja',
      'Parent',
      '"Grâce à SOMA, j\'ai trouvé un précepteur sérieux pour mon enfant. Le suivi est clair, la communication est fluide et les résultats scolaires se sont nettement améliorés."',
    ),
    _Testimonial(
      'Moïse Muzalia',
      'Parent',
      '"SOMA m\'a rassuré en tant que parent. Les précepteurs sont bien encadrés et je peux suivre l\'évolution de mon enfant. C\'est une vraie solution pour l\'accompagnement scolaire."',
    ),
    _Testimonial(
      'Joël Makana',
      'Parent',
      '"Avant SOMA, il était difficile de trouver un bon répétiteur. Aujourd\'hui, mon enfant est bien encadré et motivé. Je recommande SOMA à tous les parents."',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return _SectionBase(
      background: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'TÉMOIGNAGES',
            style: GoogleFonts.inter(
              color: kPrimaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Ce que disent les parents accompagnés par SOMA',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: kDarkColor,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 48),
          SizedBox(
            height: 400,
            child: PageView.builder(
              itemCount: _testimonials.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _TestimonialCard(testimonial: _testimonials[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Testimonial {
  final String name;
  final String role;
  final String text;
  const _Testimonial(this.name, this.role, this.text);
}

class _TestimonialCard extends StatelessWidget {
  final _Testimonial testimonial;
  const _TestimonialCard({required this.testimonial});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: kAccentColor, size: 28),
              Icon(Icons.star, color: kAccentColor, size: 28),
              Icon(Icons.star, color: kAccentColor, size: 28),
              Icon(Icons.star, color: kAccentColor, size: 28),
              Icon(Icons.star, color: kAccentColor, size: 28),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            testimonial.text,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 18,
              color: kTextDark,
              fontStyle: FontStyle.italic,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kPrimaryColor.withOpacity(0.1),
                ),
                child: const Icon(Icons.person, size: 30, color: kPrimaryColor),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    testimonial.name,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: kDarkColor,
                    ),
                  ),
                  Text(
                    testimonial.role,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: kTextLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ====== SECTION CTA ======
class _CtaSection extends StatelessWidget {
  const _CtaSection();

  @override
  Widget build(BuildContext context) {
    return _SectionBase(
      background: kPrimaryColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Prêt à offrir un meilleur accompagnement scolaire à votre enfant ?',
                  style: GoogleFonts.inter(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Avec SOMA, trouvez des précepteurs qualifiés, bénéficiez d\'un suivi structuré et accompagnez efficacement la réussite scolaire de vos enfants.',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    // Ouvrir le modal pour trouver un précepteur
                    showDialog(
                      context: context,
                      builder: (context) => _TutorModal(
                        title: 'Trouver un précepteur',
                        description: 'Remplissez ce formulaire pour trouver le précepteur idéal pour votre enfant.',
                        submitText: 'Rechercher',
                        onSubmit: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Recherche de précepteur lancée !'),
                              backgroundColor: kSecondaryColor,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: kPrimaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: const Text('Trouver un précepteur'),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48),
          Expanded(
            child: Container(
              height: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white.withOpacity(0.1),
              ),
              child: Center(
                child: Image.asset(
                  kLogoWhiteAsset,
                  height: 150,
                  errorBuilder: (_, __, ___) => 
                    Icon(Icons.handshake, size: 100, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ====== SECTION FOOTER ======
class _FooterSection extends StatelessWidget {
  const _FooterSection();

  @override
  Widget build(BuildContext context) {
    final year = DateTime.now().year;

    return Container(
      color: kDarkColor,
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 80),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _BrandMark(textColor: Colors.white, logoHeight: 32),
                    const SizedBox(height: 24),
                    Text(
                      'SOMA est une plateforme éducative qui met en relation les parents et des précepteurs qualifiés pour un accompagnement scolaire fiable, structuré et orienté vers la réussite des élèves.',
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        _SocialIcon(icon: Icons.facebook, url: '#'),
                        _SocialIcon(icon: Icons.facebook, url: '#'),
                        _SocialIcon(icon: Icons.link, url: '#'),
                        _SocialIcon(icon: Icons.play_arrow, url: '#'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 48),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FooterTitle('Liens utiles'),
                    const SizedBox(height: 20),
                    _FooterLink(
                      'Accueil',
                      onTap: () => Navigator.pushNamed(context, '/'),
                    ),
                    _FooterLink(
                      'Services',
                      onTap: () => Navigator.pushNamed(context, '/services'),
                    ),
                    _FooterLink(
                      'Blog',
                      onTap: () => Navigator.pushNamed(context, '/blog'),
                    ),
                    _FooterLink(
                      'À propos',
                      onTap: () => Navigator.pushNamed(context, '/about'),
                    ),
                    _FooterLink(
                      'Contact',
                      onTap: () => Navigator.pushNamed(context, '/contact'),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 48),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FooterTitle('Contact'),
                    const SizedBox(height: 20),
                    _ContactInfo(
                      icon: Icons.email,
                      text: 'contact@soma-rdc.org',
                      onTap: () => _launch('mailto:contact@soma-rdc.org'),
                    ),
                    _ContactInfo(
                      icon: Icons.location_on,
                      text: 'Kinshasa, République Démocratique du Congo',
                    ),
                    _ContactInfo(
                      icon: Icons.phone,
                      text: '+243 999 867 334',
                      onTap: () => _launch('tel:+243999867334'),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 48),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FooterTitle('Newsletter'),
                    const SizedBox(height: 20),
                    Text(
                      'Abonnez-vous à notre newsletter pour recevoir nos conseils et actualités.',
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Votre adresse email',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        // Action pour s'abonner à la newsletter
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Inscription à la newsletter réussie !'),
                            backgroundColor: kSecondaryColor,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kSecondaryColor,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('S\'abonner'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '© $year SOMA. Tous droits réservés.',
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      // Action pour les conditions d'utilisation
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Ouverture des conditions d\'utilisation'),
                          backgroundColor: kPrimaryColor,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Text(
                      'Conditions d\'utilisation',
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  TextButton(
                    onPressed: () {
                      // Action pour la politique de confidentialité
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Ouverture de la politique de confidentialité'),
                          backgroundColor: kPrimaryColor,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Text(
                      'Politique de confidentialité',
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
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
    return Text(
      text,
      style: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  
  const _FooterLink(this.text, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          alignment: Alignment.centerLeft,
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(
            color: Colors.white.withOpacity(0.8),
            fontSize: 15,
          ),
        ),
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
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: Colors.white.withOpacity(0.8)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final String url;
  const _SocialIcon({required this.icon, required this.url});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: 24),
      color: Colors.white.withOpacity(0.8),
      onPressed: () {
        // Action pour les réseaux sociaux
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ouverture du réseau social'),
            backgroundColor: kAccentColor,
            duration: Duration(seconds: 2),
          ),
        );
      },
    );
  }
}

// ====== NOUVELLES PAGES ======

// ====== PAGE SERVICES ======
class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kDarkColor,
        title: const _BrandMark(textColor: Colors.white, logoHeight: 28),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nos Services',
                style: GoogleFonts.inter(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: kDarkColor,
                ),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 30),
              Text(
                'Découvrez nos services complets d\'accompagnement scolaire',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  color: kTextLight,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Services détaillés',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: kDarkColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'SOMA propose une gamme complète de services éducatifs pour répondre aux besoins des parents et des précepteurs.',
                    ),
                    const SizedBox(height: 20),
                    // Vous pouvez réutiliser le contenu de _ServicesSection ici
                    // ou ajouter du contenu spécifique
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ====== PAGE BLOG ======
class BlogPage extends StatelessWidget {
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kDarkColor,
        title: const _BrandMark(textColor: Colors.white, logoHeight: 28),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Blog Éducatif',
                style: GoogleFonts.inter(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: kDarkColor,
                ),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 30),
              Text(
                'Articles et conseils pour la réussite scolaire',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  color: kTextLight,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Articles récents',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: kDarkColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Bientôt disponible - Nos articles éducatifs sont en cours de préparation.',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ====== PAGE À PROPOS ======
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kDarkColor,
        title: const _BrandMark(textColor: Colors.white, logoHeight: 28),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'À propos de SOMA',
                style: GoogleFonts.inter(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: kDarkColor,
                ),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notre histoire',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: kDarkColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'SOMA est une plateforme éducative innovante qui connecte les parents avec des précepteurs qualifiés pour un accompagnement scolaire fiable, structuré et orienté vers la réussite des élèves.',
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Fondée en République Démocratique du Congo, SOMA répond au besoin crucial d\'un accompagnement scolaire de qualité et accessible.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ====== PAGE CONTACT ======
class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kDarkColor,
        title: const _BrandMark(textColor: Colors.white, logoHeight: 28),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Contactez-nous',
                style: GoogleFonts.inter(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: kDarkColor,
                ),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 30),
              Text(
                'Nous sommes à votre écoute',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  color: kTextLight,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informations de contact',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: kDarkColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const _ContactInfo(
                      icon: Icons.email,
                      text: 'contact@soma-rdc.org',
                    ),
                    const _ContactInfo(
                      icon: Icons.phone,
                      text: '+243 999 867 334',
                    ),
                    const _ContactInfo(
                      icon: Icons.location_on,
                      text: 'Kinshasa, République Démocratique du Congo',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ====== FONCTION UTILITAIRE ======
Future<void> _launch(String url) async {
  try {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  } catch (e) {
    if (kDebugMode) {
      print('Erreur lors du lancement de l\'URL: $e');
    }
  }
}