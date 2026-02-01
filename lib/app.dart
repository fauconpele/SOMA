import 'package:flutter/material.dart';

import 'core/auth_guard.dart';
import 'core/theme.dart';

import 'pages/home_page.dart';
import 'pages/services_page.dart';
import 'pages/blog_page.dart';
import 'pages/about_page.dart';
import 'pages/contact_page.dart';
import 'pages/nos_precepteurs_page.dart';
import 'pages/devenir_precepteur_page.dart';
import 'pages/not_found_page.dart';

import 'pages/auth/login_page.dart';
import 'pages/auth/signup_page.dart';

import 'pages/dashboard_page.dart';
import 'pages/students/student_list_page.dart';
import 'pages/students/add_student_page.dart';

class SomaApp extends StatelessWidget {
  const SomaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SOMA',
      debugShowCheckedModeBanner: false,
      theme: buildSomaTheme(),
      routes: {
        // ✅ PUBLIC
        '/': (_) => const HomePage(),
        '/services': (_) => const ServicesPage(),
        '/blog': (_) => const BlogPage(),
        '/about': (_) => const AboutPage(),
        '/contact': (_) => const ContactPage(),
        '/nos-precepteurs': (_) => const NosPrecepteursPage(),
        '/devenir-precepteur': (_) => const DevenirPrecepteurPage(),

        // ✅ AUTH
        '/login': (_) => const LoginPage(),
        '/signup': (_) => const SignupPage(),

        // ✅ PROTÉGÉ
        '/dashboard': (_) => AuthGuard(child: const DashboardPage()),
        '/students': (_) => AuthGuard(child: const StudentListPage()),
        '/students/add': (_) => AuthGuard(child: const AddStudentPage()),
      },
      onUnknownRoute: (_) => MaterialPageRoute(builder: (_) => const NotFoundPage()),
    );
  }
}
