import 'package:flutter/material.dart';
import 'package:supervisee_app/core/backend/supabase_config.dart';

const Color kGovGreen = Color(0xFF0F5A47);
const Color kGovGreenLight = Color(0xFF4CAF50);
const Color kGovGreenSurface = Color(0xFFF0F7F4);
const Color kTextDark = Color(0xFF0F172A);
const Color kTextMuted = Color(0xFF64748B);

class SupervisionPlanScreen extends StatelessWidget {
  const SupervisionPlanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(128),
        child: _PlanHeader(
          title: 'My Supervision Plan',
          urduTitle: 'میرا نگرانی منصوبہ',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pro-Social Encouragement Header Banner
            _buildHeaderBanner(),
            const SizedBox(height: 14),

            // Plan Overview Card (Next Review Date & Progress Status)
            _buildOverviewCard(),
            const SizedBox(height: 16),

            // Officer Instructions
            _buildSectionHeader(
              'Officer Supervision Instructions',
              'نگرانی افسر کی ہدایات',
              Icons.format_quote,
            ),
            const SizedBox(height: 8),
            _buildInstructionsCard(),
            const SizedBox(height: 18),

            // Pro-Social Rehabilitation Goals
            _buildSectionHeader(
              'Supervision Goals & Rehabilitation Targets',
              'بحالی اور نگہداشت کے اہداف',
              Icons.track_changes,
            ),
            const SizedBox(height: 8),
            _buildGoalCard(
              titleEn: 'Vocational Skill Qualification (Electrician)',
              titleUr: 'تکنیکی ہنر کا حصول (الیکٹریشن)',
              targetEn:
                  'Complete 3-month TEVTA electrical certificate by Sept 2026.',
              targetUr:
                  'سپٹمبر 2026 تک 3 ماہ کا TEVTA الیکٹریکل سرٹیفکیٹ مکمل کریں۔',
              statusEn: 'In Progress',
              statusUr: 'جاری ہے',
            ),
            _buildGoalCard(
              titleEn: 'Social & Personal Development',
              titleUr: 'معاشرتی اور ذاتی ترقی',
              targetEn:
                  'Maintain positive family interaction and monthly counselling.',
              targetUr: 'مثبت خاندانی تعلقات اور ماہانہ مشاورت برقرار رکھیں۔',
              statusEn: 'In Progress',
              statusUr: 'جاری ہے',
            ),
            _buildGoalCard(
              titleEn: 'Community Engagement & Discipline',
              titleUr: 'معاشرتی انضمام اور نظم و ضبط',
              targetEn:
                  'Punctual attendance at assigned civic activities and office reporting.',
              targetUr:
                  'مقررہ کمیونٹی اور دفتری سرگرمیوں میں باقاعدگی سے شرکت۔',
              statusEn: 'Compliant',
              statusUr: 'تعمیل شدہ',
            ),
            const SizedBox(height: 18),

            // Assigned Activities Overview
            _buildSectionHeader(
              'Assigned Rehabilitation Activities',
              'تفویض کردہ بحالی سرگرمیاں',
              Icons.assignment_outlined,
            ),
            const SizedBox(height: 8),
            _buildAssignedActivityOverviewTile(
              titleEn: 'TEVTA Vocational Skills Training',
              titleUr: 'ٹیوٹا فنی تربیت سیشن',
              scheduleEn: 'Weekly - Every Wednesday at 02:00 PM',
              statusEn: 'Active',
            ),
            _buildAssignedActivityOverviewTile(
              titleEn: 'Bi-weekly Probation Office Reporting',
              titleUr: 'دفتری حاضری جائزہ',
              scheduleEn: 'Bi-Weekly - Alternate Tuesdays at 10:00 AM',
              statusEn: 'Active',
            ),
            _buildAssignedActivityOverviewTile(
              titleEn: 'Rehabilitation & Wellness Counselling',
              titleUr: 'بحالی و مشاورت سیشن',
              scheduleEn: 'Monthly - 3rd Thursday at 11:00 AM',
              statusEn: 'Active',
            ),
            const SizedBox(height: 18),

            // Active Rehabilitation Referrals
            _buildSectionHeader(
              'Rehabilitation Referrals',
              'بحالی کے ریفرلز',
              Icons.medical_services_outlined,
            ),
            const SizedBox(height: 8),
            _buildReferralCard(
              agencyEn: 'TEVTA Vocational Center Lahore',
              agencyUr: 'ٹیوٹا ووکیشنل سینٹر لاہور',
              serviceEn: 'Technical & Trade Electrician Course',
              serviceUr: 'تکنیکی اور تجارتی الیکٹریشن کورس',
            ),
            _buildReferralCard(
              agencyEn: 'District Guidance & Counselling Support',
              agencyUr: 'ضلعی رہنمائی اور مشاورت کی معاونت',
              serviceEn: 'Community Integration Counselling',
              serviceUr: 'معاشرتی انضمام کے لیے مشاورت',
            ),
            const SizedBox(height: 16),

            const _PlanFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kGovGreenSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kGovGreenLight.withAlpha(100)),
      ),
      child: Row(
        children: const [
          Icon(Icons.stars, color: kGovGreen, size: 26),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Active Supervision & Rehabilitation Plan',
                  style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: kGovGreen),
                ),
                SizedBox(height: 2),
                Text(
                  'فعال نگرانی اور اصلاحی منصوبہ',
                  style: TextStyle(fontSize: 11.5, color: kTextDark),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Next Plan Review Date / اگلی جائزہ کی تاریخ:',
                    style: TextStyle(fontSize: 11.5, color: kTextMuted)),
                Text('15 Sept 2026',
                    style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: kGovGreen)),
              ],
            ),
            const Divider(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Progress Status / مجموعی صورتحال:',
                    style: TextStyle(fontSize: 11.5, color: kTextMuted)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: kGovGreenSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kGovGreen),
                  ),
                  child: const Text(
                    'Active / فعال',
                    style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: kGovGreen),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String titleEn, String titleUr, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: kGovGreen, size: 18),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titleEn,
                style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: kTextDark)),
            Text(titleUr,
                style: const TextStyle(fontSize: 10.5, color: kTextMuted)),
          ],
        ),
      ],
    );
  }

  Widget _buildInstructionsCard() {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: const Padding(
        padding: EdgeInsets.all(14),
        child: Text(
          '“Maintain regular attendance at TEVTA vocational electrician classes every week. Continue bi-weekly reporting at Lahore Central Office and participate in voluntary personal discipline activities.”\n\n'
          '“ہر ہفتے ٹیوٹا ووکیشنل کلاسز میں باقاعدگی سے شرکت برقرار رکھیں۔ لاھور سینٹرل آفس میں دو ہفتہ وار حاضری دیں اور منظور شدہ اصلاحی سرگرمیوں میں حصہ لیں۔”',
          style: TextStyle(fontSize: 11.5, height: 1.4, color: kTextDark),
        ),
      ),
    );
  }

  Widget _buildGoalCard({
    required String titleEn,
    required String titleUr,
    required String targetEn,
    required String targetUr,
    required String statusEn,
    required String statusUr,
  }) {
    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(titleEn,
                          style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              color: kTextDark)),
                      Text(titleUr,
                          style: const TextStyle(
                              fontSize: 10.5, color: kTextMuted)),
                    ],
                  ),
                ),
                Chip(
                  label: Text('$statusEn / $statusUr',
                      style: const TextStyle(fontSize: 9.5, color: kGovGreen)),
                  backgroundColor: kGovGreenSurface,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(targetEn,
                style: const TextStyle(fontSize: 11.5, color: kTextDark)),
            Text(targetUr,
                style: const TextStyle(fontSize: 10.5, color: kTextMuted)),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignedActivityOverviewTile({
    required String titleEn,
    required String titleUr,
    required String scheduleEn,
    required String statusEn,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        leading: const CircleAvatar(
          backgroundColor: kGovGreenSurface,
          radius: 16,
          child: Icon(Icons.check_circle_outline, color: kGovGreen, size: 18),
        ),
        title: Text(titleEn,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        subtitle: Text('$titleUr\n$scheduleEn',
            style: const TextStyle(fontSize: 10.5, color: kTextMuted)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: kGovGreenSurface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            statusEn,
            style: const TextStyle(
                fontSize: 9.5, color: kGovGreen, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildReferralCard({
    required String agencyEn,
    required String agencyUr,
    required String serviceEn,
    required String serviceUr,
  }) {
    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        leading: const CircleAvatar(
          backgroundColor: kGovGreenSurface,
          radius: 16,
          child: Icon(Icons.business, color: kGovGreen, size: 18),
        ),
        title: Text('$agencyEn / $agencyUr',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        subtitle: Text('$serviceEn / $serviceUr',
            style: const TextStyle(fontSize: 10.5, color: kTextMuted)),
      ),
    );
  }
}

class _PlanHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String urduTitle;

  const _PlanHeader({
    Key? key,
    required this.title,
    required this.urduTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasBackend = SupabaseConfig.hasBackend;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0F5A47),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 12,
        left: 16,
        right: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(2),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/ppps_logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.account_balance,
                      color: Color(0xFF0F5A47),
                      size: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Punjab Probation and Parole Service',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Home Department, Government of the Punjab',
                      style: TextStyle(
                        fontSize: 9.5,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: hasBackend
                      ? const Color(0xFF065F46)
                      : const Color(0xFF92400E),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  hasBackend ? 'Online' : 'Demo Mode',
                  style: const TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white24, height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                urduTitle,
                style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(128);
}

class _PlanFooter extends StatelessWidget {
  const _PlanFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Divider(),
        SizedBox(height: 4),
        Text(
          'Public prototype using fictional records for review and presentation purposes.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10.5,
            color: Colors.black54,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          'یہ ریویو اور پریزنٹیشن کے مقاصد کے لیے فرضی ریکارڈز کے ساتھ ایک نمونہ انٹرفیس ہے۔',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 9.5,
            color: Colors.black54,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
