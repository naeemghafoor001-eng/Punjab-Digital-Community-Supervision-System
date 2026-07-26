import 'package:flutter/material.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({Key? key}) : super(key: key);

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  int _currentStep = 0; // 0: Identity, 1: Questions, 2: Review, 3: Receipt

  // Step 1 Checkbox
  bool _identityConfirmed = false;

  // Step 2 Answers
  bool _residingAtAddress = true;
  bool _changedEmployment = false;
  bool _needAssistance = false;
  bool _complyingConditions = true;

  final String _receiptNumber = "PPPS-CI-2026-8941";
  late String _submissionTimestamp;

  @override
  void initState() {
    super.initState();
    _updateTimestamp();
  }

  void _updateTimestamp() {
    final now = DateTime.now();
    // Fictional formatted string: DD Month YYYY at HH:MM
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    final minuteStr = now.minute < 10 ? '0${now.minute}' : '${now.minute}';
    final hourStr = now.hour < 10 ? '0${now.hour}' : '${now.hour}';
    _submissionTimestamp =
        '${now.day} ${months[now.month - 1]} ${now.year} at $hourStr:$minuteStr';
  }

  void _resetFlow() {
    setState(() {
      _currentStep = 0;
      _identityConfirmed = false;
      _residingAtAddress = true;
      _changedEmployment = false;
      _needAssistance = false;
      _complyingConditions = true;
      _updateTimestamp();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _CheckInHeader(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Visual Step Progress Indicator (only if not on receipt step)
            if (_currentStep < 3) ...[
              _buildProgressIndicator(),
              const SizedBox(height: 20),
            ],

            // Step Content Switcher
            if (_currentStep == 0)
              _buildIdentityStep()
            else if (_currentStep == 1)
              _buildQuestionsStep()
            else if (_currentStep == 2)
              _buildReviewStep()
            else
              _buildReceiptStep(),

            // Navigation Buttons (only for steps 1-3)
            if (_currentStep < 3) ...[
              const SizedBox(height: 24),
              Row(
                children: [
                  if (_currentStep > 0) ...[
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() => _currentStep -= 1);
                        },
                        child: const Text('Back / پیچھے'),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isNextDisabled() ? null : _handleNext,
                      child: Text(_currentStep == 2
                          ? 'Submit Check-In / حاضری جمع کریں'
                          : 'Continue / آگے بڑھیں'),
                    ),
                  ),
                ],
              ),
            ],

            // Shared Footer Note
            const _FooterDisclaimer(),
          ],
        ),
      ),
    );
  }

  bool _isNextDisabled() {
    if (_currentStep == 0) {
      return !_identityConfirmed;
    }
    return false;
  }

  void _handleNext() {
    if (_currentStep < 2) {
      setState(() => _currentStep += 1);
    } else if (_currentStep == 2) {
      _updateTimestamp();
      setState(() => _currentStep = 3);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // STEP BUILDERS
  // ─────────────────────────────────────────────────────────────────────────────

  Widget _buildProgressIndicator() {
    return Row(
      children: [
        _buildProgressDot(0, 'Identity / تصدیق'),
        _buildProgressLine(0),
        _buildProgressDot(1, 'Questions / سوالات'),
        _buildProgressLine(1),
        _buildProgressDot(2, 'Review / خلاصہ'),
      ],
    );
  }

  Widget _buildProgressDot(int stepIndex, String label) {
    final isActive = _currentStep >= stepIndex;
    final isCurrent = _currentStep == stepIndex;
    return Expanded(
      child: Column(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor:
                isActive ? const Color(0xFF0F5A47) : Colors.grey.shade300,
            child: isCurrent
                ? const Icon(Icons.circle, size: 8, color: Colors.white)
                : isActive
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : Text(
                        '${stepIndex + 1}',
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54),
                      ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              color: isActive ? const Color(0xFF0F5A47) : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressLine(int fromStep) {
    final isPassed = _currentStep > fromStep;
    return Container(
      width: 30,
      height: 2,
      color: isPassed ? const Color(0xFF0F5A47) : Colors.grey.shade300,
      margin: const EdgeInsets.only(bottom: 16),
    );
  }

  // STEP 1: IDENTITY SCREEN
  Widget _buildIdentityStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Please confirm your identity information below:',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B)),
        ),
        const Text(
          'براہِ کرم نیچے دی گئی اپنی معلومات کی تصدیق کریں:',
          style: TextStyle(fontSize: 13, color: Colors.black54),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildDetailRow(
                    'Supervisee Name / نام', 'Tariq Mehmood / طارق محمود'),
                const Divider(),
                _buildDetailRow(
                    'CNIC / شناختی کارڈ', '35201-xxxxxxx-x (Masked / پوشیدہ)'),
                const Divider(),
                _buildDetailRow('Case Reference / کیس نمبر', 'LHR-2026-089'),
                const Divider(),
                _buildDetailRow('Assigned Officer / پروبیشن افسر',
                    'Officer Tahir Mahmood / افسر طاہر محمود'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Card(
          color: const Color(0xFFF0FDF4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.green, width: 1),
          ),
          child: CheckboxListTile(
            value: _identityConfirmed,
            activeColor: const Color(0xFF0F5A47),
            onChanged: (val) {
              setState(() => _identityConfirmed = val ?? false);
            },
            title: const Text(
              'I confirm that this is my profile and case info.',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F5A47)),
            ),
            subtitle: const Text(
              'میں تصدیق کرتا ہوں کہ یہ میری پروفائل اور کیس کی معلومات ہے۔',
              style: TextStyle(fontSize: 12, color: Colors.black87),
            ),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
      ],
    );
  }

  // STEP 2: QUESTIONS SCREEN
  Widget _buildQuestionsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Supervision Reporting Questions:',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B)),
        ),
        const Text(
          'نگہداشت سے متعلق ضروری سوالات:',
          style: TextStyle(fontSize: 13, color: Colors.black54),
        ),
        const SizedBox(height: 16),
        _buildQuestionCard(
          '1. Are you residing at your approved address?',
          'کیا آپ اپنے منظور شدہ پتہ پر مقیم ہیں؟',
          _residingAtAddress,
          (val) => setState(() => _residingAtAddress = val),
        ),
        _buildQuestionCard(
          '2. Have you changed job/employment?',
          'کیا آپ نے ملازمت تبدیل کی ہے؟',
          _changedEmployment,
          (val) => setState(() => _changedEmployment = val),
        ),
        _buildQuestionCard(
          '3. Do you need any assistance from PP&PS?',
          'کیا آپ کو سروسز سے مدد کی ضرورت ہے؟',
          _needAssistance,
          (val) => setState(() => _needAssistance = val),
        ),
        _buildQuestionCard(
          '4. Are you complying with all supervision rules?',
          'کیا آپ نگرانی کے تمام اصولوں پر عمل کر رہے ہیں؟',
          _complyingConditions,
          (val) => setState(() => _complyingConditions = val),
        ),
      ],
    );
  }

  // STEP 3: REVIEW SCREEN
  Widget _buildReviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Review your answers before submitting:',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B)),
        ),
        const Text(
          'حاضری جمع کرنے سے پہلے اپنے جوابات کا جائزہ لیں:',
          style: TextStyle(fontSize: 13, color: Colors.black54),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Check-In Summary / خلاصہ جوابات',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F5A47),
                  ),
                ),
                const Divider(height: 24),
                _buildReviewRow(
                  'Approved Address? / منظور شدہ پتہ پر ہیں؟',
                  _residingAtAddress ? 'Yes / جی ہاں' : 'No / جی نہیں',
                  _residingAtAddress,
                ),
                const Divider(),
                _buildReviewRow(
                  'Changed Job? / نوکری تبدیل کی ہے؟',
                  _changedEmployment ? 'Yes / جی ہاں' : 'No / جی نہیں',
                  !_changedEmployment, // generally preferred if no job change without notice
                ),
                const Divider(),
                _buildReviewRow(
                  'Need Help? / مدد کی ضرورت ہے؟',
                  _needAssistance ? 'Yes / جی ہاں' : 'No / جی نہیں',
                  true,
                ),
                const Divider(),
                _buildReviewRow(
                  'Following Rules? / قوانین پر عمل ہے؟',
                  _complyingConditions ? 'Yes / جی ہاں' : 'No / جی نہیں',
                  _complyingConditions,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          color: const Color(0xFFEFF6FF),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Confirming submits this reporting check-in. In production, this record is immediate and secure.',
              style: TextStyle(
                  fontSize: 12, color: Color(0xFF1E3A8A), height: 1.4),
            ),
          ),
        ),
      ],
    );
  }

  // STEP 4: RECEIPT SCREEN
  Widget _buildReceiptStep() {
    return Card(
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.green, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 64),
            const SizedBox(height: 12),
            const Text(
              'Digital Check-In Completed\nحاضری رپورٹ مکمل کر لی گئی ہے',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 6),
            const Text(
              'Fictional Receipt / فرضی رسید',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold),
            ),
            const Divider(height: 32),
            _buildReceiptRow('Receipt Number / رسپٹ نمبر', _receiptNumber),
            _buildReceiptRow('Supervisee Name / نام', 'Tariq Mehmood'),
            _buildReceiptRow('Case Reference / کیس نمبر', 'LHR-2026-089'),
            _buildReceiptRow(
                'Date & Time / وقت اور تاریخ', _submissionTimestamp),
            _buildReceiptRow(
                'Supervision Status / حالت', 'Compliant / تعمیل کنندہ'),
            const Divider(height: 32),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFCA5A5)),
              ),
              child: const Text(
                'Notice: This is a demonstration receipt for testing purposes only and is not an official legal or government submission.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF991B1B),
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
                icon: const Icon(Icons.refresh, color: Colors.white),
                label:
                    const Text('Start New Check-In Demo / نیا ڈیمو شروع کریں'),
                onPressed: _resetFlow,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // HELPERS
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(label,
                style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ),
          Expanded(
            flex: 3,
            child: Text(value,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B))),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(String questionEn, String questionUr,
      bool currentValue, ValueChanged<bool> onChanged) {
    return Card(
      elevation: 1,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              questionEn,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 2),
            Text(
              questionUr,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 56, // Enforces 56px large target
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: currentValue == true
                            ? const Color(0xFFDCFCE7)
                            : Colors.white,
                        side: BorderSide(
                          color: currentValue == true
                              ? Colors.green
                              : Colors.grey.shade300,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => onChanged(true),
                      child: Text(
                        'Yes / جی ہاں',
                        style: TextStyle(
                          color: currentValue == true
                              ? const Color(0xFF0F5A47)
                              : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 56, // Enforces 56px large target
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: currentValue == false
                            ? const Color(0xFFFEE2E2)
                            : Colors.white,
                        side: BorderSide(
                          color: currentValue == false
                              ? Colors.red
                              : Colors.grey.shade300,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => onChanged(false),
                      child: Text(
                        'No / جی نہیں',
                        style: TextStyle(
                          color: currentValue == false
                              ? Colors.red.shade800
                              : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewRow(String label, String value, bool isPositive) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(label,
                style: const TextStyle(fontSize: 12, color: Colors.black87)),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isPositive ? const Color(0xFF0F5A47) : Colors.red.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(label,
                style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F5A47),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CUSTOM APBAR FOR CHECK-IN SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class _CheckInHeader extends StatelessWidget implements PreferredSizeWidget {
  const _CheckInHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0F5A47),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        bottom: 16,
        left: 20,
        right: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
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
                      size: 28,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Punjab Probation and Parole Service',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 1),
                    Text(
                      'Home Department, Government of the Punjab',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white24, height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Digital Check-In',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                'ڈیجیٹل حاضری رپورٹ',
                style: TextStyle(
                    fontSize: 14,
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
  Size get preferredSize => const Size.fromHeight(135);
}

// ─────────────────────────────────────────────────────────────────────────────
// REUSABLE FOOTER DISCLAIMER DUPLICATED FOR ISOLATED DESIGN
// ─────────────────────────────────────────────────────────────────────────────
class _FooterDisclaimer extends StatelessWidget {
  const _FooterDisclaimer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
      child: Column(
        children: const [
          Divider(),
          SizedBox(height: 8),
          Text(
            'This is a sample interface with fictional records for review and presentation purposes.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Colors.black54,
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'یہ ریویو اور پریزنٹیشن کے مقاصد کے لیے فرضی ریکارڈز کے ساتھ ایک نمونہ انٹرفیس ہے۔',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: Colors.black54,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
