import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/common/simple_page_scaffold.dart';
import '../widgets/common/buttons.dart';
import '../core/constants.dart';

class DevenirPrecepteurPage extends StatelessWidget {
  const DevenirPrecepteurPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SimplePageScaffold(
      title: 'Devenir précepteur',
      subtitle: "Rejoignez l’équipe SOMA et accompagnez la réussite des apprenants en RDC.",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HERO
          Container(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kPrimaryColor.withOpacity(0.25), width: 1),
                  ),
                  child: Icon(Icons.school_rounded, color: kPrimaryColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Enseignez, inspirez, impactez.",
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: kDarkColor,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "SOMA met en relation des apprenants et des précepteurs qualifiés. "
                        "Si vous aimez transmettre, structurer et faire progresser, votre place est ici.",
                        style: GoogleFonts.inter(
                          fontSize: 13.5,
                          height: 1.65,
                          fontWeight: FontWeight.w600,
                          color: kDarkColor.withOpacity(0.78),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // CRITÈRES
          Text(
            "Critères de sélection",
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: kDarkColor,
            ),
          ),
          const SizedBox(height: 10),

          _InfoCard(
            icon: Icons.verified_rounded,
            title: "Compétences & niveau",
            body:
                "Avoir une bonne maîtrise de la matière (programme scolaire ou universitaire), "
                "et être capable d’expliquer clairement avec des exemples.",
          ),
          const SizedBox(height: 12),
          _InfoCard(
            icon: Icons.psychology_alt_rounded,
            title: "Pédagogie",
            body:
                "Savoir s’adapter au niveau de l’apprenant, diagnostiquer les lacunes, "
                "proposer une méthode de travail et des exercices progressifs.",
          ),
          const SizedBox(height: 12),
          _InfoCard(
            icon: Icons.schedule_rounded,
            title: "Disponibilité & régularité",
            body:
                "Être ponctuel, respecter les horaires, et assurer un suivi sur la durée "
                "(objectifs, feedback, mini-évaluations).",
          ),
          const SizedBox(height: 12),
          _InfoCard(
            icon: Icons.handshake_rounded,
            title: "Professionnalisme",
            body:
                "Communication respectueuse, attitude professionnelle, et sens de la responsabilité "
                "dans l’accompagnement (présentiel ou en ligne).",
          ),

          const SizedBox(height: 18),

          // PROCESS
          Text(
            "Étapes de candidature",
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: kDarkColor,
            ),
          ),
          const SizedBox(height: 10),

          _StepTile(
            index: 1,
            title: "Préparer vos informations",
            body:
                "Nom complet, matières enseignées, niveau (Secondaire / Université), zone, "
                "disponibilités et expérience.",
          ),
          _StepTile(
            index: 2,
            title: "Envoyer votre candidature",
            body:
                "Cliquez sur “Postuler” et envoyez un email avec vos informations + (si possible) "
                "CV ou références.",
          ),
          _StepTile(
            index: 3,
            title: "Entretien & test",
            body:
                "Un court échange pour valider votre pédagogie. Selon le profil, un mini-test "
                "ou une simulation de cours peut être proposé.",
          ),
          _StepTile(
            index: 4,
            title: "Validation & intégration",
            body:
                "Après validation, votre profil est ajouté à la liste SOMA et vous pouvez recevoir "
                "des demandes d’apprenants.",
          ),

          const SizedBox(height: 18),

          // CTA
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xFFF8F9FA),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Prêt(e) à postuler ? Contactez-nous maintenant.",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: kDarkColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                CtaButton(
                  label: "Postuler",
                  onPressed: () => Navigator.pushNamed(context, "/contact"),
                ),
              ],
            ),
          ),

          const SizedBox(height: 6),

          Text(
            "Astuce : sur la page Contact, vous pouvez aussi appuyer sur “Écrire un mail”.",
            style: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: kTextLight,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ===================== UI HELPERS =====================

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kPrimaryColor.withOpacity(0.22)),
            ),
            child: Icon(icon, color: kPrimaryColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w900,
                    color: kDarkColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: GoogleFonts.inter(
                    fontSize: 13.5,
                    height: 1.65,
                    fontWeight: FontWeight.w600,
                    color: kDarkColor.withOpacity(0.78),
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

class _StepTile extends StatelessWidget {
  const _StepTile({
    required this.index,
    required this.title,
    required this.body,
  });

  final int index;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: kSecondaryColor.withOpacity(0.14),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kSecondaryColor.withOpacity(0.28)),
            ),
            child: Center(
              child: Text(
                "$index",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: kSecondaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w900,
                      color: kDarkColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    body,
                    style: GoogleFonts.inter(
                      fontSize: 13.5,
                      height: 1.65,
                      fontWeight: FontWeight.w600,
                      color: kDarkColor.withOpacity(0.78),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
