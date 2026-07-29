import 'package:flutter/material.dart';
import 'package:supervisee_app/core/theme/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supervisee_app/features/home/screens/home_screen.dart';
import 'package:supervisee_app/features/auth/screens/login_screen.dart';
import 'package:supervisee_app/core/backend/supabase_config.dart';
import 'package:supervisee_app/core/backend/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();
  await AuthService.instance.initialize();
  runApp(const PDCSSSuperviseeApp());
}

class PDCSSSuperviseeApp extends StatefulWidget {
  const PDCSSSuperviseeApp({Key? key}) : super(key: key);

  @override
  State<PDCSSSuperviseeApp> createState() => _PDCSSSuperviseeAppState();
}

class _PDCSSSuperviseeAppState extends State<PDCSSSuperviseeApp> {
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
      home: AuthService.instance.isLoggedIn
          ? HomeScreen(
              onLogout: AuthService.enableSuperviseeLogin
                  ? () {
                      setState(() {});
                    }
                  : null,
            )
          : LoginScreen(
              onLoginSuccess: () {
                setState(() {});
              },
            ),
    );
  }
}
