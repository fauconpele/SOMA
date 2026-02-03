import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants.dart';
import '../widgets/common/simple_page_scaffold.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  static const List<_BlogPost> _posts = [
    _BlogPost(
      title: "Comment choisir le bon précepteur ?",
      excerpt:
          "Guide simple pour évaluer la pédagogie, la méthode et la compatibilité, puis organiser un suivi qui donne des résultats.",
      category: "Conseils",
      date: "15 Mars 2024",
      readTime: "5 min",
      imageAsset: "assets/images/blog/precepteur.jpg",
      content:
          "Choisir un bon précepteur est déterminant.\n\n"
          "1) Compétences : niveau, expérience, références.\n"
          "2) Pédagogie : clarté, patience, adaptation.\n"
          "3) Suivi : objectifs, exercices, mini-évaluations.\n"
          "4) Communication : retours aux parents / à l’apprenant.\n\n"
          "Conseil SOMA : privilégiez une pédagogie adaptée + un suivi régulier.",
    ),
    _BlogPost(
      title: "5 méthodes efficaces pour améliorer la concentration",
      excerpt:
          "Des techniques pratiques à appliquer dès aujourd’hui : rythme de travail, environnement, objectifs, pauses, et recentrage.",
      category: "Méthodologie",
      date: "10 Mars 2024",
      readTime: "4 min",
      imageAsset: "assets/images/blog/concentration.jpg",
      content:
          "Voici 5 méthodes utiles :\n\n"
          "• Pomodoro (25 min / 5 min)\n"
          "• Environnement sans distractions\n"
          "• Objectifs clairs par séance\n"
          "• Pauses actives (2–5 min)\n"
          "• Respiration / recentrage\n\n"
          "Commencez par une méthode, mesurez l'effet, puis améliorez.",
    ),
    _BlogPost(
      title: "Préceptorat personnalisé vs cours collectifs",
      excerpt:
          "Comparaison rapide : personnalisation, rythme, motivation, et résultats. Quelle approche choisir selon le profil ?",
      category: "Éducation",
      date: "05 Mars 2024",
      readTime: "6 min",
      imageAsset: "assets/images/blog/personnalisation.jpg",
      content:
          "Préceptorat personnalisé :\n"
          "• Rythme adapté\n"
          "• Correction ciblée des lacunes\n"
          "• Suivi measurable\n"
          "• Renforcement de confiance\n\n"
          "Cours collectifs :\n"
          "• Émulation de groupe\n"
          "• Moins flexible\n\n"
          "Le meilleur choix dépend du niveau, des objectifs et du temps disponible.",
    ),
  ];

  String _query = "";
  String _category = "Tous";

  @override
  Widget build(BuildContext context) {
    final categories = <String>{
      "Tous",
      ..._posts.map((p) => p.category),
    }.toList();

    final q = _query.trim().toLowerCase();
    final filtered = _posts.where((p) {
      final matchesQuery =
          q.isEmpty || p.title.toLowerCase().contains(q) || p.excerpt.toLowerCase().contains(q);
      final matchesCategory = _category == "Tous" || p.category == _category;
      return matchesQuery && matchesCategory;
    }).toList();

    return SimplePageScaffold(
      title: "Blog",
      subtitle: "Ressources, conseils et méthodes pour booster la réussite scolaire.",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SearchFilterBar(
            query: _query,
            categories: categories,
            currentCategory: _category,
            onQueryChanged: (v) => setState(() => _query = v),
            onCategoryChanged: (v) => setState(() => _category = v),
          ),
          const SizedBox(height: 18),

          if (filtered.isEmpty)
            _EmptyState(
              onReset: () => setState(() {
                _query = "";
                _category = "Tous";
              }),
            )
          else
            LayoutBuilder(
              builder: (context, c) {
                final w = c.maxWidth;
                final crossAxisCount = w > 980 ? 3 : (w > 650 ? 2 : 1);

                // ✅ Mobile (1 colonne) => LISTE (flexible) : supprime les overflows
                if (crossAxisCount == 1) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (_, i) => _BlogCard(
                      post: filtered[i],
                      onTap: () => _openArticle(context, filtered[i]),
                    ),
                  );
                }

                // ✅ Tablette/Web => GRID (hauteur maîtrisée)
                final extent = crossAxisCount == 2 ? 350.0 : 340.0;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    mainAxisExtent: extent, // ✅ évite les bandes jaunes/noires
                  ),
                  itemBuilder: (_, i) => _BlogCard(
                    post: filtered[i],
                    onTap: () => _openArticle(context, filtered[i]),
                  ),
                );
              },
            ),

          const SizedBox(height: 20),

          // ✅ CTA responsive (corrige les RIGHT overflow sur petits écrans)
          _BottomCta(
            onPrecepteurs: () => Navigator.pushNamed(context, "/nos-precepteurs"),
            onContact: () => Navigator.pushNamed(context, "/contact"),
          ),
        ],
      ),
    );
  }

  void _openArticle(BuildContext context, _BlogPost post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.92,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: "Fermer",
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: kDarkColor),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "Article",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: kDarkColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title,
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: kDarkColor,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _Chip(text: post.category, primary: true),
                          _Chip(text: post.date),
                          _Chip(text: "${post.readTime} de lecture"),
                        ],
                      ),
                      const SizedBox(height: 14),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: SizedBox(
                          width: double.infinity,
                          height: 190,
                          child: Image.asset(
                            post.imageAsset,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: kPrimaryColor.withOpacity(0.08),
                              child: Center(
                                child: Icon(Icons.article_outlined, size: 56, color: kPrimaryColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        post.content,
                        style: GoogleFonts.inter(
                          fontSize: 15.5,
                          height: 1.85,
                          color: kDarkColor.withOpacity(0.82),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 18),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, "/contact");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          minimumSize: const Size(double.infinity, 52),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w900),
                        ),
                        child: const Text("Contacter SOMA"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ======================= UI =======================

class _SearchFilterBar extends StatelessWidget {
  const _SearchFilterBar({
    required this.query,
    required this.categories,
    required this.currentCategory,
    required this.onQueryChanged,
    required this.onCategoryChanged,
  });

  final String query;
  final List<String> categories;
  final String currentCategory;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<String> onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 720;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: isSmall
          ? Column(
              children: [
                _SearchField(value: query, onChanged: onQueryChanged),
                const SizedBox(height: 12),
                _CategoryDropdown(
                  categories: categories,
                  value: currentCategory,
                  onChanged: onCategoryChanged,
                ),
              ],
            )
          : Row(
              children: [
                Expanded(child: _SearchField(value: query, onChanged: onQueryChanged)),
                const SizedBox(width: 12),
                SizedBox(
                  width: 260,
                  child: _CategoryDropdown(
                    categories: categories,
                    value: currentCategory,
                    onChanged: onCategoryChanged,
                  ),
                ),
              ],
            ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: GoogleFonts.inter(color: kDarkColor, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: "Rechercher un article…",
        hintStyle: GoogleFonts.inter(color: kTextLight, fontWeight: FontWeight.w600),
        prefixIcon: Icon(Icons.search, color: kPrimaryColor.withOpacity(0.85)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kPrimaryColor.withOpacity(0.45), width: 1.3),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}

class _CategoryDropdown extends StatelessWidget {
  const _CategoryDropdown({
    required this.categories,
    required this.value,
    required this.onChanged,
  });

  final List<String> categories;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      items: categories
          .map(
            (c) => DropdownMenuItem(
              value: c,
              child: Text(c, style: GoogleFonts.inter(fontWeight: FontWeight.w800)),
            ),
          )
          .toList(),
      onChanged: (v) => onChanged(v ?? "Tous"),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.filter_alt_outlined, color: kPrimaryColor.withOpacity(0.85)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kPrimaryColor.withOpacity(0.45), width: 1.3),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}

class _BlogCard extends StatelessWidget {
  const _BlogCard({required this.post, required this.onTap});

  final _BlogPost post;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // ✅ important : flexible en ListView
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: AspectRatio(
                  aspectRatio: 16 / 10,
                  child: Image.asset(
                    post.imageAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: kPrimaryColor.withOpacity(0.08),
                      child: Center(
                        child: Icon(Icons.article_outlined, size: 50, color: kPrimaryColor),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _Chip(text: post.category, primary: true),
                        _Chip(text: post.date),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      post.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w900,
                        color: kDarkColor,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      post.excerpt,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        height: 1.55,
                        fontWeight: FontWeight.w600,
                        color: kDarkColor.withOpacity(0.75),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          "Lire",
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: kPrimaryColor,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(Icons.arrow_forward_rounded, size: 18, color: kPrimaryColor),
                        const Spacer(),
                        Text(
                          post.readTime,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: kTextLight,
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

class _BottomCta extends StatelessWidget {
  const _BottomCta({
    required this.onPrecepteurs,
    required this.onContact,
  });

  final VoidCallback onPrecepteurs;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            kPrimaryColor.withOpacity(0.10),
            kSecondaryColor.withOpacity(0.10),
          ],
        ),
        border: Border.all(color: kPrimaryColor.withOpacity(0.18)),
      ),
      child: LayoutBuilder(builder: (context, c) {
        final compact = c.maxWidth < 640;

        final leading = Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kPrimaryColor.withOpacity(0.22)),
              ),
              child: Icon(Icons.support_agent_rounded, color: kPrimaryColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "Besoin d’un accompagnement ? Contactez SOMA ou découvrez nos précepteurs.",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: kDarkColor,
                  height: 1.35,
                ),
              ),
            ),
          ],
        );

        final buttons = LayoutBuilder(builder: (context, c2) {
          final narrow = c2.maxWidth < 420;

          final precepteurs = SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: onPrecepteurs,
              style: OutlinedButton.styleFrom(
                foregroundColor: kPrimaryColor,
                side: BorderSide(color: kPrimaryColor.withOpacity(0.35)),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                textStyle: GoogleFonts.inter(fontWeight: FontWeight.w900),
              ),
              child: const Text("Précepteurs"),
            ),
          );

          final contact = SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: onContact,
              style: ElevatedButton.styleFrom(
                backgroundColor: kSecondaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                textStyle: GoogleFonts.inter(fontWeight: FontWeight.w900),
              ),
              child: const Text("Contact"),
            ),
          );

          if (narrow) {
            return Column(
              children: [
                precepteurs,
                const SizedBox(height: 10),
                contact,
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: precepteurs),
              const SizedBox(width: 10),
              Expanded(child: contact),
            ],
          );
        });

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              leading,
              const SizedBox(height: 12),
              buttons,
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: leading),
            const SizedBox(width: 12),
            SizedBox(width: 340, child: buttons),
          ],
        );
      }),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.text, this.primary = false});

  final String text;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final bg = primary ? kPrimaryColor.withOpacity(0.12) : const Color(0xFFF1F3F5);
    final fg = primary ? kPrimaryColor : kTextLight;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 11.5,
          fontWeight: FontWeight.w900,
          color: fg,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFF8F9FA),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Aucun article trouvé",
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: kDarkColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Change la recherche ou la catégorie, puis réessaie.",
            style: GoogleFonts.inter(
              fontSize: 13.5,
              height: 1.55,
              fontWeight: FontWeight.w600,
              color: kTextLight,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onReset,
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              textStyle: GoogleFonts.inter(fontWeight: FontWeight.w900),
            ),
            child: const Text("Réinitialiser"),
          ),
        ],
      ),
    );
  }
}

// ======================= MODEL =======================

class _BlogPost {
  final String title;
  final String excerpt;
  final String category;
  final String date;
  final String readTime;
  final String imageAsset;
  final String content;

  const _BlogPost({
    required this.title,
    required this.excerpt,
    required this.category,
    required this.date,
    required this.readTime,
    required this.imageAsset,
    required this.content,
  });
}
