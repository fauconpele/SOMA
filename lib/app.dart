import 'package:flutter/material.dart';

import 'core/theme.dart';
import 'pages/home_page.dart';
import 'pages/services_page.dart';
import 'pages/blog_page.dart';
import 'pages/about_page.dart';
import 'pages/contact_page.dart';
import 'pages/nos_precepteurs_page.dart';
import 'pages/devenir_precepteur_page.dart';
import 'pages/not_found_page.dart';

class SomaApp extends StatelessWidget {
  const SomaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SOMA',
      debugShowCheckedModeBanner: false,
      theme: buildSomaTheme(),
      routes: {
        '/': (_) => const HomePage(),
        '/services': (_) => const ServicesPage(),
        '/blog': (_) => const BlogPage(),
        '/about': (_) => const AboutPage(),
        '/contact': (_) => const ContactPage(),
        '/nos-precepteurs': (_) => const NosPrecepteursPage(),
        '/devenir-precepteur': (_) => const DevenirPrecepteurPage(),
      },
      onUnknownRoute: (_) => MaterialPageRoute(builder: (_) => const NotFoundPage()),
    );
  }
}
