import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String url = String.fromEnvironment('SUPABASE_URL');
  static const String anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static bool _hasBackend = false;
  static bool get hasBackend => _hasBackend;

  static Future<void> initialize() async {
    if (url.isEmpty || anonKey.isEmpty) {
      _hasBackend = false;
      return;
    }

    try {
      await Supabase.initialize(
        url: url,
        publishableKey: anonKey,
      );
      _hasBackend = true;
    } catch (e) {
      _hasBackend = false;
    }
  }
}
