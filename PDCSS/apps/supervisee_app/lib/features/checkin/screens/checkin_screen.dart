import 'package:flutter/material.dart';
import 'package:supervisee_app/core/backend/raahnuma_backend_service.dart';
import 'package:supervisee_app/core/backend/supabase_config.dart';

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
  String _dynamicReceiptNumber = "";
  bool _isLoading = false;
  String? _errorMessage;
  late String _submissionTimestamp;

  @override
  void initState() {
    super.initState();
    _updateTimestamp();
  }

  void _updateTimestamp() {
    final now = DateTime.now();
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
      _dynamicReceiptNumber = "";
      _errorMessage = null;
      _isLoading = false;
      _updateTimestamp();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _CheckInHeader(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
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

            if (_isLoading) ...[
              const SizedBox(height: 24),
              const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0F5A47)),
                ),
              ),
            ] else if (_currentStep < 3) ...[
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                        color: Colors.red,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              const SizedBox(height: 20),
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

  void _handleNext() async {
    if (_currentStep < 2) {
      setState(() => _currentStep += 1);
    } else if (_currentStep == 2) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      _updateTimestamp();

      try {
        final receipt = await RaahnumaBackendService.instance.submitCheckIn(
          superviseeId: 'f1e2d3c4-b5a6-9c8d-7e6f-5a4b3c2d1e0f',
          scheduledReportingDate:
              DateTime.now().toIso8601String().split('T')[0],
          residingAtAddress: _residingAtAddress,
          changedEmployment: _changedEmployment,
          needAssistance: _needAssistance,
          complyingConditions: _complyingConditions,
        );
        setState(() {
          _dynamicReceiptNumber = receipt;
          _currentStep = 3;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _errorMessage =
              "Failed to submit check-in. Please try again. / حاضری جمع کرنے میں خرابی۔ دوبارہ کوشش کریں۔";
          _isLoading = false;
        });
      }
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // STEP BUILDERS
  // ─────────────────────────────────────────────────────────────────────────────

  Widget _buildProgressIndicator() {
    return Row(
      children: [
        _buildProgressDot(0, 'Confirm Details / تفصیلات'),
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
            textAlign: TextAlign.center,
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
      width: 24,
      height: 2,
      color: isPassed ? const Color(0xFF0F5A47) : Colors.grey.shade300,
      margin: const EdgeInsets.only(bottom: 16),
    );
  }

  // STEP 1: CONFIRM DETAILS SCREEN
  Widget _buildIdentityStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Step 1: Confirm Details / مرحلہ 1: تفصیلات کی تصدیق',
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F5A47)),
        ),
        const SizedBox(height: 2),
        const Text(
          'Please confirm your supervisee profile information below before proceeding:',
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
        const SizedBox(height: 14),
        Card(
          elevation: 2,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
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
                _buildDetailRow('Supervision Category / نوعیت',
                    'Probation Order / پروبیشن حکم'),
                const Divider(),
                _buildDetailRow('Assigned Officer / پروبیشن افسر',
                    'Officer Tahir Mahmood / افسر طاہر محمود'),
                const Divider(),
                _buildDetailRow('District Office / ڈسٹرکٹ دفتر',
                    'Lahore Central Office / لاہور سینٹرل دفتر'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          color: const Color(0xFFF0FDF4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
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
              style: TextStyle(fontSize: 11.5, color: Colors.black87),
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
          'Step 2: Supervision Questions / مرحلہ 2: سپرویژن سوالات',
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F5A47)),
        ),
        const SizedBox(height: 2),
        const Text(
          'Answer the 4 simple reporting questions regarding your supervision status:',
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
        const SizedBox(height: 14),
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
          'Step 3: Review & Confirmation / مرحلہ 3: خلاصہ اور تصدیق',
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F5A47)),
        ),
        const SizedBox(height: 2),
        const Text(
          'Review your answers carefully before submitting your check-in report:',
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
        const SizedBox(height: 14),
        Card(
          elevation: 2,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Check-In Summary / خلاصہ جوابات',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F5A47),
                  ),
                ),
                const Divider(height: 20),
                _buildReviewRow(
                  'Approved Address? / منظور شدہ پتہ پر ہیں؟',
                  _residingAtAddress ? 'Yes / جی ہاں' : 'No / جی نہیں',
                  _residingAtAddress,
                ),
                const Divider(),
                _buildReviewRow(
                  'Changed Job? / نوکری تبدیل کی ہے؟',
                  _changedEmployment ? 'Yes / جی ہاں' : 'No / جی نہیں',
                  !_changedEmployment,
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
        const SizedBox(height: 14),
        Card(
          color: const Color(0xFFEFF6FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.blue, width: 1),
          ),
          child: const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Submitting records your digital check-in directly with your assigned officer. In live mode, this generates an audit log.',
              style: TextStyle(
                  fontSize: 11.5, color: Color(0xFF1E3A8A), height: 1.4),
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
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 10),
            const Text(
              'Digital Check-In Completed\nحاضری رپورٹ مکمل کر لی گئی ہے',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green),
              ),
              child: const Text(
                'VERIFIED & RECORDED / تصدیق شدہ',
                style: TextStyle(
                    fontSize: 10,
                    color: Colors.green,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 28),
            _buildReceiptRow(
                'Receipt Number / رسپٹ نمبر',
                _dynamicReceiptNumber.isNotEmpty
                    ? _dynamicReceiptNumber
                    : _receiptNumber),
            _buildReceiptRow('Supervisee Name / نام', 'Tariq Mehmood'),
            _buildReceiptRow('Case Reference / کیس نمبر', 'LHR-2026-089'),
            _buildReceiptRow(
                'Date & Time / وقت اور تاریخ', _submissionTimestamp),
            _buildReceiptRow(
                'Assigned Officer / پروبیشن افسر', 'Officer Tahir Mahmood'),
            _buildReceiptRow(
                'District Office / ڈسٹرکٹ دفتر', 'Lahore Central Office'),
            _buildReceiptRow(
                'Supervision Status / حالت', 'Compliant / تعمیل کنندہ'),
            const Divider(height: 28),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBF0),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE6C200)),
              ),
              child: const Text(
                'Public prototype using fictional records for review and presentation purposes.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF854D0E),
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
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
                style: const TextStyle(fontSize: 11.5, color: Colors.black54)),
          ),
          Expanded(
            flex: 3,
            child: Text(value,
                style: const TextStyle(
                    fontSize: 12.5,
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
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              questionEn,
              style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 2),
            Text(
              questionUr,
              style: const TextStyle(fontSize: 11.5, color: Colors.black54),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
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
                    height: 50,
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
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(label,
                style: const TextStyle(fontSize: 11.5, color: Colors.black87)),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.5,
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
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(label,
                style: const TextStyle(fontSize: 11.5, color: Colors.black54)),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12.5,
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
// CUSTOM HEADER FOR CHECK-IN SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class _CheckInHeader extends StatelessWidget implements PreferredSizeWidget {
  const _CheckInHeader({Key? key}) : super(key: key);

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
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 14,
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
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border:
                      Border.all(color: const Color(0xFFD4AF37), width: 1.5),
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
                      color: Color(0xFF0F5A47),
                      size: 26,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Punjab Probation and Parole Service',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.1,
                      ),
                    ),
                    SizedBox(height: 1),
                    Text(
                      'Home Department, Government of the Punjab',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 1),
                    Text(
                      'Raahnuma | Punjab Community Supervision System',
                      style: TextStyle(
                        fontSize: 9.5,
                        color: Color(0xFFFEE180),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              // Connection Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: hasBackend
                      ? const Color(0xFF065F46)
                      : const Color(0xFF92400E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: hasBackend
                        ? const Color(0xFF34D399)
                        : const Color(0xFFFBBF24),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: hasBackend
                            ? const Color(0xFF34D399)
                            : const Color(0xFFFBBF24),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      hasBackend ? 'Connected' : 'Local Demo',
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white24, height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Digital Check-In',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                'ڈیجیٹل حاضری رپورٹ',
                style: TextStyle(
                    fontSize: 13,
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
  Size get preferredSize => const Size.fromHeight(132);
}

// ─────────────────────────────────────────────────────────────────────────────
// REUSABLE FOOTER DISCLAIMER
// ─────────────────────────────────────────────────────────────────────────────
class _FooterDisclaimer extends StatelessWidget {
  const _FooterDisclaimer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      child: Column(
        children: const [
          Divider(),
          SizedBox(height: 8),
          Text(
            'Public prototype using fictional records for review and presentation purposes.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Colors.black54,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 3),
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
