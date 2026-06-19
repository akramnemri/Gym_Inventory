import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ValueNotifier<ThemeData> themeNotifier = ValueNotifier(appThemeData[AppTheme.minimalistDark]!);

enum AppTheme {
  minimalistDark,
  industrialGym,
  energeticSport,
  professionalDashboard,
  neoFuturistic,
}

// Define custom semantic colors or a palette
abstract class AppColors {
  static const Color primaryBlue = Color(0xFF2196F3); // Blue 500
  static const Color primaryDarkBlue = Color(0xFF1976D2); // Blue 700
  static const Color accentCyan = Color(0xFF00BCD4); // Cyan 500
  static const Color accentTeal = Color(0xFF009688); // Teal 500
  static const Color textLight = Colors.white70;
  static const Color textDark = Colors.black87;
  static const Color cardDark = Color(0xFF212121); // Dark Grey 900
  static const Color cardLight = Color(0xFFF5F5F5); // Grey 100
  static const Color backgroundDark = Colors.black;
  static const Color backgroundLight = Colors.white;
  static const Color errorRed = Colors.redAccent;
  static const Color warningOrange = Colors.orangeAccent;
  static const Color successGreen = Colors.greenAccent;
}

final Map<AppTheme, ThemeData> appThemeData = {
  AppTheme.minimalistDark: ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    // Define a consistent font family for the whole theme
    fontFamily: GoogleFonts.poppins().fontFamily, // Changed to Poppins for a modern look

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      foregroundColor: AppColors.accentTeal,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.accentTeal),
      actionsIconTheme: const IconThemeData(color: AppColors.accentTeal),
      titleTextStyle: GoogleFonts.poppins(
        color: AppColors.accentTeal,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardColor: AppColors.cardDark,
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(8), // Add consistent card margin
    ),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryDarkBlue,
      secondary: AppColors.primaryBlue, // Used primaryBlue for secondary for a cohesive blue scheme
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      surface: AppColors.cardDark, // Added surface color for consistency
      onSurface: AppColors.textLight,
      background: AppColors.backgroundDark,
      onBackground: AppColors.textLight,
      error: AppColors.errorRed,
      onError: Colors.white,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).copyWith(
      // Customizing specific text styles
      displayLarge: GoogleFonts.poppins(fontSize: 96, fontWeight: FontWeight.w300, color: AppColors.textLight),
      displayMedium: GoogleFonts.poppins(fontSize: 60, fontWeight: FontWeight.w400, color: AppColors.textLight),
      displaySmall: GoogleFonts.poppins(fontSize: 48, fontWeight: FontWeight.w400, color: AppColors.textLight),
      headlineLarge: GoogleFonts.poppins(fontSize: 34, fontWeight: FontWeight.w500, color: AppColors.textLight),
      headlineMedium: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.textLight), // Often used for titles
      headlineSmall: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.textLight),
      titleLarge: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w500, color: AppColors.textLight),
      titleMedium: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textLight), // Often used for card titles
      titleSmall: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textLight),
      bodyLarge: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textLight),
      bodyMedium: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textLight), // Default body text
      bodySmall: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textLight),
      labelLarge: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textLight), // Used for button text
      labelMedium: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textLight),
      labelSmall: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w400, color: AppColors.textLight),
    ),
    // Define button themes for consistency
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primaryDarkBlue,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryBlue,
        textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryBlue,
        side: const BorderSide(color: AppColors.primaryBlue),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[800],
      labelStyle: GoogleFonts.poppins(color: AppColors.textLight.withOpacity(0.8)),
      hintStyle: GoogleFonts.poppins(color: AppColors.textLight.withOpacity(0.5)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.errorRed, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.errorRed, width: 2),
      ),
    ),
  ),
  AppTheme.industrialGym: ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.grey[850]!, // Slightly darker background for industrial feel
    fontFamily: GoogleFonts.montserrat().fontFamily, // Bold, industrial font
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[850],
      foregroundColor: Colors.yellowAccent,
      elevation: 1,
      iconTheme: const IconThemeData(color: Colors.yellowAccent),
      actionsIconTheme: const IconThemeData(color: Colors.yellowAccent),
      titleTextStyle: GoogleFonts.montserrat(
        color: Colors.yellowAccent,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardColor: Colors.grey[700],
    cardTheme: CardThemeData(
      elevation: 5, // Increased elevation for a more rugged, shadowed look
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4), // Sharper corners for industrial vibe
        side: BorderSide(color: Colors.grey[500]!, width: 1), // Metal-like border
      ),
      margin: const EdgeInsets.all(8),
    ),
    colorScheme: ColorScheme.dark(
      primary: Colors.blueGrey[800]!, // Subtle, metallic primary
      secondary: Colors.yellow[700]!, // Energetic accent for gym vibe
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      surface: Colors.grey[700]!,
      onSurface: Colors.white, // Changed to full white for better clarity
      background: Colors.grey[850]!,
      onBackground: Colors.white, // Changed to full white for better clarity
      error: Colors.red[400]!,
      onError: Colors.white,
    ),
    textTheme: GoogleFonts.montserratTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.montserrat(fontSize: 96, fontWeight: FontWeight.w300, color: Colors.white),
      displayMedium: GoogleFonts.montserrat(fontSize: 60, fontWeight: FontWeight.w400, color: Colors.white),
      displaySmall: GoogleFonts.montserrat(fontSize: 48, fontWeight: FontWeight.w400, color: Colors.white),
      headlineLarge: GoogleFonts.montserrat(fontSize: 34, fontWeight: FontWeight.w500, color: Colors.white),
      headlineMedium: GoogleFonts.montserrat(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
      headlineSmall: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
      titleLarge: GoogleFonts.montserrat(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
      titleMedium: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
      titleSmall: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
      bodyLarge: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
      bodyMedium: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white),
      bodySmall: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white),
      labelLarge: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
      labelMedium: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
      labelSmall: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.w400, color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.yellow[700],
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        textStyle: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.yellowAccent,
        textStyle: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.yellowAccent,
        side: BorderSide(color: Colors.yellow[700]!, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        textStyle: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[750],
      labelStyle: GoogleFonts.montserrat(color: Colors.white),
      hintStyle: GoogleFonts.montserrat(color: Colors.white70),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: Colors.yellow[700]!, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    ),
  ),
  AppTheme.energeticSport: ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    fontFamily: GoogleFonts.roboto().fontFamily, // Dynamic, energetic font
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundLight,
      foregroundColor: Colors.red,
      elevation: 0.5,
      iconTheme: const IconThemeData(color: Colors.red),
      actionsIconTheme: const IconThemeData(color: Colors.red),
      titleTextStyle: GoogleFonts.roboto(
        color: Colors.red,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardColor: AppColors.cardLight,
    cardTheme: CardThemeData(
      elevation: 4, // Higher elevation for dynamic, energetic feel
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Softer, rounded for sporty vibe
        side: BorderSide(color: Colors.red.withOpacity(0.2), width: 1), // Subtle energetic border
      ),
      margin: const EdgeInsets.all(8),
    ),
    colorScheme: const ColorScheme.light(
      primary: Colors.red,
      secondary: Colors.black,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      surface: AppColors.cardLight,
      onSurface: AppColors.textDark,
      background: AppColors.backgroundLight,
      onBackground: AppColors.textDark,
      error: AppColors.errorRed,
      onError: Colors.white,
    ),
    textTheme: GoogleFonts.robotoTextTheme(ThemeData.light().textTheme).copyWith(
      displayLarge: GoogleFonts.roboto(fontSize: 96, fontWeight: FontWeight.w300, color: AppColors.textDark),
      displayMedium: GoogleFonts.roboto(fontSize: 60, fontWeight: FontWeight.w400, color: AppColors.textDark),
      displaySmall: GoogleFonts.roboto(fontSize: 48, fontWeight: FontWeight.w400, color: AppColors.textDark),
      headlineLarge: GoogleFonts.roboto(fontSize: 34, fontWeight: FontWeight.w500, color: AppColors.textDark),
      headlineMedium: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.textDark),
      headlineSmall: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.textDark),
      titleLarge: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.w500, color: AppColors.textDark),
      titleMedium: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark),
      titleSmall: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark),
      bodyLarge: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textDark),
      bodyMedium: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textDark),
      bodySmall: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textDark),
      labelLarge: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark),
      labelMedium: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textDark),
      labelSmall: GoogleFonts.roboto(fontSize: 10, fontWeight: FontWeight.w400, color: AppColors.textDark),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.red,
        textStyle: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.red,
        side: const BorderSide(color: Colors.red),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[200],
      labelStyle: GoogleFonts.roboto(color: AppColors.textDark.withOpacity(0.8)),
      hintStyle: GoogleFonts.roboto(color: AppColors.textDark.withOpacity(0.5)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.errorRed, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.errorRed, width: 2),
      ),
    ),
  ),
  AppTheme.professionalDashboard: ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    fontFamily: GoogleFonts.openSans().fontFamily, // Clean, professional font
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundLight,
      foregroundColor: Colors.teal,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.teal),
      actionsIconTheme: const IconThemeData(color: Colors.teal),
      titleTextStyle: GoogleFonts.openSans(
        color: Colors.teal,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardColor: AppColors.cardLight,
    cardTheme: CardThemeData(
      elevation: 1, // Subtle elevation for professional, clean look
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4), // Minimal radius for straightforward design
        side: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1), // Very subtle border
      ),
      margin: const EdgeInsets.all(8),
    ),
    colorScheme: ColorScheme.light(
      primary: Colors.teal,
      secondary: Colors.blue[900]!,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      surface: AppColors.cardLight,
      onSurface: AppColors.textDark,
      background: AppColors.backgroundLight,
      onBackground: AppColors.textDark,
      error: AppColors.errorRed,
      onError: Colors.white,
    ),
    textTheme: GoogleFonts.openSansTextTheme(ThemeData.light().textTheme).copyWith(
      displayLarge: GoogleFonts.openSans(fontSize: 96, fontWeight: FontWeight.w300, color: AppColors.textDark),
      displayMedium: GoogleFonts.openSans(fontSize: 60, fontWeight: FontWeight.w400, color: AppColors.textDark),
      displaySmall: GoogleFonts.openSans(fontSize: 48, fontWeight: FontWeight.w400, color: AppColors.textDark),
      headlineLarge: GoogleFonts.openSans(fontSize: 34, fontWeight: FontWeight.w500, color: AppColors.textDark),
      headlineMedium: GoogleFonts.openSans(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.textDark),
      headlineSmall: GoogleFonts.openSans(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.textDark),
      titleLarge: GoogleFonts.openSans(fontSize: 22, fontWeight: FontWeight.w500, color: AppColors.textDark),
      titleMedium: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark),
      titleSmall: GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark),
      bodyLarge: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textDark),
      bodyMedium: GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textDark),
      bodySmall: GoogleFonts.openSans(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textDark),
      labelLarge: GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark),
      labelMedium: GoogleFonts.openSans(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textDark),
      labelSmall: GoogleFonts.openSans(fontSize: 10, fontWeight: FontWeight.w400, color: AppColors.textDark),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        textStyle: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.teal,
        textStyle: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.teal,
        side: const BorderSide(color: Colors.teal),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        textStyle: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[200],
      labelStyle: GoogleFonts.openSans(color: AppColors.textDark.withOpacity(0.8)),
      hintStyle: GoogleFonts.openSans(color: AppColors.textDark.withOpacity(0.5)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.teal, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: AppColors.errorRed, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: AppColors.errorRed, width: 2),
      ),
    ),
  ),
  AppTheme.neoFuturistic: ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    fontFamily: GoogleFonts.rajdhani().fontFamily, // Futuristic font
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      foregroundColor: Colors.purpleAccent,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.purpleAccent),
      actionsIconTheme: const IconThemeData(color: Colors.purpleAccent),
      titleTextStyle: GoogleFonts.rajdhani(
        color: Colors.purpleAccent,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardColor: Colors.grey[900]?.withOpacity(0.8), // Slightly transparent card
    cardTheme: CardThemeData(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.purpleAccent.withOpacity(0.3), width: 0.5), // Subtle border
      ),
      margin: const EdgeInsets.all(10),
    ),
    colorScheme: ColorScheme.dark(
      primary: Colors.purple[700]!, // Deeper purple
      secondary: Colors.cyanAccent, // Brighter cyan
      tertiary: Colors.lightGreenAccent, // Brighter green for tertiary
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      surface: Colors.grey[850]!.withOpacity(0.9), // Slightly different surface
      onSurface: Colors.white, // Brighter text on surface
      background: AppColors.backgroundDark,
      onBackground: Colors.white,
      error: AppColors.errorRed,
      onError: Colors.white,
    ),
    textTheme: GoogleFonts.rajdhaniTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.rajdhani(fontSize: 96, fontWeight: FontWeight.w300, color: Colors.white),
      displayMedium: GoogleFonts.rajdhani(fontSize: 60, fontWeight: FontWeight.w400, color: Colors.white),
      displaySmall: GoogleFonts.rajdhani(fontSize: 48, fontWeight: FontWeight.w400, color: Colors.white),
      headlineLarge: GoogleFonts.rajdhani(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
      headlineMedium: GoogleFonts.rajdhani(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
      headlineSmall: GoogleFonts.rajdhani(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
      titleLarge: GoogleFonts.rajdhani(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
      titleMedium: GoogleFonts.rajdhani(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
      titleSmall: GoogleFonts.rajdhani(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
      bodyLarge: GoogleFonts.rajdhani(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
      bodyMedium: GoogleFonts.rajdhani(fontSize: 15, color: Colors.white.withOpacity(0.8)),
      bodySmall: GoogleFonts.rajdhani(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white),
      labelLarge: GoogleFonts.rajdhani(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
      labelMedium: GoogleFonts.rajdhani(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
      labelSmall: GoogleFonts.rajdhani(fontSize: 10, fontWeight: FontWeight.w400, color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.cyanAccent, // Secondary color for buttons
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.rajdhani(fontSize: 18, fontWeight: FontWeight.bold),
        elevation: 8,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.purpleAccent,
        textStyle: GoogleFonts.rajdhani(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.purpleAccent,
        side: BorderSide(color: Colors.cyanAccent, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.rajdhani(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[800]?.withOpacity(0.7),
      labelStyle: GoogleFonts.rajdhani(color: Colors.white.withOpacity(0.9), fontSize: 16),
      hintStyle: GoogleFonts.rajdhani(color: Colors.white.withOpacity(0.6), fontSize: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.purpleAccent.withOpacity(0.5), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.cyanAccent, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.purpleAccent.withOpacity(0.5), width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.errorRed, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.errorRed, width: 2),
      ),
    ),
    extensions: <ThemeExtension<dynamic>>[
      CustomThemeExtension(
        backgroundGradient: LinearGradient(
          colors: [
            Colors.black,
            Colors.indigo[900]!.withOpacity(0.7), // Slightly transparent for a "glowing" effect
            Colors.black
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ],
  ),
};

class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  final Gradient? backgroundGradient;
  // You can add more custom properties here, e.g.,
  // final BorderRadius? cardBorderRadius;
  // final BoxShadow? customShadow;

  CustomThemeExtension({
    this.backgroundGradient,
    // this.cardBorderRadius,
    // this.customShadow,
  });

  @override
  ThemeExtension<CustomThemeExtension> copyWith({
    Gradient? backgroundGradient,
    // BorderRadius? cardBorderRadius,
    // BoxShadow? customShadow,
  }) {
    return CustomThemeExtension(
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      // cardBorderRadius: cardBorderRadius ?? this.cardBorderRadius,
      // customShadow: customShadow ?? this.customShadow,
    );
  }

  @override
  ThemeExtension<CustomThemeExtension> lerp(
      ThemeExtension<CustomThemeExtension>? other, double t) {
    if (other is! CustomThemeExtension) return this;
    return CustomThemeExtension(
      backgroundGradient: Gradient.lerp(backgroundGradient, other.backgroundGradient, t),
      // cardBorderRadius: BorderRadius.lerp(cardBorderRadius, other.cardBorderRadius, t),
      // customShadow: BoxShadow.lerp(customShadow, other.customShadow, t),
    );
  }
}

class AppLogo extends StatelessWidget {
  final bool withText;
  final double height;
  final Color? color; // Added an optional color parameter

  const AppLogo({super.key, this.withText = false, this.height = 40, this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    String assetPath;
    if (withText) {
      assetPath = isDark ? 'assets/images/t-rex +logo white.png' : 'assets/images/t-rex +logo black.png';
    } else {
      assetPath = isDark ? 'assets/images/logo white.png' : 'assets/images/logo black.png';
    }

    Widget logo = Image.asset(assetPath, height: height);

    if (color != null) {
      logo = ColorFiltered(
        colorFilter: ColorFilter.mode(color!, BlendMode.srcIn),
        child: logo,
      );
    }

    return logo;
  }
}