import 'package:flutter/material.dart';
import 'package:supervisee_app/core/backend/auth_service.dart';
import 'package:supervisee_app/core/theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const LoginScreen({Key? key, required this.onLoginSuccess}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDemoExpanded = true;

  @override
  void initState() {
    super.initState();
    // Default to demo credentials for smooth prototype review
    _emailController.text = AuthService.demoEmail;
    _passwordController.text = AuthService.demoPassword;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _fillDemoCredentials() {
    setState(() {
      _emailController.text = AuthService.demoEmail;
      _passwordController.text = AuthService.demoPassword;
      _errorMessage = null;
    });
  }

  void _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage =
            'Please enter your email/identifier and password.\nبراہِ کرم اپنا ای میل اور پاس ورڈ درج کریں۔';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await AuthService.instance.signIn(
      email: email,
      password: password,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (result.success) {
      if (result.noticeMessage != null) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.info_outline, color: AppTheme.primaryGreen),
                SizedBox(width: 8),
                Text('Notice / اطلاع',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            content: Text(
              result.noticeMessage!,
              style: const TextStyle(fontSize: 13, height: 1.4),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  widget.onLoginSuccess();
                },
                child: const Text('OK / ٹھیک ہے',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      } else {
        widget.onLoginSuccess();
      }
    } else {
      setState(() {
        _errorMessage = result.errorMessage ?? 'Login failed.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              children: [
                // Main Container Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 16,
                        offset: Offset(0, 6),
                      ),
                    ],
                    border:
                        Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                  ),
                  child: Column(
                    children: [
                      // Official PP&PS Header Banner
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: const BoxDecoration(
                          color: AppTheme.primaryGreen,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          children: [
                            // PP&PS Logo Container
                            Container(
                              width: 68,
                              height: 68,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                    color: AppTheme.goldAccent, width: 2),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(3),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/ppps_logo.png',
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.account_balance,
                                    color: AppTheme.primaryGreen,
                                    size: 34,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Punjab Probation and Parole Service',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Home Department, Government of the Punjab',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: Colors.white70,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(28),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: AppTheme.goldAccent.withAlpha(180),
                                    width: 1),
                              ),
                              child: const Text(
                                'Raahnuma Supervisee App',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: AppTheme.goldAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Form Body
                      Padding(
                        padding: const EdgeInsets.all(22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_errorMessage != null) ...[
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF2F2),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: const Color(0xFFFCA5A5)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.error_outline,
                                        color: Colors.red, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _errorMessage!,
                                        style: const TextStyle(
                                          color: Color(0xFF991B1B),
                                          fontSize: 11.5,
                                          height: 1.3,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],

                            // Field 1: Email / Mobile / CNIC Ref
                            const Text(
                              'Email / موبائل / شناختی حوالہ',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textDark,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                hintText:
                                    'demo.supervisee@raahnuma.ppnps.gov.pk',
                                prefixIcon: Icon(Icons.person_outline,
                                    color: AppTheme.primaryGreen),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Field 2: Password
                            const Text(
                              'Password / پاس ورڈ',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textDark,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                hintText: '••••••••',
                                prefixIcon: const Icon(Icons.lock_outline,
                                    color: AppTheme.primaryGreen),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: AppTheme.textMuted,
                                  ),
                                  onPressed: () => setState(() =>
                                      _obscurePassword = !_obscurePassword),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Login Button
                            ElevatedButton(
                              onPressed: _isLoading ? null : _handleLogin,
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : const Text('Login / لاگ ان'),
                            ),
                            const SizedBox(height: 18),

                            // Collapsible Access Helper Card
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0FDF4),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: const Color(0xFFBBF7D0), width: 1),
                              ),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () => setState(() =>
                                        _isDemoExpanded = !_isDemoExpanded),
                                    borderRadius: BorderRadius.circular(12),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 10),
                                      child: Row(
                                        children: [
                                          const Icon(
                                              Icons
                                                  .admin_panel_settings_outlined,
                                              color: AppTheme.primaryGreen,
                                              size: 20),
                                          const SizedBox(width: 8),
                                          const Expanded(
                                            child: Text(
                                              'Access Helper / رسائی رہنما',
                                              style: TextStyle(
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.bold,
                                                color: AppTheme.primaryGreen,
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            _isDemoExpanded
                                                ? Icons.expand_less
                                                : Icons.expand_more,
                                            color: AppTheme.primaryGreen,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (_isDemoExpanded) ...[
                                    const Divider(height: 1),
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Default system access credentials:',
                                            style: TextStyle(
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.w600,
                                              color: AppTheme.textMuted,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          SelectableText(
                                            'Email: ${AuthService.demoEmail}\nPassword: ${AuthService.demoPassword}',
                                            style: const TextStyle(
                                              fontSize: 11.5,
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.textDark,
                                              fontFamily: 'monospace',
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          OutlinedButton.icon(
                                            style: OutlinedButton.styleFrom(
                                              minimumSize: const Size(
                                                  double.infinity, 36),
                                              padding: EdgeInsets.zero,
                                            ),
                                            icon: const Icon(
                                                Icons.auto_fix_high,
                                                size: 16),
                                            label: const Text(
                                              'Fill Credentials / کریڈنشلز لکھیے',
                                              style: TextStyle(fontSize: 11),
                                            ),
                                            onPressed: _fillDemoCredentials,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Privacy Note Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.privacy_tip_outlined,
                          color: Color(0xFF1D4ED8), size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'This app is for supervised probation/parole reporting and rehabilitation support. Access is subject to officer approval.\nیہ ایپ پروبیشن اور پیرول رپورٹنگ کے لیے ہے۔ رسائی افسر کی منظوری سے مشروط ہے۔',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: Color(0xFF1E40AF),
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
