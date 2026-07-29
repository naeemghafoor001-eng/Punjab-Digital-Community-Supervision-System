import 'package:flutter/material.dart';
import 'package:officer_app/core/backend/supabase_config.dart';

// ─── Brand Colors ────────────────────────────────────────────────────────────
const Color kGovGreen = Color(0xFF0F5A47); // Official PP&PS Green
const Color kGovGreenDark = Color(0xFF09382C);
const Color kGovGreenMid = Color(0xFF157A62);
const Color kGovGreenLight = Color(0xFF4CAF50);
const Color kGovGreenSurface = Color(0xFFF0F7F4);
const Color kGovGold = Color(0xFFD4AF37);
const Color kGovGoldLight = Color(0xFFFFFBF0);
const Color kGovWhite = Colors.white;
const Color kTextDark = Color(0xFF0F172A);
const Color kTextMuted = Color(0xFF475569);
const Color kTextLight = Color(0xFF64748B);

// ─── Departmental App Bar ───────────────────────────────────────────────────
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
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final hasBackend = SupabaseConfig.hasBackend;

    return Container(
      decoration: const BoxDecoration(
        color: kGovGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              if (Navigator.of(context).canPop()) ...[
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: kGovWhite, size: 18),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32),
                ),
                const SizedBox(width: 4),
              ],
              // PP&PS Logo Container
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: kGovGold, width: 1.5),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2)),
                  ],
                ),
                padding: const EdgeInsets.all(2),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/ppps_logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.account_balance,
                      color: kGovGreen,
                      size: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Titles
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Raahnuma Officer App',
                          style: TextStyle(
                            color: kGovWhite,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.1,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: hasBackend
                                ? const Color(0xFF065F46)
                                : const Color(0xFF92400E),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: hasBackend
                                    ? const Color(0xFF34D399)
                                    : const Color(0xFFFBBF24),
                                width: 0.8),
                          ),
                          child: Text(
                            hasBackend ? 'Connected' : 'Active System',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8.5,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 1),
                    Text(
                      screenTitle,
                      style: const TextStyle(
                        color: Color(0xFFFEE180),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Text(
                      'Punjab Probation & Parole Service · Home Dept, Govt of the Punjab',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 8.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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

// ─── Color & Status Helpers ─────────────────────────────────────────
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
    case 'Non-Compliant':
      return const Color(0xFFC62828);
    default:
      return Colors.grey;
  }
}

// ─── Section Heading Component ─────────────────────────────────────────────
class SectionHeading extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? action;

  const SectionHeading({
    Key? key,
    required this.title,
    required this.icon,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: kGovGreen),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.bold,
              color: kTextDark,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
          if (action != null) ...[
            const SizedBox(width: 8),
            action!,
          ],
        ],
      ),
    );
  }
}
