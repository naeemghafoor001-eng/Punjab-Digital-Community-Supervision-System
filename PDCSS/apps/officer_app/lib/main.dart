import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:officer_app/core/theme/officer_app_theme.dart';
import 'package:officer_app/features/home/screens/officer_home_screen.dart';

import 'package:officer_app/core/backend/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();
  runApp(const PDCSSOfficerApp());
}

class PDCSSOfficerApp extends StatelessWidget {
  const PDCSSOfficerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Punjab Probation and Parole Service',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF1F5F0),
        primaryColor: kGovGreen,
        colorScheme: ColorScheme.fromSeed(
          seedColor: kGovGreen,
          primary: kGovGreen,
          secondary: kGovGreenMid,
          surface: kGovWhite,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: kGovGreen,
          foregroundColor: kGovWhite,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          color: kGovWhite,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.grey.shade200),
          ),
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
      home: const OfficerHomeScreen(),
    );
  }
}
