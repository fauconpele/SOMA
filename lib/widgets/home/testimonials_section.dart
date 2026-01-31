import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants.dart';
import '../common/section_base.dart';

class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({super.key});

  static const testimonials = [
    Testimonial(
      'Destin Nguomoja',
      'Parent',
      'Grâce à SOMA, j\'ai trouvé un précepteur sérieux pour mon enfant. Le suivi est clair, la communication est fluide et les résultats scolaires se sont nettement améliorés.',
    ),
    Testimonial(
      'Moïse Muzalia',
      'Parent',
      'SOMA m\'a rassuré en tant que parent. Les précepteurs sont bien encadrés et je peux suivre l\'évolution de mon enfant.',
    ),
    Testimonial(
      'Joël Makana',
      'Parent',
      'Avant SOMA, il était difficile de trouver un bon répétiteur. Aujourd\'hui, mon enfant est bien encadré et motivé.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SectionBase(
      background: Colors.white,
      child: Column(
        children: [
          Text('TÉMOIGNAGES',
              style: GoogleFonts.inter(color: kPrimaryColor, fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 2)),
          const SizedBox(height: 16),
          Text('Ce que disent les parents accompagnés par SOMA',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 34, fontWeight: FontWeight.w900, color: kDarkColor, height: 1.2)),
          const SizedBox(height: 40),
          SizedBox(
            height: 360,
            child: PageView.builder(
              itemCount: testimonials.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TestimonialCard(testimonial: testimonials[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Testimonial {
  final String name;
  final String role;
  final String text;
  const Testimonial(this.name, this.role, this.text);
}

class TestimonialCard extends StatelessWidget {
  final Testimonial testimonial;
  const TestimonialCard({super.key, required this.testimonial});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(34),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 30, offset: const Offset(0, 10))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: kAccentColor, size: 26),
              Icon(Icons.star, color: kAccentColor, size: 26),
              Icon(Icons.star, color: kAccentColor, size: 26),
              Icon(Icons.star, color: kAccentColor, size: 26),
              Icon(Icons.star, color: kAccentColor, size: 26),
            ],
          ),
          const SizedBox(height: 24),
          Text('“${testimonial.text}”',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 16, color: kTextDark, fontStyle: FontStyle.italic, height: 1.7)),
          const SizedBox(height: 26),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(shape: BoxShape.circle, color: kPrimaryColor.withOpacity(0.10)),
                child: const Icon(Icons.person, size: 28, color: kPrimaryColor),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(testimonial.name, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w900, color: kDarkColor)),
                  Text(testimonial.role, style: GoogleFonts.inter(fontSize: 13, color: kTextLight)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
