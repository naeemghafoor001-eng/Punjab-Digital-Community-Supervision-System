import 'package:flutter/material.dart';

// ─── Brand colours ──────────────────────────────────────────────────────────
const Color kGovGreen = Color(0xFF1B5E20);
const Color kGovGreenMid = Color(0xFF2E7D32);
const Color kGovGreenLight = Color(0xFF4CAF50);
const Color kGovGreenSurface = Color(0xFFE8F5E9);
const Color kGovGold = Color(0xFFF9A825);
const Color kGovWhite = Colors.white;
const Color kTextDark = Color(0xFF0F172A);
const Color kTextMuted = Color(0xFF64748B);

// ─── Shared app bar ─────────────────────────────────────────────────────────
/// Compact departmental header for use as AppBar.
/// Shows PP&PS logo, department name, and an optional trailing widget.
class DepartmentalAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String screenTitle;
  final Widget? trailing;

  const DepartmentalAppBar({
    Key? key,
    required this.screenTitle,
    this.trailing,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [kGovGreen, kGovGreenMid],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              // Back button (if navigator can pop)
              if (Navigator.of(context).canPop())
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: kGovWhite, size: 18),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32),
                ),
              // Logo
              ClipOval(
                child: Image.asset(
                  'assets/images/ppps_logo.png',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: kGovGreenLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.account_balance,
                        color: kGovWhite, size: 22),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Titles
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Raahnuma Officer App',
                      style: TextStyle(
                        color: kGovWhite,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Text(
                      'Punjab Community Supervision System',
                      style: TextStyle(
                          color: Color(0xFFB9F6CA),
                          fontSize: 10,
                          height: 1.2,
                          fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Text(
                          screenTitle,
                          style: const TextStyle(
                              color: Color(0xFF81C784),
                              fontSize: 9,
                              height: 1.2,
                              fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Text(
                          '  |  Punjab Probation & Parole',
                          style: TextStyle(
                              color: Colors.white70, fontSize: 9, height: 1.2),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Colour helpers ──────────────────────────────────────────────────────────
Color riskColor(String risk) {
  switch (risk) {
    case 'High':
      return const Color(0xFFC62828);
    case 'Medium':
      return const Color(0xFFE65100);
    default:
      return const Color(0xFF1565C0);
  }
}

Color statusColor(String status) {
  switch (status) {
    case 'Compliant':
      return kGovGreenMid;
    case 'Overdue':
      return const Color(0xFFE65100);
    case 'Violation':
      return const Color(0xFFC62828);
    default:
      return Colors.grey;
  }
}

// ─── Shared section heading ──────────────────────────────────────────────────
class SectionHeading extends StatelessWidget {
  final String title;
  final IconData icon;
  const SectionHeading({Key? key, required this.title, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: kGovGreenMid),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: kTextDark,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
        ],
      ),
    );
  }
}
