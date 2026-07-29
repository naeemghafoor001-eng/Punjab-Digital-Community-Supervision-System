import 'package:flutter/material.dart';
import 'package:officer_app/core/theme/officer_app_theme.dart';

class OfficerLoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const OfficerLoginScreen({Key? key, required this.onLoginSuccess})
      : super(key: key);

  @override
  State<OfficerLoginScreen> createState() => _OfficerLoginScreenState();
}

class _OfficerLoginScreenState extends State<OfficerLoginScreen> {
  final _usernameController =
      TextEditingController(text: 'tahir.mahmood@ppps.punjab.gov.pk');
  final _passwordController = TextEditingController(text: 'Officer@2026!');
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  void _handleSignIn() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(
          () => _errorMessage = 'Please enter officer username and password.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    setState(() => _isLoading = false);
    widget.onLoginSuccess();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F0),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 14,
                          offset: Offset(0, 4)),
                    ],
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      // Header Banner
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: kGovGreen,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white,
                              child:
                                  Icon(Icons.badge, size: 32, color: kGovGreen),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Punjab Probation and Parole Service',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            const Text(
                              'Home Department, Government of the Punjab',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: kGovGold,
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(30),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Officer Mobile Access Portal',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Body Form
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_errorMessage != null) ...[
                              Text(_errorMessage!,
                                  style: TextStyle(
                                      color: Colors.red.shade800,
                                      fontSize: 11.5)),
                              const SizedBox(height: 12),
                            ],
                            const Text('Username / CNIC / Official Email',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: kTextDark)),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _usernameController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.person_outline,
                                    color: kGovGreen),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Text('Password',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: kTextDark)),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock_outline,
                                    color: kGovGreen),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined),
                                  onPressed: () => setState(() =>
                                      _obscurePassword = !_obscurePassword),
                                ),
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 18),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: kGovGreen),
                                onPressed: _isLoading ? null : _handleSignIn,
                                child: _isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : const Text('Sign In to Officer Portal',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Center(
                              child: Text(
                                '“Access is restricted to authorised PP&PS officers.”',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: kTextMuted,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Raahnuma Officer Portal v1.0.0 — Home Department, Punjab',
                style: TextStyle(fontSize: 11, color: kTextMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
