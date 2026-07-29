import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:web_portal/features/dashboard/screens/district_dashboard_screen.dart';
import 'package:web_portal/core/backend/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();
  runApp(const PDCSSWebPortalApp());
}

class PDCSSWebPortalApp extends StatelessWidget {
  const PDCSSWebPortalApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Raahnuma Management Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        primaryColor: const Color(0xFF0F5A47),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F5A47),
          primary: const Color(0xFF0F5A47),
          secondary: const Color(0xFF157A62),
          brightness: Brightness.light,
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
      ],
      home: const DistrictDashboardScreen(),
    );
  }
}
