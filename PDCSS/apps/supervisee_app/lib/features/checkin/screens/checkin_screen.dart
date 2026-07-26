import 'package:flutter/material.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({Key? key}) : super(key: key);

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  int _currentStep = 0;

  // Step 2 Answers
  bool _residingAtAddress = true;
  bool _changedEmployment = false;
  bool _needAssistance = false;
  bool _complyingConditions = true;

  bool _isSubmitted = false;
  final String _receiptNumber = "DEMO-CI-2026-0001";
  late final String _submissionTimestamp;

  @override
  void initState() {
    super.initState();
    _submissionTimestamp = DateTime.now().toString().substring(0, 16);
  }

  void _resetFlow() {
    setState(() {
      _currentStep = 0;
      _residingAtAddress = true;
      _changedEmployment = false;
      _needAssistance = false;
      _complyingConditions = true;
      _isSubmitted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-In / حاضری'),
        backgroundColor: const Color(0xFF0F766E),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Disclaimer Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Row(
                children: [
                  Icon(Icons.shield_outlined,
                      color: Color(0xFF0F766E), size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Demonstration Only / صرف ڈیمو: No camera, location, or biometric sensors are accessed.',
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (!_isSubmitted) ...[
              // Stepper Flow
              Stepper(
                currentStep: _currentStep,
                physics: const NeverScrollableScrollPhysics(),
                onStepContinue: () {
                  if (_currentStep < 2) {
                    setState(() => _currentStep += 1);
                  } else {
                    setState(() => _isSubmitted = true);
                  }
                },
                onStepCancel: () {
                  if (_currentStep > 0) {
                    setState(() => _currentStep -= 1);
                  }
                },
                steps: [
                  // STEP 1: Confirm Identity
                  Step(
                    title: const Text(
                      'Step 1: Confirm Identity / شناختی تصدیق',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    subtitle: const Text(
                        'Verify supervisee record / معلومات کی تصدیق'),
                    isActive: _currentStep >= 0,
                    state: _currentStep > 0
                        ? StepState.complete
                        : StepState.indexed,
                    content: Card(
                      color: const Color(0xFFF8FAFC),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                                'Supervisee Name / نام: Tariq Mehmood / طارق محمود',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14)),
                            SizedBox(height: 6),
                            Text(
                                'CNIC / شناختی کارڈ: 00000-0000000-0 (Masked)'),
                            SizedBox(height: 4),
                            Text('Case Ref / کیس نمبر: LHR-2026-089'),
                            SizedBox(height: 4),
                            Text('Supervision Type / قسم: Probation Order'),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // STEP 2: Answer Supervision Questions
                  Step(
                    title: const Text(
                      'Step 2: Questions / نگہداشت سوالات',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    subtitle: const Text(
                        'Answer 4 simple questions / چار سوالات کے جواب دیں'),
                    isActive: _currentStep >= 1,
                    state: _currentStep > 1
                        ? StepState.complete
                        : StepState.indexed,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildQuestionCard(
                          '1. Are you residing at your approved address?\nکیا آپ اپنے منظور شدہ پتہ پر مقیم ہیں؟',
                          _residingAtAddress,
                          (val) => setState(() => _residingAtAddress = val),
                        ),
                        _buildQuestionCard(
                          '2. Have you changed employment?\nکیا آپ نے ملازمت تبدیل کی ہے؟',
                          _changedEmployment,
                          (val) => setState(() => _changedEmployment = val),
                        ),
                        _buildQuestionCard(
                          '3. Do you need assistance from PP&PS?\nکیا آپ کو سروسز سے امداد کی ضرورت ہے؟',
                          _needAssistance,
                          (val) => setState(() => _needAssistance = val),
                        ),
                        _buildQuestionCard(
                          '4. Are you complying with supervision conditions?\nکیا آپ نگرانی کی شرائط پر عمل کر رہے ہیں؟',
                          _complyingConditions,
                          (val) => setState(() => _complyingConditions = val),
                        ),
                      ],
                    ),
                  ),

                  // STEP 3: Review Answers
                  Step(
                    title: const Text(
                      'Step 3: Review / جائزہ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    subtitle: const Text(
                        'Confirm your details / معلومات کی تصدیق کریں'),
                    isActive: _currentStep >= 2,
                    state: _currentStep == 2
                        ? StepState.editing
                        : StepState.indexed,
                    content: Card(
                      color: const Color(0xFFF0FDF4),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Review Answers / جوابات کا خلاصہ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F766E)),
                            ),
                            const Divider(),
                            Text(
                                '• Residing at approved address: ${_residingAtAddress ? "Yes / جی ہاں" : "No / جی نہیں"}'),
                            Text(
                                '• Changed employment: ${_changedEmployment ? "Yes / جی ہاں" : "No / جی نہیں"}'),
                            Text(
                                '• Need PP&PS assistance: ${_needAssistance ? "Yes / جی ہاں" : "No / جی نہیں"}'),
                            Text(
                                '• Complying with conditions: ${_complyingConditions ? "Yes / جی ہاں" : "No / جی نہیں"}'),
                            const SizedBox(height: 12),
                            const Text(
                              'Tap "Continue" to generate demonstration check-in receipt.',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              // STEP 4: Generate Receipt (Completed State)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Colors.green, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Icon(Icons.check_circle,
                          color: Colors.green, size: 64),
                      const SizedBox(height: 12),
                      const Text(
                        'Check-In Confirmation\nحاضری کی تصدیق',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Demonstration Receipt / ڈیمو رسپٹ',
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                      const Divider(height: 32),
                      _buildReceiptRow(
                          'Receipt Number / رسپٹ نمبر', _receiptNumber),
                      _buildReceiptRow('Supervisee / نام', 'Tariq Mehmood'),
                      _buildReceiptRow(
                          'Case Reference / کیس نمبر', 'LHR-2026-089'),
                      _buildReceiptRow(
                          'Date & Time / وقت', _submissionTimestamp),
                      _buildReceiptRow(
                          'Status / حالت', 'Compliant / تعمیل کنندہ'),
                      const Divider(height: 32),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFFCA5A5)),
                        ),
                        child: const Text(
                          'Note: This is a demonstration receipt for testing purposes only and is not an official legal or government submission.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF991B1B),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F766E),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          label: const Text(
                              'Start New Check-In Demo / نیا ڈیمو شروع کریں'),
                          onPressed: _resetFlow,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(
      String questionText, bool currentValue, ValueChanged<bool> onChanged) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              questionText,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600, height: 1.4),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Yes / جی ہاں'),
                    selected: currentValue == true,
                    selectedColor: const Color(0xFFDCFCE7),
                    onSelected: (selected) {
                      if (selected) onChanged(true);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('No / جی نہیں'),
                    selected: currentValue == false,
                    selectedColor: const Color(0xFFFEE2E2),
                    onSelected: (selected) {
                      if (selected) onChanged(false);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
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
                  style: const TextStyle(fontSize: 12, color: Colors.black54))),
          Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F766E))),
        ],
      ),
    );
  }
}
