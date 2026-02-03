import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants.dart';

class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final items = _items;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 44),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: LayoutBuilder(
            builder: (context, c) {
              final w = c.maxWidth;
              final cols = w < 720 ? 1 : (w < 1050 ? 2 : 3);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "TÉMOIGNAGES",
                    style: GoogleFonts.inter(
                      letterSpacing: 2,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: kTextLight,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Ce que disent les parents\naccompagnés par SOMA",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: w < 720 ? 28 : 36,
                      height: 1.1,
                      fontWeight: FontWeight.w900,
                      color: kDarkColor,
                    ),
                  ),
                  const SizedBox(height: 26),

                  // ✅ Wrap responsive (pas de hauteur fixe => pas d’overflow)
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      for (final t in items)
                        SizedBox(
                          width: _cardWidth(w, cols),
                          child: _TestimonialCard(t: t),
                        ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  double _cardWidth(double maxWidth, int cols) {
    if (cols <= 1) return maxWidth; // mobile
    const gap = 16.0;
    return (maxWidth - gap * (cols - 1)) / cols;
    // Ex: 2 cols => (W - 16)/2 ; 3 cols => (W - 32)/3
  }
}

class _Testimonial {
  final String quote;
  final String name;
  final String? subtitle;
  final int stars;

  const _Testimonial({
    required this.quote,
    required this.name,
    this.subtitle,
    this.stars = 5,
  });
}

const _items = <_Testimonial>[
  _Testimonial(
    quote:
        "Grâce à SOMA, j'ai trouvé un précepteur sérieux pour mon enfant. "
        "Le suivi est clair, la communication est fluide et les résultats scolaires "
        "se sont nettement améliorés.",
    name: "Destin Nquomoia", // noms longs OK (ellipsis)
    subtitle: "Parent",
    stars: 5,
  ),
  _Testimonial(
    quote:
        "L’application est simple à utiliser et l’accompagnement est rassurant. "
        "On se sent suivi et les cours sont bien structurés.",
    name: "Marie K.",
    subtitle: "Parent",
    stars: 5,
  ),
  _Testimonial(
    quote:
        "Très bonne expérience. Le précepteur est ponctuel et les progrès sont visibles. "
        "Je recommande pour les parents qui veulent un vrai suivi.",
    name: "Jean-Claude M.",
    subtitle: "Parent",
    stars: 5,
  ),
];

class _TestimonialCard extends StatelessWidget {
  final _Testimonial t;
  const _TestimonialCard({required this.t});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min, // ✅ important : pas de hauteur imposée
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _StarsRow(stars: t.stars),
            const SizedBox(height: 12),

            // ✅ Quote flexible (aucune contrainte fixe)
            Text(
              "“${t.quote}”",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                height: 1.55,
                fontSize: 14,
                color: kTextLight,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 14),

            // ✅ Ligne auteur : texte flexible (évite overflow horizontal/vertical)
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: kPrimaryColor.withOpacity(0.12),
                  child: Icon(Icons.person, color: kPrimaryColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        t.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis, // ✅ anti overflow
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w900,
                          color: kDarkColor,
                        ),
                      ),
                      if ((t.subtitle ?? '').trim().isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          t.subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: kTextLight,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StarsRow extends StatelessWidget {
  final int stars;
  const _StarsRow({required this.stars});

  @override
  Widget build(BuildContext context) {
    final s = stars.clamp(0, 5);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (i) => Icon(
          i < s ? Icons.star_rounded : Icons.star_border_rounded,
          size: 18,
          color: Colors.amber.shade700,
        ),
      ),
    );
  }
}
