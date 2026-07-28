import 'package:flutter/material.dart';

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
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'My Supervision Plan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'میرا نگرانی منصوبہ',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        backgroundColor: kGovGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pro-Social Encouragement Header Banner
            _buildHeaderBanner(),
            const SizedBox(height: 16),

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
              'Rehabilitation Goals & Targets',
              'بحالی کے اہداف',
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
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kGovGreenSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kGovGreenLight.withAlpha(100)),
      ),
      child: Row(
        children: const [
          Icon(Icons.stars, color: kGovGreen, size: 28),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Active Supervision & Rehabilitation Plan',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: kGovGreen),
                ),
                SizedBox(height: 2),
                Text(
                  'فعال نگرانی اور اصلاحی منصوبہ',
                  style: TextStyle(fontSize: 12, color: kTextDark),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Next Plan Review Date / اگلی جائزہ کی تاریخ:',
                    style: TextStyle(fontSize: 12, color: kTextMuted)),
                Text('15 Sept 2026',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: kGovGreen)),
              ],
            ),
            const Divider(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Overall Status / مجموعی صورتحال:',
                    style: TextStyle(fontSize: 12, color: kTextMuted)),
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
                        fontSize: 11,
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
        Icon(icon, color: kGovGreen, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titleEn,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: kTextDark)),
            Text(titleUr,
                style: const TextStyle(fontSize: 11, color: kTextMuted)),
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
          style: TextStyle(fontSize: 12, height: 1.4, color: kTextDark),
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
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: kTextDark)),
                      Text(titleUr,
                          style:
                              const TextStyle(fontSize: 11, color: kTextMuted)),
                    ],
                  ),
                ),
                Chip(
                  label: Text('$statusEn / $statusUr',
                      style: const TextStyle(fontSize: 10, color: kGovGreen)),
                  backgroundColor: kGovGreenSurface,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(targetEn,
                style: const TextStyle(fontSize: 12, color: kTextDark)),
            Text(targetUr,
                style: const TextStyle(fontSize: 11, color: kTextMuted)),
          ],
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
        leading: const CircleAvatar(
          backgroundColor: kGovGreenSurface,
          child: Icon(Icons.business, color: kGovGreen, size: 20),
        ),
        title: Text('$agencyEn / $agencyUr',
            style:
                const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
        subtitle: Text('$serviceEn / $serviceUr',
            style: const TextStyle(fontSize: 11, color: kTextMuted)),
      ),
    );
  }
}
