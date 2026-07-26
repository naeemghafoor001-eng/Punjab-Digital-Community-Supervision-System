import 'package:flutter/material.dart';
import 'package:supervisee_app/core/theme/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supervisee_app/features/home/screens/home_screen.dart';

import 'package:supervisee_app/core/backend/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();
  runApp(const PDCSSSuperviseeApp());
}

class PDCSSSuperviseeApp extends StatelessWidget {
  const PDCSSSuperviseeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Raahnuma Supervisee App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ur', 'PK'),
      ],
      home: const HomeScreen(),
    );
  }
}
