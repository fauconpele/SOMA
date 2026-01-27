import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';

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

// ====== FONCTION POUR ENVOYER UN EMAIL ======
Future<void> _sendEmail({
  required String to,
  required String subject,
  required String body,
  BuildContext? context,
}) async {
  try {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: to,
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri, mode: LaunchMode.externalApplication);
      
      // Afficher un message de succès
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('L\'application email s\'ouvre... Remplissez et envoyez le message.'),
            backgroundColor: kSecondaryColor,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } else {
      throw 'Impossible d\'ouvrir l\'application email';
    }
  } catch (e) {
    if (context != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e\nCopiez manuellement les informations et envoyez-les à $to'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }
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
        '/nos-precepteurs': (context) => const NosPrecepteursPage(),
        '/devenir-precepteur': (context) => const DevenirPrecepteurPage(),
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
          if (MediaQuery.of(context).size.width > 900) ...[
            TextButton(
              onPressed: () {
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
                Navigator.pushNamed(context, '/contact');
              },
              child: const Text(
                'Contact',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 24),
            _GhostButton(
              label: 'Nos précepteurs',
              onPressed: () {
                Navigator.pushNamed(context, '/nos-precepteurs');
              },
            ),
            const SizedBox(width: 12),
            _CtaButton(
              label: 'Devenir précepteur',
              onPressed: () {
                Navigator.pushNamed(context, '/devenir-precepteur');
              },
            ),
            const SizedBox(width: 24),
          ] else ...[
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
}

// ====== PAGE NOS PRÉCEPTEURS ======
class NosPrecepteursPage extends StatefulWidget {
  const NosPrecepteursPage({super.key});

  @override
  State<NosPrecepteursPage> createState() => _NosPrecepteursPageState();
}

class _NosPrecepteursPageState extends State<NosPrecepteursPage> {
  final _formKey = GlobalKey<FormState>();
  
  final _parentNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _communeController = TextEditingController();
  final _quartierController = TextEditingController();
  final _avenueController = TextEditingController();
  final _numeroController = TextEditingController();
  final _classeController = TextEditingController();
  
  String? _niveauScolaire;
  final Map<String, bool> _matieresSelectionnees = {
    'Mathématiques': false,
    'Physique': false,
    'Chimie': false,
    'Français': false,
    'Anglais': false,
    'Dessin Industriel': false,
    'Autres': false,
  };
  String? _frequenceSouhaitee;

  final List<String> _niveauxScolaires = [
    'Primaire',
    'Secondaire',
    'Université'
  ];
  
  final List<String> _frequences = [
    '02 fois/semaine',
    '03 fois/semaine',
    '04 fois/semaine',
    'À définir avec le précepteur'
  ];

  @override
  void dispose() {
    _parentNameController.dispose();
    _phoneController.dispose();
    _communeController.dispose();
    _quartierController.dispose();
    _avenueController.dispose();
    _numeroController.dispose();
    _classeController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final matieresSelectionnees = _matieresSelectionnees.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();
      
      if (matieresSelectionnees.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez sélectionner au moins une matière'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
      
      if (_niveauScolaire == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez sélectionner le niveau scolaire'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
      
      if (_frequenceSouhaitee == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez sélectionner la fréquence souhaitée'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      // Préparation du contenu de l'email
      final emailBody = '''
NOUVELLE DEMANDE DE PRÉCEPTEUR - SOMA

=== INFORMATIONS SUR L'ÉLÈVE ===
Niveau scolaire: $_niveauScolaire
Classe/Année: ${_classeController.text}
Matières à renforcer: ${matieresSelectionnees.join(', ')}
Fréquence souhaitée: $_frequenceSouhaitee

=== INFORMATIONS DU PARENT ===
Nom complet: ${_parentNameController.text}
Téléphone: ${_phoneController.text}

Adresse:
Commune: ${_communeController.text}
Quartier: ${_quartierController.text}
Avenue: ${_avenueController.text}
Numéro: ${_numeroController.text}

=== DATE ET HEURE ===
${DateTime.now().toLocal()}

---
Ce message a été envoyé via l'application SOMA.
      ''';

      final emailSubject = 'Demande de précepteur - ${_parentNameController.text}';

      // Ouvrir l'application email avec les informations pré-remplies
      _sendEmail(
        to: 'contact@soma-rdc.org',
        subject: emailSubject,
        body: emailBody,
        context: context,
      );

      // Réinitialiser le formulaire
      _formKey.currentState!.reset();
      setState(() {
        _niveauScolaire = null;
        _frequenceSouhaitee = null;
        _matieresSelectionnees.forEach((key, value) {
          _matieresSelectionnees[key] = false;
        });
      });
    }
  }

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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NOS PRÉCEPTEURS',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Trouvez le précepteur idéal pour votre enfant',
                  style: GoogleFonts.inter(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: kDarkColor,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 40),
                
                Container(
                  padding: const EdgeInsets.all(32),
                  margin: const EdgeInsets.only(bottom: 32),
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
                      Row(
                        children: [
                          Icon(Icons.school, size: 32, color: kPrimaryColor),
                          const SizedBox(width: 16),
                          Text(
                            'Informations sur l\'élève',
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: kDarkColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      
                      Text(
                        'Niveau scolaire',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: kDarkColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _niveauScolaire,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText: 'Sélectionnez le niveau scolaire',
                          hintStyle: GoogleFonts.inter(color: kTextLight),
                        ),
                        items: _niveauxScolaires.map((String niveau) {
                          return DropdownMenuItem<String>(
                            value: niveau,
                            child: Text(niveau),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _niveauScolaire = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ce champ est obligatoire';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 24),
                      
                      Text(
                        'Classe ou année',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: kDarkColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _classeController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText: 'Ex: 6ème primaire, 4ème secondaire, 2ème année universitaire',
                          hintStyle: GoogleFonts.inter(color: kTextLight),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      Text(
                        'Matière(s) à renforcer',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: kDarkColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sélectionnez une ou plusieurs matières :',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: kTextLight,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      Wrap(
                        spacing: 16,
                        runSpacing: 12,
                        children: _matieresSelectionnees.keys.map((matiere) {
                          return FilterChip(
                            label: Text(matiere),
                            selected: _matieresSelectionnees[matiere]!,
                            onSelected: (bool selected) {
                              setState(() {
                                _matieresSelectionnees[matiere] = selected;
                              });
                            },
                            selectedColor: kPrimaryColor.withOpacity(0.2),
                            checkmarkColor: kPrimaryColor,
                            labelStyle: GoogleFonts.inter(
                              color: _matieresSelectionnees[matiere]! ? kPrimaryColor : kDarkColor,
                            ),
                          );
                        }).toList(),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      Text(
                        'Fréquence souhaitée par semaine',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: kDarkColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _frequenceSouhaitee,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText: 'Sélectionnez la fréquence',
                          hintStyle: GoogleFonts.inter(color: kTextLight),
                        ),
                        items: _frequences.map((String frequence) {
                          return DropdownMenuItem<String>(
                            value: frequence,
                            child: Text(frequence),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _frequenceSouhaitee = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ce champ est obligatoire';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                
                Container(
                  padding: const EdgeInsets.all(32),
                  margin: const EdgeInsets.only(bottom: 32),
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
                      Row(
                        children: [
                          Icon(Icons.contact_page, size: 32, color: kPrimaryColor),
                          const SizedBox(width: 16),
                          Text(
                            'Contacts et Adresse du Parent',
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: kDarkColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      
                      Text(
                        'Prénom et Nom',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: kDarkColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _parentNameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText: 'Votre nom complet',
                          hintStyle: GoogleFonts.inter(color: kTextLight),
                          prefixIcon: Icon(Icons.person, color: kPrimaryColor),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ce champ est obligatoire';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 24),
                      
                      Text(
                        'Numéro de Téléphone',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: kDarkColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText: 'Ex: +243 999 867 334',
                          hintStyle: GoogleFonts.inter(color: kTextLight),
                          prefixIcon: Icon(Icons.phone, color: kPrimaryColor),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ce champ est obligatoire';
                          }
                          if (value.length < 9) {
                            return 'Numéro de téléphone invalide';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 24),
                      
                      LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth > 600) {
                            return Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Commune',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: kDarkColor,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: _communeController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          hintText: 'Nom de la commune',
                                          hintStyle: GoogleFonts.inter(color: kTextLight),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Ce champ est obligatoire';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Quartier',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: kDarkColor,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: _quartierController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          hintText: 'Nom du quartier',
                                          hintStyle: GoogleFonts.inter(color: kTextLight),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Ce champ est obligatoire';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Commune',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: kDarkColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _communeController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    hintText: 'Nom de la commune',
                                    hintStyle: GoogleFonts.inter(color: kTextLight),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Ce champ est obligatoire';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Quartier',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: kDarkColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _quartierController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    hintText: 'Nom du quartier',
                                    hintStyle: GoogleFonts.inter(color: kTextLight),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Ce champ est obligatoire';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      
                      const SizedBox(height: 24),
                      
                      LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth > 600) {
                            return Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Avenue',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: kDarkColor,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: _avenueController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          hintText: 'Nom de l\'avenue',
                                          hintStyle: GoogleFonts.inter(color: kTextLight),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'N°',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: kDarkColor,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: _numeroController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          hintText: 'Numéro',
                                          hintStyle: GoogleFonts.inter(color: kTextLight),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Avenue',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: kDarkColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _avenueController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    hintText: 'Nom de l\'avenue',
                                    hintStyle: GoogleFonts.inter(color: kTextLight),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'N°',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: kDarkColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _numeroController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    hintText: 'Numéro',
                                    hintStyle: GoogleFonts.inter(color: kTextLight),
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: kPrimaryColor, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'N.B : Après avoir complété toutes ces informations, appuyez sur le bouton "Soumettre la demande" pour ouvrir votre application email avec toutes les informations pré-remplies.',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: kDarkColor,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kSecondaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    child: const Text('SOUMETTRE LA DEMANDE'),
                  ),
                ),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ====== PAGE DEVENIR PRÉCEPTEUR ======
class DevenirPrecepteurPage extends StatefulWidget {
  const DevenirPrecepteurPage({super.key});

  @override
  State<DevenirPrecepteurPage> createState() => _DevenirPrecepteurPageState();
}

class _DevenirPrecepteurPageState extends State<DevenirPrecepteurPage> {
  final _formKey = GlobalKey<FormState>();
  
  final _nomController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _communeController = TextEditingController();
  final _quartierController = TextEditingController();
  final _niveauEtudesController = TextEditingController();
  final _experienceController = TextEditingController();
  
  // Variables pour les sélections
  String? _domaineCompetence;
  bool? _hasExperience;
  
  // Domaines prioritaires (cases à cocher)
  final Map<String, bool> _domainesPrioritaires = {
    'Mathématiques': false,
    'Physique': false,
    'Chimie': false,
    'Français': false,
    'Anglais': false,
    'Dessin Industriel': false,
    'Conception Assistée par Ordinateur (AutoCAD, SOLIDWORKS)': false,
    'Système d\'Information Géographique (ArcGIS)': false,
  };
  
  // Liste pour le domaine de compétence
  final List<String> _domainesCompetences = [
    'Mathématiques',
    'Physique',
    'Chimie',
    'Français',
    'Anglais',
    'Dessin Industriel',
    'Conception Assistée par Ordinateur',
    'Système d\'Information Géographique',
    'Autres'
  ];

  // Variables pour les fichiers
  PlatformFile? _cvFile;
  PlatformFile? _cniFile;

  // Fonction pour sélectionner un fichier
  Future<void> _selectFile(String type) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        
        // Vérifier la taille du fichier (max 10Mo)
        if (file.size > 10 * 1024 * 1024) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Le fichier est trop volumineux. Maximum 10Mo'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
          return;
        }

        setState(() {
          if (type == 'cv') {
            _cvFile = file;
          } else if (type == 'cni') {
            _cniFile = file;
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fichier ${type == 'cv' ? 'CV' : 'Carte d\'identité'} sélectionné: ${file.name}'),
            backgroundColor: kSecondaryColor,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la sélection du fichier: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _communeController.dispose();
    _quartierController.dispose();
    _niveauEtudesController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Vérifier qu'au moins un domaine prioritaire est sélectionné
      final domainesSelectionnes = _domainesPrioritaires.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();
      
      if (domainesSelectionnes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez sélectionner au moins un domaine prioritaire'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
      
      // Vérifier que le domaine de compétence est sélectionné
      if (_domaineCompetence == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez sélectionner votre domaine de compétence'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
      
      // Vérifier l'expérience
      if (_hasExperience == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez indiquer si vous avez de l\'expérience en enseignement'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      // Préparation du contenu de l'email
      final emailBody = '''
NOUVELLE CANDIDATURE PRÉCEPTEUR - SOMA

=== INFORMATIONS PERSONNELLES ===
Nom complet: ${_nomController.text}
Téléphone: ${_phoneController.text}
Email: ${_emailController.text}
Adresse: ${_communeController.text}, ${_quartierController.text}

=== PROFIL ACADÉMIQUE/PROFESSIONNEL ===
Niveau d'études: ${_niveauEtudesController.text}
Domaine de compétence: $_domaineCompetence
Domaines prioritaires: ${domainesSelectionnes.join(', ')}

=== EXPÉRIENCE ===
Expérience en enseignement: ${_hasExperience == true ? 'Oui' : 'Non'}
${_hasExperience == true && _experienceController.text.isNotEmpty ? 'Description: ${_experienceController.text}' : ''}

=== FICHIERS ===
CV: ${_cvFile != null ? '${_cvFile!.name} (${_formatFileSize(_cvFile!.size)})' : 'Non fourni'}
Carte d'identité: ${_cniFile != null ? '${_cniFile!.name} (${_formatFileSize(_cniFile!.size)})' : 'Non fourni'}

=== DATE ET HEURE ===
${DateTime.now().toLocal()}

---
Ce message a été envoyé via l'application SOMA.
NOTE: Les fichiers sont à envoyer séparément par email ou à remettre en main propre.
      ''';

      final emailSubject = 'Candidature Précepteur - ${_nomController.text}';

      // Ouvrir l'application email avec les informations pré-remplies
      _sendEmail(
        to: 'contact@soma-rdc.org',
        subject: emailSubject,
        body: emailBody,
        context: context,
      );

      // Réinitialiser le formulaire
      _formKey.currentState!.reset();
      setState(() {
        _domaineCompetence = null;
        _hasExperience = null;
        _cvFile = null;
        _cniFile = null;
        _domainesPrioritaires.forEach((key, value) {
          _domainesPrioritaires[key] = false;
        });
      });
    }
  }

  // Fonction pour formater la taille du fichier
  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DEVENIR PRÉCEPTEUR',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Rejoignez une plateforme éducative de confiance',
                  style: GoogleFonts.inter(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: kDarkColor,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 40),
                
                // Mot d'accroche
                Container(
                  padding: const EdgeInsets.all(24),
                  margin: const EdgeInsets.only(bottom: 32),
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: kPrimaryColor.withOpacity(0.2), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.handshake, size: 32, color: kPrimaryColor),
                          const SizedBox(width: 16),
                          Text(
                            'Rejoignez notre communauté éducative',
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: kDarkColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Rejoignez une plateforme éducative de confiance et accompagnez les apprenants vers la réussite.',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: kTextDark,
                          height: 1.6,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Section : Profils Recherchés
                Container(
                  padding: const EdgeInsets.all(32),
                  margin: const EdgeInsets.only(bottom: 32),
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
                      Row(
                        children: [
                          Icon(Icons.groups, size: 32, color: kPrimaryColor),
                          const SizedBox(width: 16),
                          Text(
                            'Profils Recherchés',
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: kDarkColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'SOMA est ouvert à toutes catégories des scientifiques et passionnés de la pédagogie ayant :',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: kTextDark,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const _FeatureList(
                        features: [
                          'La maîtrise avérée de la matière enseignée',
                          'Une capacité à expliquer clairement',
                          'Le sens des responsabilités et ponctualité',
                          'Une bonne communication avec les apprenants et les parents',
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Nous accueillons :',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: kDarkColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const _FeatureList(
                        features: [
                          'Les étudiants universitaires avancés',
                          'Enseignants / formateurs',
                          'Professionnels qualifiés dans leur domaine',
                          'Les passionnés par la transmission du savoir',
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Section : Domaines prioritaires
                Container(
                  padding: const EdgeInsets.all(32),
                  margin: const EdgeInsets.only(bottom: 32),
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
                      Row(
                        children: [
                          Icon(Icons.category, size: 32, color: kPrimaryColor),
                          const SizedBox(width: 16),
                          Text(
                            'Domaines prioritaires',
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: kDarkColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Sélectionnez un ou plusieurs domaines :',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: kTextDark,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: _domainesPrioritaires.keys.map((domaine) {
                          return FilterChip(
                            label: Text(domaine),
                            selected: _domainesPrioritaires[domaine]!,
                            onSelected: (bool selected) {
                              setState(() {
                                _domainesPrioritaires[domaine] = selected;
                              });
                            },
                            selectedColor: kPrimaryColor.withOpacity(0.2),
                            checkmarkColor: kPrimaryColor,
                            labelStyle: GoogleFonts.inter(
                              color: _domainesPrioritaires[domaine]! ? kPrimaryColor : kDarkColor,
                              fontSize: 14,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                
                // Section : Formulaire de candidature
                Container(
                  padding: const EdgeInsets.all(32),
                  margin: const EdgeInsets.only(bottom: 32),
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
                      Row(
                        children: [
                          Icon(Icons.description, size: 32, color: kPrimaryColor),
                          const SizedBox(width: 16),
                          Text(
                            'Formulaire de candidature',
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: kDarkColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      
                      // Informations personnelles
                      Text(
                        'Informations personnelles',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: kDarkColor,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Prénom et Nom
                      Text(
                        'Prénom et Nom',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: kDarkColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nomController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText: 'Votre nom complet',
                          hintStyle: GoogleFonts.inter(color: kTextLight),
                          prefixIcon: Icon(Icons.person, color: kPrimaryColor),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ce champ est obligatoire';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Numéro de téléphone et Email
                      LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth > 600) {
                            return Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Numéro de téléphone',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: kDarkColor,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: _phoneController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          hintText: 'Ex: +243 999 867 334',
                                          hintStyle: GoogleFonts.inter(color: kTextLight),
                                          prefixIcon: Icon(Icons.phone, color: kPrimaryColor),
                                        ),
                                        keyboardType: TextInputType.phone,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Ce champ est obligatoire';
                                          }
                                          if (value.length < 9) {
                                            return 'Numéro de téléphone invalide';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Adresse e-mail',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: kDarkColor,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: _emailController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          hintText: 'votre.email@example.com',
                                          hintStyle: GoogleFonts.inter(color: kTextLight),
                                          prefixIcon: Icon(Icons.email, color: kPrimaryColor),
                                        ),
                                        keyboardType: TextInputType.emailAddress,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Ce champ est obligatoire';
                                          }
                                          if (!value.contains('@')) {
                                            return 'Email invalide';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Numéro de téléphone',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: kDarkColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _phoneController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    hintText: 'Ex: +243 999 867 334',
                                    hintStyle: GoogleFonts.inter(color: kTextLight),
                                    prefixIcon: Icon(Icons.phone, color: kPrimaryColor),
                                  ),
                                  keyboardType: TextInputType.phone,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Ce champ est obligatoire';
                                    }
                                    if (value.length < 9) {
                                      return 'Numéro de téléphone invalide';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Adresse e-mail',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: kDarkColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    hintText: 'votre.email@example.com',
                                    hintStyle: GoogleFonts.inter(color: kTextLight),
                                    prefixIcon: Icon(Icons.email, color: kPrimaryColor),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Ce champ est obligatoire';
                                    }
                                    if (!value.contains('@')) {
                                      return 'Email invalide';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Commune / quartier de résidence
                      Text(
                        'Commune / quartier de résidence',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: kDarkColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _communeController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText: 'Ex: Lemba, Quartier Ruttens',
                          hintStyle: GoogleFonts.inter(color: kTextLight),
                          prefixIcon: Icon(Icons.location_on, color: kPrimaryColor),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ce champ est obligatoire';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // CV (à téléverser)
                      Text(
                        'CV',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: kDarkColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_cvFile != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  children: [
                                    Icon(Icons.attach_file, color: kPrimaryColor, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _cvFile!.name,
                                            style: GoogleFonts.inter(
                                              color: kDarkColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            _formatFileSize(_cvFile!.size),
                                            style: GoogleFonts.inter(
                                              color: kTextLight,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                      onPressed: () {
                                        setState(() {
                                          _cvFile = null;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ElevatedButton.icon(
                              onPressed: () => _selectFile('cv'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryColor.withOpacity(0.1),
                                foregroundColor: kPrimaryColor,
                                elevation: 0,
                              ),
                              icon: const Icon(Icons.upload_file),
                              label: Text(_cvFile == null ? 'Sélectionner votre CV' : 'Remplacer le CV'),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Formats acceptés : PDF, DOC, DOCX, JPG, PNG | Taille maximale : 10 Mo',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: kTextLight,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Carte d'identité
                      Text(
                        'Carte d\'identité',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: kDarkColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_cniFile != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  children: [
                                    Icon(Icons.attach_file, color: kPrimaryColor, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _cniFile!.name,
                                            style: GoogleFonts.inter(
                                              color: kDarkColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            _formatFileSize(_cniFile!.size),
                                            style: GoogleFonts.inter(
                                              color: kTextLight,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                      onPressed: () {
                                        setState(() {
                                          _cniFile = null;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ElevatedButton.icon(
                              onPressed: () => _selectFile('cni'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryColor.withOpacity(0.1),
                                foregroundColor: kPrimaryColor,
                                elevation: 0,
                              ),
                              icon: const Icon(Icons.upload_file),
                              label: Text(_cniFile == null ? 'Sélectionner votre carte d\'identité' : 'Remplacer la carte d\'identité'),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Formats acceptés : PDF, JPG, PNG | Taille maximale : 10 Mo',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: kTextLight,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Profil académique / professionnel
                      Text(
                        'Profil académique / professionnel',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: kDarkColor,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Niveau d'études ou qualification
                      Text(
                        'Niveau d\'études ou qualification',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: kDarkColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _niveauEtudesController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText: 'Ex: Licence en Mathématiques, Master en Physique, etc.',
                          hintStyle: GoogleFonts.inter(color: kTextLight),
                          prefixIcon: Icon(Icons.school, color: kPrimaryColor),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ce champ est obligatoire';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Domaine de compétence
                      Text(
                        'Domaine de compétence',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: kDarkColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _domaineCompetence,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText: 'Sélectionnez votre domaine de compétence',
                          hintStyle: GoogleFonts.inter(color: kTextLight),
                        ),
                        items: _domainesCompetences.map((String domaine) {
                          return DropdownMenuItem<String>(
                            value: domaine,
                            child: Text(domaine),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _domaineCompetence = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ce champ est obligatoire';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Expérience
                      Text(
                        'Expérience',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: kDarkColor,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Expérience en enseignement ou encadrement
                      Text(
                        'Expérience en enseignement ou encadrement',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: kDarkColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          ChoiceChip(
                            label: const Text('Oui'),
                            selected: _hasExperience == true,
                            onSelected: (selected) {
                              setState(() {
                                _hasExperience = selected ? true : null;
                              });
                            },
                            selectedColor: kSecondaryColor.withOpacity(0.3),
                            backgroundColor: Colors.grey.shade200,
                            labelStyle: GoogleFonts.inter(
                              color: _hasExperience == true ? kSecondaryColor : kDarkColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          ChoiceChip(
                            label: const Text('Non'),
                            selected: _hasExperience == false,
                            onSelected: (selected) {
                              setState(() {
                                _hasExperience = selected ? false : null;
                              });
                            },
                            selectedColor: kPrimaryColor.withOpacity(0.3),
                            backgroundColor: Colors.grey.shade200,
                            labelStyle: GoogleFonts.inter(
                              color: _hasExperience == false ? kPrimaryColor : kDarkColor,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Brève description de l'expérience
                      if (_hasExperience == true) ...[
                        Text(
                          'Brève description de l\'expérience',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: kDarkColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _experienceController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            hintText: 'Décrivez brièvement votre expérience (max 200 caractères)',
                            hintStyle: GoogleFonts.inter(color: kTextLight),
                            prefixIcon: Icon(Icons.work_history, color: kPrimaryColor),
                          ),
                          maxLines: 3,
                          maxLength: 200,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ],
                  ),
                ),
                
                // Note informative
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: kPrimaryColor, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'N.B : Après avoir complété toutes ces informations, appuyez sur le bouton "Soumettre la candidature" pour ouvrir votre application email avec toutes les informations pré-remplies.',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: kDarkColor,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Bouton de soumission
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kSecondaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    child: const Text('SOUMETTRE LA CANDIDATURE'),
                  ),
                ),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ====== PAGE CONTACT ======
class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _sujetController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nomController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _sujetController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      // Préparation du contenu de l'email
      final emailBody = '''
NOUVEAU MESSAGE DE CONTACT - SOMA

=== INFORMATIONS DU CONTACT ===
Nom: ${_nomController.text}
Email: ${_emailController.text}
Téléphone: ${_phoneController.text}

=== MESSAGE ===
Sujet: ${_sujetController.text}

${_messageController.text}

=== DATE ET HEURE ===
${DateTime.now().toLocal()}

---
Ce message a été envoyé via l'application SOMA.
      ''';

      final emailSubject = 'Contact SOMA - ${_sujetController.text}';

      // Ouvrir l'application email avec les informations pré-remplies
      await _sendEmail(
        to: 'contact@soma-rdc.org',
        subject: emailSubject,
        body: emailBody,
        context: context,
      );

      _formKey.currentState!.reset();
      setState(() {
        _isSubmitting = false;
      });
    }
  }

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
                'CONTACTEZ-NOUS',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: kPrimaryColor,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Nous sommes à votre écoute',
                style: GoogleFonts.inter(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: kDarkColor,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 40),

              // Section informations de contact
              Container(
                padding: const EdgeInsets.all(32),
                margin: const EdgeInsets.only(bottom: 32),
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
                    Row(
                      children: [
                        Icon(Icons.contact_mail, size: 32, color: kPrimaryColor),
                        const SizedBox(width: 16),
                        Text(
                          'Informations de contact',
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: kDarkColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Informations de contact en grille
                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth > 600) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _ContactInfoItem(
                                  icon: Icons.location_on,
                                  title: 'Adresse',
                                  content: '067, avenue des Écuries\nQuartier Ruttens\nCommune de Lemba\nKinshasa, RDC',
                                  color: kPrimaryColor,
                                  onTap: () => _launch('https://maps.google.com'),
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: _ContactInfoItem(
                                  icon: Icons.phone,
                                  title: 'Téléphone',
                                  content: '+243 999 867 334\n+243 900 000 000',
                                  color: kSecondaryColor,
                                  onTap: () => _launch('tel:+243999867334'),
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: _ContactInfoItem(
                                  icon: Icons.email,
                                  title: 'Email',
                                  content: 'contact@soma-rdc.org\ninfo@soma-rdc.org',
                                  color: kAccentColor,
                                  onTap: () => _launch('mailto:contact@soma-rdc.org'),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              _ContactInfoItem(
                                icon: Icons.location_on,
                                title: 'Adresse',
                                content: '067, avenue des Écuries\nQuartier Ruttens\nCommune de Lemba\nKinshasa, RDC',
                                color: kPrimaryColor,
                                onTap: () => _launch('https://maps.google.com'),
                              ),
                              const SizedBox(height: 24),
                              _ContactInfoItem(
                                icon: Icons.phone,
                                title: 'Téléphone',
                                content: '+243 999 867 334\n+243 900 000 000',
                                color: kSecondaryColor,
                                onTap: () => _launch('tel:+243999867334'),
                              ),
                              const SizedBox(height: 24),
                              _ContactInfoItem(
                                icon: Icons.email,
                                title: 'Email',
                                content: 'contact@soma-rdc.org\ninfo@soma-rdc.org',
                                color: kAccentColor,
                                onTap: () => _launch('mailto:contact@soma-rdc.org'),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Horaires d'ouverture
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: kPrimaryColor.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.access_time, color: kPrimaryColor, size: 24),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Horaires d\'ouverture',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: kDarkColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Lundi - Vendredi : 8h00 - 18h00\nSamedi : 9h00 - 13h00\nDimanche : Fermé',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: kTextLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Section formulaire de contact
              Container(
                padding: const EdgeInsets.all(32),
                margin: const EdgeInsets.only(bottom: 32),
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.message, size: 32, color: kPrimaryColor),
                          const SizedBox(width: 16),
                          Text(
                            'Formulaire de contact',
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: kDarkColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      
                      Text(
                        'Envoyez-nous un message',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: kDarkColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Remplissez ce formulaire et nous vous répondrons dans les plus brefs délais.',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: kTextLight,
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Nom complet
                      Text(
                        'Nom complet *',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: kDarkColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nomController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText: 'Votre nom complet',
                          hintStyle: GoogleFonts.inter(color: kTextLight),
                          prefixIcon: Icon(Icons.person, color: kPrimaryColor),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ce champ est obligatoire';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Email et téléphone
                      LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth > 600) {
                            return Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Adresse email *',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: kDarkColor,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: _emailController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          hintText: 'votre.email@example.com',
                                          hintStyle: GoogleFonts.inter(color: kTextLight),
                                          prefixIcon: Icon(Icons.email, color: kPrimaryColor),
                                        ),
                                        keyboardType: TextInputType.emailAddress,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Ce champ est obligatoire';
                                          }
                                          if (!value.contains('@')) {
                                            return 'Email invalide';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Numéro de téléphone',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: kDarkColor,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: _phoneController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          hintText: '+243 999 867 334',
                                          hintStyle: GoogleFonts.inter(color: kTextLight),
                                          prefixIcon: Icon(Icons.phone, color: kPrimaryColor),
                                        ),
                                        keyboardType: TextInputType.phone,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Adresse email *',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: kDarkColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    hintText: 'votre.email@example.com',
                                    hintStyle: GoogleFonts.inter(color: kTextLight),
                                    prefixIcon: Icon(Icons.email, color: kPrimaryColor),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Ce champ est obligatoire';
                                    }
                                    if (!value.contains('@')) {
                                      return 'Email invalide';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Numéro de téléphone',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: kDarkColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _phoneController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    hintText: '+243 999 867 334',
                                    hintStyle: GoogleFonts.inter(color: kTextLight),
                                    prefixIcon: Icon(Icons.phone, color: kPrimaryColor),
                                  ),
                                  keyboardType: TextInputType.phone,
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Sujet
                      Text(
                        'Sujet *',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: kDarkColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _sujetController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText: 'Sujet de votre message',
                          hintStyle: GoogleFonts.inter(color: kTextLight),
                          prefixIcon: Icon(Icons.subject, color: kPrimaryColor),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ce champ est obligatoire';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Message
                      Text(
                        'Message *',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: kDarkColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText: 'Votre message...',
                          hintStyle: GoogleFonts.inter(color: kTextLight),
                          prefixIcon: Icon(Icons.message, color: kPrimaryColor),
                        ),
                        maxLines: 5,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ce champ est obligatoire';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Bouton d'envoi
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kSecondaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'ENVOYER LE MESSAGE PAR EMAIL',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Section réseaux sociaux
              Container(
                padding: const EdgeInsets.all(32),
                margin: const EdgeInsets.only(bottom: 32),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: kPrimaryColor.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Suivez-nous sur les réseaux sociaux',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: kDarkColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Restez informé de nos actualités, conseils et événements',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: kTextLight,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _SocialButton(
                          icon: Icons.facebook,
                          label: 'Facebook',
                          onPressed: () => _launch('https://facebook.com/soma-rdc'),
                          color: const Color(0xFF1877F2),
                        ),
                        const SizedBox(width: 16),
                        _SocialButton(
                          icon: Icons.link,
                          label: 'LinkedIn',
                          onPressed: () => _launch('https://linkedin.com/company/soma-rdc'),
                          color: const Color(0xFF0077B5),
                        ),
                        const SizedBox(width: 16),
                        _SocialButton(
                          icon: Icons.photo_camera,
                          label: 'Instagram',
                          onPressed: () => _launch('https://instagram.com/soma_rdc'),
                          color: const Color(0xFFE4405F),
                        ),
                        const SizedBox(width: 16),
                        _SocialButton(
                          icon: Icons.play_arrow,
                          label: 'YouTube',
                          onPressed: () => _launch('https://youtube.com/soma-rdc'),
                          color: const Color(0xFFFF0000),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Section FAQ / Questions fréquentes
              Container(
                padding: const EdgeInsets.all(32),
                margin: const EdgeInsets.only(bottom: 32),
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
                      'Questions fréquentes',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: kDarkColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    _FAQItem(
                      question: 'Comment puis-je trouver un précepteur pour mon enfant ?',
                      answer: 'Rendez-vous sur la page "Nos précepteurs" et remplissez le formulaire de demande. Nous vous mettrons en relation avec un précepteur qualifié selon vos besoins.',
                    ),
                    const SizedBox(height: 16),
                    
                    _FAQItem(
                      question: 'Comment devenir précepteur chez SOMA ?',
                      answer: 'Allez sur la page "Devenir précepteur" et remplissez le formulaire de candidature. Notre équipe étudiera votre profil et vous contactera rapidement.',
                    ),
                    const SizedBox(height: 16),
                    
                    _FAQItem(
                      question: 'Quels sont les tarifs des services ?',
                      answer: 'Les tarifs varient selon le niveau scolaire, les matières enseignées et la fréquence des cours. Contactez-nous pour obtenir un devis personnalisé.',
                    ),
                    const SizedBox(height: 16),
                    
                    _FAQItem(
                      question: 'Quelle est la durée d\'un cours de préceptorat ?',
                      answer: 'Les cours durent généralement 1h30 à 2h, avec la possibilité d\'ajuster la durée selon les besoins spécifiques de l\'élève.',
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget pour les éléments d'information de contact
class _ContactInfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final Color color;
  final VoidCallback onTap;

  const _ContactInfoItem({
    required this.icon,
    required this.title,
    required this.content,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              content,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: kTextDark,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget pour les boutons de réseaux sociaux
class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color color;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white, size: 28),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: kDarkColor,
          ),
        ),
      ],
    );
  }
}

// Widget pour les questions fréquentes
class _FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const _FAQItem({
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kLightColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.help_outline, color: kPrimaryColor, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  question,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: kDarkColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: Text(
              answer,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: kTextLight,
                height: 1.6,
              ),
            ),
          ),
        ],
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
                'Nos précepteurs',
                onTap: () {
                  Navigator.of(ctx).pop();
                  Navigator.pushNamed(ctx, '/nos-precepteurs');
                },
              ),
              _SheetItem(
                'Devenir précepteur',
                onTap: () {
                  Navigator.of(ctx).pop();
                  Navigator.pushNamed(ctx, '/devenir-precepteur');
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
          Positioned.fill(
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: size.width * 1.2,
                            child: AspectRatio(
                              aspectRatio: _videoController.value.aspectRatio,
                              child: VideoPlayer(_videoController),
                            ),
                          ),
                        ),
                      ),
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
          
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isSmall ? 24 : 48,
                vertical: isSmall ? 40 : 80,
              ),
              width: size.width * 0.6,
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

// ====== CARTE DE SERVICE POUR PAGE D'ACCUEIL ======
class _HomeServiceCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const _HomeServiceCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      size: 32,
                      color: kPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: kDarkColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: kTextLight,
                      height: 1.5,
                    ),
                  ),
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
                          'En savoir plus',
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ====== SECTION SERVICES (Page d'accueil) ======
class _ServicesSection extends StatelessWidget {
  const _ServicesSection();

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
            'Solutions éducatives complètes',
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
            'Découvrez notre gamme de services conçus pour accompagner la réussite scolaire',
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
            final crossCount = isWide ? 3 : 2;
            
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossCount,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: 0.9,
              ),
              itemCount: 3,
              itemBuilder: (_, index) {
                final services = [
                  {
                    'title': 'Pour les parents',
                    'description': 'Trouvez des précepteurs qualifiés pour accompagner vos enfants',
                    'icon': Icons.family_restroom,
                  },
                  {
                    'title': 'Pour les précepteurs',
                    'description': 'Valorisez vos compétences et trouvez des élèves',
                    'icon': Icons.school,
                  },
                  {
                    'title': 'Accompagnement scolaire',
                    'description': 'Soutien personnalisé pour la réussite des élèves',
                    'icon': Icons.auto_stories,
                  },
                ];
                
                final service = services[index];
                
                return _HomeServiceCard(
                  title: service['title'] as String,
                  description: service['description'] as String,
                  icon: service['icon'] as IconData,
                  onTap: () {
                    Navigator.pushNamed(context, '/services');
                  },
                );
              },
            );
          }),
          
          const SizedBox(height: 48),
          
          _CtaButton(
            label: 'Découvrir tous nos services',
            onPressed: () {
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

// ====== CARTE DE SERVICE CORRIGÉE ======
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
          height: isExpanded ? 500 : 300,
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
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
                          Text(
                            service.description,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              color: kTextLight,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    if (isExpanded) ...[
                      Divider(height: 1, color: Colors.grey.shade200),
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                      Navigator.pushNamed(context, '/contact');
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
                          ],
                        ),
                      ),
                    ] else ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 20),
                        child: TextButton(
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
                      ),
                    ],
                  ],
                ),
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
                    Navigator.pushNamed(context, '/nos-precepteurs');
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
                    _FooterLink(
                      'Nos précepteurs',
                      onTap: () => Navigator.pushNamed(context, '/nos-precepteurs'),
                    ),
                    _FooterLink(
                      'Devenir précepteur',
                      onTap: () => Navigator.pushNamed(context, '/devenir-precepteur'),
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ouverture du réseau social'),
            backgroundColor: kAccentColor,
            duration: Duration(seconds: 2),
          ),
        );
      },
    );
  }
}

// ====== PAGE SERVICES ======
class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
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
        child: _SectionBase(
          background: kLightColor,
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
                'Des solutions éducatives complètes',
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
                'Découvrez notre gamme complète de services conçus pour répondre à tous les besoins éducatifs des parents, des élèves et des précepteurs.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  color: kTextLight,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 48),
              
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: kPrimaryColor.withOpacity(0.2), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: kPrimaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.groups, size: 32, color: kPrimaryColor),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Le Préceptorat',
                          style: GoogleFonts.inter(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: kDarkColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Le préceptorat est le pilier principal de SOMA. Contrairement aux formations de masse, il repose sur un suivi personnalisé, adapté au niveau, au rythme et aux objectifs de chaque apprenant. Les séances se déroulent principalement en présentiel, afin de favoriser l\'interaction directe, la compréhension approfondie et un encadrement rigoureux.',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: kTextDark,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Grâce à cette approche, SOMA permet :',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: kDarkColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const _FeatureList(
                      features: [
                        'Une meilleure compréhension des notions étudiées',
                        'Un accompagnement sur mesure, ciblé sur les difficultés réelles',
                        'Un suivi régulier et motivant',
                        'Des résultats mesurables et durables',
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: kSecondaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: kSecondaryColor.withOpacity(0.2), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: kSecondaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.computer, size: 32, color: kSecondaryColor),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Formations Professionnelles',
                          style: GoogleFonts.inter(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: kDarkColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'En plus du préceptorat, SOMA propose un ensemble de formations professionnelles dans le domaine de :',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: kTextDark,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _FormationItem(
                            title: 'Conception Assistée par Ordinateur',
                            software: 'AutoCAD & SOLIDWORKS',
                            description: 'Formation complète en CAO pour la modélisation 2D et 3D',
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _FormationItem(
                            title: 'Système d\'Information Géographique',
                            software: 'ArcGIS',
                            description: 'Formation en SIG pour l\'analyse et la cartographie spatiale',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Ces formations sont conçues pour répondre aux besoins du marché professionnel et sont dispensées par des formateurs certifiés avec une approche pratique et orientée résultats.',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: kTextLight,
                        fontStyle: FontStyle.italic,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: kPrimaryColor.withOpacity(0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.important_devices, size: 48, color: kPrimaryColor),
                    const SizedBox(height: 16),
                    Text(
                      'Une approche intégrée',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: kDarkColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'SOMA propose une approche complète qui combine mise en relation, suivi pédagogique, outils numériques et accompagnement personnalisé pour garantir la réussite scolaire.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: kTextLight,
                        height: 1.6,
                      ),
                    ),
                  ],
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
                    childAspectRatio: 0.9,
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
              
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [kPrimaryColor.withOpacity(0.1), kSecondaryColor.withOpacity(0.1)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pourquoi choisir nos services ?',
                            style: GoogleFonts.inter(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: kDarkColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const _FeatureList(
                            features: [
                              'Précepteurs certifiés et évalués',
                              'Suivi personnalisé de la progression',
                              'Outils pédagogiques modernes',
                              'Support dédié 7j/7',
                              'Tarification transparente',
                              'Flexibilité des horaires',
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 32),
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: kDarkColor.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.verified_user,
                          size: 80,
                          color: kSecondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 48),
              
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Prêt à commencer ?',
                            style: GoogleFonts.inter(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Que vous soyez parent à la recherche d\'un précepteur ou précepteur souhaitant rejoindre notre plateforme, nous sommes là pour vous accompagner.',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 32),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/nos-precepteurs');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: kPrimaryColor,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Trouver un précepteur',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/devenir-precepteur');
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Devenir précepteur',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
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

// ====== WIDGET POUR LES FORMATIONS ======
class _FormationItem extends StatelessWidget {
  final String title;
  final String software;
  final String description;

  const _FormationItem({
    required this.title,
    required this.software,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.engineering, color: kSecondaryColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: kDarkColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: kSecondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              software,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: kSecondaryColor,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: kTextLight,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/contact');
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              foregroundColor: kPrimaryColor,
            ),
            child: Row(
              children: [
                Text(
                  'Demander plus d\'informations',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 16),
              ],
            ),
          ),
        ],
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
                'BLOG ÉDUCATIF SOMA',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: kPrimaryColor,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Conseils et ressources pour la réussite scolaire',
                style: GoogleFonts.inter(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: kDarkColor,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 40),
              
              Text(
                'Découvrez nos articles récents',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: kTextDark,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Conseils pratiques, méthodes d\'apprentissage et astuces pour les parents et les élèves',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: kTextLight,
                ),
              ),
              const SizedBox(height: 40),
              
              // Article 1
              _BlogPostCard(
                title: 'Comment choisir le bon précepteur pour son enfant',
                excerpt: 'Guide complet pour évaluer les compétences pédagogiques et trouver l\'accompagnement idéal selon le profil de votre enfant.',
                date: '15 Mars 2024',
                readTime: '5 min',
                category: 'Conseils Parents',
                imageAsset: 'assets/images/blog/precepteur.jpg',
                onTap: () => _showBlogDetail(
                  context,
                  title: 'Comment choisir le bon précepteur pour son enfant',
                  content: '''
Choisir le bon précepteur est crucial pour la réussite scolaire de votre enfant. Voici nos conseils :

1. Évaluez les compétences académiques
- Vérifiez les qualifications et l\'expérience
- Demandez des références ou témoignages
- Assurez-vous de la maîtrise de la matière

2. Observez les qualités pédagogiques
- Capacité à expliquer clairement
- Patience et écoute active
- Adaptation au rythme de l\'élève

3. Vérifiez la compatibilité
- Rencontre préalable avec l\'enfant
- Test de personnalité
- Évaluation du feeling

4. Structure des séances
- Planification des objectifs
- Méthodologie d\'enseignement
- Outils pédagogiques utilisés

5. Suivi et communication
- Rapports réguliers de progression
- Communication facile avec les parents
- Flexibilité en cas de besoins spécifiques

Notre recommandation :
Privilégiez toujours la qualité pédagogique à la proximité géographique. Un bon précepteur sait adapter son approche et maintenir la motivation de l\'élève sur le long terme.
                  ''',
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Article 2
              _BlogPostCard(
                title: '5 méthodes efficaces pour améliorer la concentration',
                excerpt: 'Techniques éprouvées pour aider les enfants et adolescents à mieux se concentrer pendant les études.',
                date: '10 Mars 2024',
                readTime: '4 min',
                category: 'Méthodologie',
                imageAsset: 'assets/images/blog/concentration.jpg',
                onTap: () => _showBlogDetail(
                  context,
                  title: '5 méthodes efficaces pour améliorer la concentration',
                  content: '''
La concentration est une compétence clé pour la réussite scolaire. Voici 5 méthodes efficaces :

1. La technique Pomodoro
- 25 minutes de travail intensif
- 5 minutes de pause
- Répéter 4 fois, puis pause longue
- Idéal pour les devoirs et révisions

2. L\'environnement d\'étude optimal
- Espace dédié et organisé
- Élimination des distractions
- Bon éclairage et aération
- Matériel à portée de main

3. La planification intelligente
- Sessions courtes et régulières
- Alternance des matières
- Moments propices (matin souvent meilleur)
- Objectifs clairs par session

4. Les pauses actives
- Exercices physiques légers
- Respiration profonde
- Hydratation régulière
- Changement de position

5. Techniques de mindfulness
- Méditation courte avant étude
- Exercices de visualisation
- Concentration sur la respiration
- Reconnaissance des distractions

Conseil SOMA :
Commencez par mettre en place une seule méthode, observez les résultats, puis ajoutez progressivement les autres techniques.
                  ''',
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Article 3
              _BlogPostCard(
                title: 'Les avantages du préceptorat personnalisé vs cours collectifs',
                excerpt: 'Analyse comparative des bénéfices de l\'accompagnement individualisé pour des progrès rapides et durables.',
                date: '5 Mars 2024',
                readTime: '6 min',
                category: 'Éducation',
                imageAsset: 'assets/images/blog/personnalisation.jpg',
                onTap: () => _showBlogDetail(
                  context,
                  title: 'Les avantages du préceptorat personnalisé vs cours collectifs',
                  content: '''
Le préceptorat personnalisé offre des avantages significatifs par rapport aux cours collectifs :

Avantages du préceptorat personnalisé :

1. Adaptation totale au rythme
- Vitesse d\'apprentissage personnalisée
- Focus sur les difficultés spécifiques
- Pas de pression du groupe
- Progression à son propre rythme

2. Approche sur mesure
- Méthodes adaptées au style d\'apprentissage
- Exemples concrets pertinents
- Flexibilité des horaires
- Programme ajustable

3. Confiance en soi
- Environnement sans jugement
- Encouragement constant
- Reconnaissance des petits progrès
- Relation de confiance avec le précepteur

4. Résultats mesurables
- Suivi précis des compétences
- Objectifs clairs et atteignables
- Évaluations régulières
- Adaptation continue

5. Motivation durable
- Contenu intéressant pour l\'élève
- Sentiment de compétence
- Autonomie progressive
- Plaisir d\'apprendre retrouvé

Pourquoi choisir SOMA :
Notre plateforme met en relation avec des précepteurs qui comprennent que chaque élève est unique et mérite un accompagnement taillé sur mesure.
                  ''',
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Article 4
              _BlogPostCard(
                title: 'Comment gérer le stress des examens : guide pour parents',
                excerpt: 'Stratégies pour aider votre enfant à aborder sereinement les périodes d\'évaluation scolaire.',
                date: '28 Février 2024',
                readTime: '5 min',
                category: 'Bien-être',
                imageAsset: 'assets/images/blog/stress.jpg',
                onTap: () => _showBlogDetail(
                  context,
                  title: 'Comment gérer le stress des examens : guide pour parents',
                  content: '''
Le stress des examens peut être paralysant. Voici comment aider votre enfant :

1. Préparation en amont
- Planification des révisions
- Création d\'un calendrier réaliste
- Répartition équilibrée du travail
- Révision active plutôt que passive

2. Environnement serein
- Dialogue ouvert sur les craintes
- Valorisation de l\'effort plutôt que du résultat
- Éviter les comparaisons
- Maintenir une routine équilibrée

3. Techniques de gestion du stress
- Exercices de respiration
- Visualisation positive
- Pauses régulières
- Activités physiques

4. Alimentation et sommeil
- Repas équilibrés et réguliers
- Hydratation suffisante
- Heures de coucher fixes
- Limitation des écrans avant le sommeil

5. Jour J
- Préparation des affaires la veille
- Petit-déjeuner nutritif
- Arrivée en avance
- Rappel des stratégies apprises

Signaux d\'alerte :
- Troubles du sommeil persistants
- Perte d\'appétit
- Irritabilité excessive
- Évitement des révisions

Notre approche SOMA :
Nos précepteurs apprennent aux élèves à gérer le stress comme une compétence à développer, pas comme un ennemi à combattre.
                  ''',
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Article 5
              _BlogPostCard(
                title: 'Les mathématiques autrement : rendre les maths accessibles',
                excerpt: 'Approches innovantes pour démystifier les mathématiques et les rendre attractives pour tous les élèves.',
                date: '20 Février 2024',
                readTime: '7 min',
                category: 'Mathématiques',
                imageAsset: 'assets/images/blog/mathematiques.jpg',
                onTap: () => _showBlogDetail(
                  context,
                  title: 'Les mathématiques autrement : rendre les maths accessibles',
                  content: '''
Les mathématiques ne sont pas réservées à une élite. Voici comment les rendre accessibles :

1. Approche concrète
- Liens avec la vie quotidienne
- Manipulation d\'objets réels
- Projets pratiques
- Applications concrètes

2. Apprentissage par le jeu
- Jeux de logique et de stratégie
- Défis mathématiques amusants
- Compétitions saines
- Applications éducatives

3. Diversification des méthodes
- Explications visuelles
- Schémas et dessins
- Histoires et scénarios
- Méthodes alternatives de résolution

4. Construction progressive
- Retour aux bases si nécessaire
- Consolidation étape par étape
- Reconnaissance des petits succès
- Patience et persévérance

5. Culture mathématique
- Histoire des mathématiques
- Mathématiciens célèbres
- Applications modernes
- Beauté des concepts

Erreurs à éviter :
- Se focaliser uniquement sur les notes
- Critiquer les erreurs sans les expliquer
- Comparer avec d\'autres élèves
- Négliger les fondamentaux

Méthode SOMA :
Nos précepteurs en mathématiques utilisent une approche multisensorielle qui s\'adapte au style d\'apprentissage de chaque élève.
                  ''',
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Catégories
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: kLightColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Catégories',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: kDarkColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        _BlogCategoryChip(label: 'Conseils Parents'),
                        _BlogCategoryChip(label: 'Méthodologie'),
                        _BlogCategoryChip(label: 'Bien-être'),
                        _BlogCategoryChip(label: 'Mathématiques'),
                        _BlogCategoryChip(label: 'Sciences'),
                        _BlogCategoryChip(label: 'Langues'),
                        _BlogCategoryChip(label: 'Orientation'),
                        _BlogCategoryChip(label: 'Motivation'),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Newsletter
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [kPrimaryColor.withOpacity(0.1), kSecondaryColor.withOpacity(0.1)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.email, size: 48, color: kPrimaryColor),
                    const SizedBox(height: 20),
                    Text(
                      'Restez informé',
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: kDarkColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Inscrivez-vous à notre newsletter pour recevoir nos derniers articles et conseils éducatifs directement dans votre boîte mail.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: kTextLight,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: 400,
                      child: Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Votre adresse email',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Inscription à la newsletter réussie !'),
                                  backgroundColor: kSecondaryColor,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'S\'abonner',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showBlogDetail(BuildContext context, {
    required String title,
    required String content,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close, color: kDarkColor),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                'Article',
                style: GoogleFonts.inter(
                  color: kDarkColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: kDarkColor,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 32),
                  Text(
                    content,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: kTextDark,
                      height: 1.8,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: kPrimaryColor, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Besoin d\'un accompagnement personnalisé ? Nos précepteurs sont là pour vous aider.',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: kTextDark,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/nos-precepteurs');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kSecondaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Trouver un précepteur',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Widget pour les cartes d'articles de blog
class _BlogPostCard extends StatelessWidget {
  final String title;
  final String excerpt;
  final String date;
  final String readTime;
  final String category;
  final String imageAsset;
  final VoidCallback onTap;

  const _BlogPostCard({
    required this.title,
    required this.excerpt,
    required this.date,
    required this.readTime,
    required this.category,
    required this.imageAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  color: kPrimaryColor.withOpacity(0.1),
                ),
                child: Center(
                  child: Icon(
                    Icons.article,
                    size: 60,
                    color: kPrimaryColor,
                  ),
                ),
              ),
              
              // Contenu
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: kPrimaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          category,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: kDarkColor,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        excerpt,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: kTextLight,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 16, color: kTextLight),
                          const SizedBox(width: 6),
                          Text(
                            date,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: kTextLight,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Icon(Icons.timer, size: 16, color: kTextLight),
                          const SizedBox(width: 6),
                          Text(
                            '$readTime de lecture',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: kTextLight,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Lire l\'article →',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: kPrimaryColor,
                            ),
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
      ),
    );
  }
}

// Widget pour les catégories de blog
class _BlogCategoryChip extends StatelessWidget {
  final String label;

  const _BlogCategoryChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 14,
          color: kTextDark,
          fontWeight: FontWeight.w500,
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'À PROPOS DE SOMA',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: kPrimaryColor,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Notre Histoire & Notre Vision',
                style: GoogleFonts.inter(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: kDarkColor,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 40),
              
              Container(
                padding: const EdgeInsets.all(32),
                margin: const EdgeInsets.only(bottom: 32),
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
                    Row(
                      children: [
                        Icon(Icons.lightbulb_outline, size: 32, color: kPrimaryColor),
                        const SizedBox(width: 16),
                        Text(
                          'Naissance d\'une conviction',
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: kDarkColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'SOMA est née d\'une conviction simple mais puissante : la réussite n\'est jamais le fruit du hasard, elle est le résultat d\'un accompagnement juste, humain et exigeant. SOMA voit le jour dans un contexte où l\'enseignement de masse laisse trop souvent les apprenants livrés à eux-mêmes.',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: kTextDark,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Classes surchargées, formations impersonnelles, manque de suivi réel : autant de freins qui empêchent de nombreux talents d\'exprimer pleinement leur potentiel. SOMA est née pour répondre à ce manque.',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: kTextDark,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              
              Container(
                padding: const EdgeInsets.all(32),
                margin: const EdgeInsets.only(bottom: 32),
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
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 32, color: kPrimaryColor),
                        const SizedBox(width: 16),
                        Text(
                          'Notre implantation',
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: kDarkColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Implantée au 067, avenue des Écuries, quartier Ruttens, commune de Lemba, SOMA s\'inscrit comme un espace de proximité, accessible et profondément ancré dans son environnement.',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: kTextDark,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Un lieu pensé pour apprendre, progresser et construire l\'avenir dans un cadre sérieux, structuré et propice à la concentration.',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: kTextDark,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              
              Container(
                padding: const EdgeInsets.all(32),
                margin: const EdgeInsets.only(bottom: 32),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: kPrimaryColor.withOpacity(0.2), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.groups, size: 32, color: kPrimaryColor),
                        const SizedBox(width: 16),
                        Text(
                          'Le Préceptorat : Notre choix fort',
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: kDarkColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Dès ses débuts, SOMA fait un choix fort et assumé : placer le préceptorat au cœur de son identité. Un accompagnement individualisé, rigoureux et profondément humain. Ici, chaque apprenant compte. Chaque parcours est unique. Chaque objectif est pris au sérieux.',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: kTextDark,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Le préceptorat SOMA se déroule principalement en présentiel, car rien ne remplace la richesse du contact direct, l\'échange immédiat, la compréhension fine des besoins et des difficultés.',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: kTextDark,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Lorsque les circonstances l\'exigent, certaines séances sont proposées en ligne, sans jamais compromettre la qualité du suivi ni l\'exigence pédagogique qui font la réputation de SOMA.',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: kTextDark,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              
              Container(
                padding: const EdgeInsets.all(32),
                margin: const EdgeInsets.only(bottom: 32),
                decoration: BoxDecoration(
                  color: kSecondaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: kSecondaryColor.withOpacity(0.2), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cette approche permet une transformation réelle :',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: kDarkColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const _FeatureList(
                      features: [
                        'Une meilleure compréhension des notions étudiées',
                        'Un accompagnement sur mesure, ciblé sur les difficultés réelles',
                        'Un suivi régulier et motivant',
                        'Des résultats mesurables et durables',
                      ],
                    ),
                  ],
                ),
              ),
              
              Container(
                padding: const EdgeInsets.all(32),
                margin: const EdgeInsets.only(bottom: 32),
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
                    Row(
                      children: [
                        Icon(Icons.engineering, size: 32, color: kSecondaryColor),
                        const SizedBox(width: 16),
                        Text(
                          'Au-delà du préceptorat',
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: kDarkColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Mais SOMA va plus loin. Consciente que la réussite passe aussi par des compétences professionnelles solides et adaptées aux réalités du monde actuel, SOMA développe des formations professionnelles spécialisées.',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: kTextDark,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Elle accompagne apprenants et professionnels dans des domaines stratégiques tels que la Conception Assistée par Ordinateur avec AutoCAD et SOLIDWORKS, ainsi que le Système d\'Information Géographique avec ArcGIS.',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: kTextDark,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Des formations pratiques, exigeantes et orientées vers l\'employabilité et la performance.',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: kTextDark,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              
              Container(
                padding: const EdgeInsets.all(32),
                margin: const EdgeInsets.only(bottom: 32),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notre Identité',
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'SOMA n\'est pas simplement un centre de formation. C\'est un partenaire de réussite, un espace où l\'on apprend à apprendre, où l\'on reprend confiance, où l\'on construit des compétences solides et durables.',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        color: Colors.white.withOpacity(0.95),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Une structure qui allie discipline, excellence et accompagnement humain.',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        color: Colors.white.withOpacity(0.95),
                        fontStyle: FontStyle.italic,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              
              Container(
                padding: const EdgeInsets.all(32),
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
                    Row(
                      children: [
                        Icon(Icons.visibility, size: 32, color: kAccentColor),
                        const SizedBox(width: 16),
                        Text(
                          'Notre Vision à Long Terme',
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: kDarkColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Aujourd\'hui, SOMA s\'inscrit dans une vision à long terme : former des esprits compétents, autonomes et confiants, capables de relever les défis académiques et professionnels de leur génération.',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: kTextDark,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Une vision portée par l\'exigence, la proximité et la foi profonde dans le potentiel humain.',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: kTextDark,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 48),
              
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: kSecondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Prêt à nous rejoindre ?',
                            style: GoogleFonts.inter(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: kDarkColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Que vous soyez parent, élève ou professionnel, SOMA est là pour vous accompagner vers la réussite.',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: kTextLight,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 32),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/contact');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Nous contacter',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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