import 'package:flutter/material.dart';

const kBrandName = 'SOMA';

// Assets
const kLogoAsset = 'assets/images/logo_soma.png';
const kLogoWhiteAsset = 'assets/images/logo_soma_white.png';
const kHeroVideoAsset = 'assets/videos/hero_bg.mp4';

// Colors
const kPrimaryColor = Color(0xFF4A6FA5);
const kSecondaryColor = Color(0xFF6ECB63);
const kAccentColor = Color(0xFFFFC107);
const kDarkColor = Color(0xFF1A1F37);
const kLightColor = Color(0xFFF8F9FA);

const kTextDark = Color(0xFF111827);
const kTextLight = Color(0xFF6B7280);

bool isSmallScreen(BuildContext context) => MediaQuery.of(context).size.width < 900;
bool isMediumScreen(BuildContext context) => MediaQuery.of(context).size.width < 1000;

double adaptiveRadius(BuildContext context) {
  final w = MediaQuery.of(context).size.width;
  if (w < 600) return 14;
  if (w < 1000) return 16;
  return 18;
}
