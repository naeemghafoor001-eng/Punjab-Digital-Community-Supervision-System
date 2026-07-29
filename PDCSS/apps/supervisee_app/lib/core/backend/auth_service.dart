import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supervisee_app/core/backend/supabase_config.dart';
import 'package:supervisee_app/core/backend/models.dart';
import 'package:supervisee_app/core/backend/demo_fallback_service.dart';

class AuthResult {
  final bool success;
  final String? errorMessage;
  final String? noticeMessage;

  AuthResult({
    required this.success,
    this.errorMessage,
    this.noticeMessage,
  });
}

class AuthService {
  static final AuthService instance = AuthService._();
  AuthService._();

  static const bool enableSuperviseeLogin =
      bool.fromEnvironment('ENABLE_SUPERVISEE_LOGIN', defaultValue: false);

  bool _isLoggedIn = false;
  SuperviseeProfile? _currentProfile;
  String? _profileNoticeMessage;

  bool get isLoggedIn => !enableSuperviseeLogin || _isLoggedIn;
  SuperviseeProfile? get currentProfile =>
      _currentProfile ?? SuperviseeProfile.fallback();
  String? get profileNoticeMessage =>
      enableSuperviseeLogin ? _profileNoticeMessage : null;

  static const String demoEmail = 'demo.supervisee@raahnuma.ppnps.gov.pk';
  static const String demoPassword = 'demo12345';

  Future<void> initialize() async {
    if (!enableSuperviseeLogin) {
      _isLoggedIn = true;
      _currentProfile = await DemoFallbackService.instance.getProfile();
      _profileNoticeMessage = null;
      return;
    }

    if (!SupabaseConfig.hasBackend) {
      _isLoggedIn = false;
      _currentProfile = null;
      return;
    }

    try {
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        _isLoggedIn = true;
        final hasProfile = await _fetchProfileForUser(session.user.id);
        if (!hasProfile) {
          _currentProfile = await DemoFallbackService.instance.getProfile();
          _profileNoticeMessage =
              'Login successful, but no supervisee profile has been linked with this account. Please contact your assigned officer.';
        }
      } else {
        _isLoggedIn = false;
        _currentProfile = null;
      }
    } catch (_) {
      _isLoggedIn = false;
      _currentProfile = null;
    }
  }

  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim();
    final cleanPassword = password.trim();

    final isDemoCreds =
        cleanEmail.toLowerCase() == demoEmail && cleanPassword == demoPassword;

    if (SupabaseConfig.hasBackend) {
      try {
        final res = await Supabase.instance.client.auth.signInWithPassword(
          email: cleanEmail,
          password: cleanPassword,
        );

        if (res.user != null) {
          _isLoggedIn = true;
          final hasProfile = await _fetchProfileForUser(res.user!.id);
          if (!hasProfile) {
            _profileNoticeMessage =
                'Login successful, but no supervisee profile has been linked with this account. Please contact your assigned officer.';
            _currentProfile = await DemoFallbackService.instance.getProfile();
          } else {
            _profileNoticeMessage = null;
          }
          return AuthResult(
            success: true,
            noticeMessage: _profileNoticeMessage,
          );
        }
      } catch (e) {
        if (isDemoCreds) {
          await Future.delayed(const Duration(milliseconds: 300));
          _isLoggedIn = true;
          _currentProfile = await DemoFallbackService.instance.getProfile();
          _profileNoticeMessage = null;
          return AuthResult(success: true);
        }
        return AuthResult(
          success: false,
          errorMessage: _extractErrorMessage(e),
        );
      }
    }

    // Demo / Offline Mode
    await Future.delayed(const Duration(milliseconds: 400));
    if (isDemoCreds) {
      _isLoggedIn = true;
      _currentProfile = await DemoFallbackService.instance.getProfile();
      _profileNoticeMessage = null;
      return AuthResult(success: true);
    }

    return AuthResult(
      success: false,
      errorMessage:
          'Invalid credentials. Please use demo credentials: $demoEmail / $demoPassword\nای میل یا پاس ورڈ غلط ہے۔',
    );
  }

  Future<bool> _fetchProfileForUser(String userId) async {
    try {
      final response = await Supabase.instance.client
          .from('supervisees')
          .select('*, profiles(*), officers(*, profiles(*))')
          .or('profile_id.eq.$userId,id.eq.$userId')
          .limit(1)
          .maybeSingle();

      if (response != null) {
        _currentProfile = SuperviseeProfile.fromMap(response);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<void> signOut() async {
    if (SupabaseConfig.hasBackend) {
      try {
        await Supabase.instance.client.auth.signOut();
      } catch (_) {}
    }
    _isLoggedIn = false;
    _currentProfile = null;
    _profileNoticeMessage = null;
  }

  String _extractErrorMessage(dynamic error) {
    final str = error.toString();
    if (str.contains('Invalid login credentials')) {
      return 'Invalid email or password. / ای میل یا پاس ورڈ غلط ہے۔';
    }
    return str.replaceAll('Exception: ', '').replaceAll('AuthException: ', '');
  }
}
