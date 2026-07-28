import 'package:flutter/material.dart';
import 'package:officer_app/core/backend/prna_models.dart';
import 'package:officer_app/core/backend/raahnuma_backend_service.dart';
import 'package:officer_app/core/theme/officer_app_theme.dart';

class PRNAStepperWizardScreen extends StatefulWidget {
  final PRNAAssessmentModel? existingAssessment;

  const PRNAStepperWizardScreen({Key? key, this.existingAssessment})
      : super(key: key);

  @override
  State<PRNAStepperWizardScreen> createState() =>
      _PRNAStepperWizardScreenState();
}

class _PRNAStepperWizardScreenState extends State<PRNAStepperWizardScreen> {
  int _currentStep = 0;
  bool _isSaving = false;

  // Step 1: Admin info
  String _superviseeName = 'Tariq Mehmood';
  String _caseNumber = 'LHR-2026-089';
  String _superviseeId = 'f1e2d3c4-b5a6-9c8d-7e6f-5a4b3c2d1e0f';
  String _assessmentType = 'Initial';
  DateTime _placementDate = DateTime.now().subtract(const Duration(days: 10));
  late DateTime _dueDate;

  // Step 2: SRI scores (0 - 24)
  int _sriAgeFirstConviction = 1;
  int _sriPriorConvictions = 2;
  int _sriPriorCustodial = 1;
  int _sriPriorViolent = 1;
  int _sriSupervisionFailure = 1;
  int _sriInstitutionalMisconduct = 0;
  int _sriAgeNow = 1;
  int _sriWeaponInvolvement = 1;

  // Step 3: DNI scores (0 - 36)
  int _dniEducationEmployment = 3;
  int _dniFamilyMarital = 2;
  int _dniCompanionsPeers = 3;
  int _dniSubstanceUse = 2;
  int _dniAttitudesCognition = 2;
  int _dniLeisureRecreation = 1;
  int _dniHousingNeighbourhood = 1;

  // Step 4: PCR scores (0 - 16) & checklist
  int _pcrSituationalJudgement = 4;
  bool _obsEmotionalRegulation = true;
  bool _obsConflictResolution = false;
  bool _obsImpulsivityNoted = true;
  bool _obsResponsivityNeedsSpecialAppr = false;

  // Step 5: PFI scores (0 to -8)
  bool _pfiVerifiedJob = true; // -2
  bool _pfiEnrolledEducation = false; // -1
  bool _pfiProsocialMentor = true; // -1
  bool _pfiReligiousEngagement = true; // -1
  bool _pfiStableHousing = true; // -2
  bool _pfiNoSubstanceUse6Months = false; // -1

  // Step 8: Case Plan
  List<String> _selectedTopNeeds = [
    'Education and Employment',
    'Companions / Peers',
  ];
  final TextEditingController _employmentStepsCtrl = TextEditingController(
      text:
          'Enroll in TEVTA vocational electrical certificate course and attend practical sessions.');
  final TextEditingController _housingStepsCtrl = TextEditingController(
      text: 'Maintain stable residence at family home in Lahore.');
  final TextEditingController _familyEngagementCtrl = TextEditingController(
      text: 'Bi-weekly family check-in with pro-social uncle as mentor.');
  final TextEditingController _incentivesCtrl = TextEditingController(
      text:
          'Reduction in reporting frequency upon 60 days of verified compliance.');

  final TextEditingController _smartGoalCtrl = TextEditingController(
      text: 'Complete 3-month TEVTA electrical certificate by Sept 2026.');
  final TextEditingController _referralCtrl =
      TextEditingController(text: 'TEVTA Lahore Vocational Training Center');

  // Step 9: Remarks
  final TextEditingController _assessorRemarksCtrl = TextEditingController(
      text:
          'Initial assessment completed within 30-day placement window. Supervisee demonstrates positive responsivity to vocational placement.');

  @override
  void initState() {
    super.initState();
    _dueDate = _placementDate.add(const Duration(days: 30));
    if (widget.existingAssessment != null) {
      final a = widget.existingAssessment!;
      _superviseeName = a.superviseeName;
      _caseNumber = a.caseNumber;
      _superviseeId = a.superviseeId;
      _assessmentType = a.assessmentType;
      _assessorRemarksCtrl.text = a.assessorRemarks ?? '';
    }
  }

  int get _calculatedSri =>
      _sriAgeFirstConviction +
      _sriPriorConvictions +
      _sriPriorCustodial +
      _sriPriorViolent +
      _sriSupervisionFailure +
      _sriInstitutionalMisconduct +
      _sriAgeNow +
      _sriWeaponInvolvement;

  int get _calculatedDni =>
      _dniEducationEmployment +
      _dniFamilyMarital +
      _dniCompanionsPeers +
      _dniSubstanceUse +
      _dniAttitudesCognition +
      _dniLeisureRecreation +
      _dniHousingNeighbourhood;

  int get _calculatedPcr => _pcrSituationalJudgement;

  int get _calculatedPfi {
    int pfi = 0;
    if (_pfiVerifiedJob) pfi += 2;
    if (_pfiEnrolledEducation) pfi += 1;
    if (_pfiProsocialMentor) pfi += 1;
    if (_pfiReligiousEngagement) pfi += 1;
    if (_pfiStableHousing) pfi += 2;
    if (_pfiNoSubstanceUse6Months) pfi += 1;
    return pfi;
  }

  int get _calculatedTotalScore =>
      _calculatedSri + _calculatedDni + _calculatedPcr - _calculatedPfi;

  String get _calculatedRiskBand {
    final score = _calculatedTotalScore;
    if (score <= 16) return 'Low';
    if (score <= 26) return 'Moderate';
    if (score <= 34) return 'High';
    return 'Very High';
  }

  String get _calculatedSupervisionIntensity {
    final band = _calculatedRiskBand;
    switch (band) {
      case 'Low':
        return 'Low Intensity Supervision (Monthly Reporting)';
      case 'Moderate':
        return 'Standard Supervision (Bi-Weekly Reporting)';
      case 'High':
        return 'Intensive Oversight (Weekly Reporting & Home Visits)';
      default:
        return 'High-Oversight Specialized Rehabilitation';
    }
  }

  void _convertActionToActivity() async {
    setState(() => _isSaving = true);
    final activityId =
        await RaahnumaBackendService.instance.convertActionToAssignedActivity(
      superviseeId: _superviseeId,
      topNeed: _selectedTopNeeds.isNotEmpty
          ? _selectedTopNeeds.first
          : 'Education and Employment',
      smartGoal: _smartGoalCtrl.text.trim(),
      interventionReferral: _referralCtrl.text.trim(),
    );
    setState(() => _isSaving = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Case Plan action converted to Assigned Activity (ID: $activityId).'),
          backgroundColor: kGovGreen,
        ),
      );
    }
  }

  void _saveAssessment(String status) async {
    setState(() => _isSaving = true);

    final record = PRNAAssessmentModel(
      id: widget.existingAssessment?.id ??
          'prna-new-${DateTime.now().millisecondsSinceEpoch}',
      superviseeId: _superviseeId,
      superviseeName: _superviseeName,
      caseNumber: _caseNumber,
      officerId: 'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d',
      officerName: 'Tahir Mahmood',
      assessmentType: _assessmentType,
      placementDate: _placementDate.toIso8601String().substring(0, 10),
      dueDate: _dueDate.toIso8601String().substring(0, 10),
      status: status,
      sriScore: _calculatedSri,
      dniScore: _calculatedDni,
      pcrScore: _calculatedPcr,
      pfiScore: _calculatedPfi,
      totalScore: _calculatedTotalScore,
      riskBand: _calculatedRiskBand,
      supervisionIntensity: _calculatedSupervisionIntensity,
      nextReassessmentDate: DateTime.now()
          .add(const Duration(days: 90))
          .toIso8601String()
          .substring(0, 10),
      assessorRemarks: _assessorRemarksCtrl.text.trim(),
      supervisorRemarks: null,
      createdAt: DateTime.now().toIso8601String(),
    );

    await RaahnumaBackendService.instance.savePRNAAssessment(record);
    setState(() => _isSaving = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PRNA Assessment saved as $status.'),
          backgroundColor: kGovGreen,
        ),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Punjab Risk & Needs Assessment (PRNA)'),
        backgroundColor: kGovGreen,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.save_outlined),
            tooltip: 'Save Draft',
            onPressed: _isSaving ? null : () => _saveAssessment('Draft'),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF8FAFC),
      body: _isSaving
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kGovGreen),
              ),
            )
          : Stepper(
              type: StepperType.vertical,
              currentStep: _currentStep,
              onStepTapped: (step) => setState(() => _currentStep = step),
              onStepContinue: () {
                if (_currentStep < 8) {
                  setState(() => _currentStep++);
                } else {
                  _saveAssessment('Supervisor Review Pending');
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) {
                  setState(() => _currentStep--);
                }
              },
              steps: [
                _buildStep1Admin(),
                _buildStep2SRI(),
                _buildStep3DNI(),
                _buildStep4PCR(),
                _buildStep5PFI(),
                _buildStep6ScoringWorksheet(),
                _buildStep7RiskBandMatrix(),
                _buildStep8CasePlan(),
                _buildStep9Declaration(),
              ],
            ),
    );
  }

  // ── STEP 1: Administrative Information (Section A) ─────────────────────────
  Step _buildStep1Admin() {
    return Step(
      title: const Text('Step 1: Administrative Info (Section A)',
          style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: const Text('Placement dates & assessment type (Not Scored)'),
      isActive: _currentStep >= 0,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoTile('Supervisee Name', _superviseeName),
          _buildInfoTile('Case Number', _caseNumber),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _assessmentType,
            decoration: const InputDecoration(
              labelText: 'Assessment Type',
              border: OutlineInputBorder(),
            ),
            items: ['Initial', 'Reassessment', 'Major Event Review']
                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                .toList(),
            onChanged: (val) => setState(() => _assessmentType = val!),
          ),
          const SizedBox(height: 12),
          Text(
            'Placement Date: ${_placementDate.toIso8601String().substring(0, 10)}',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          Text(
            'PRNA Due Date (30 Days Limit): ${_dueDate.toIso8601String().substring(0, 10)}',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: _dueDate.difference(DateTime.now()).inDays <= 7
                    ? Colors.orange.shade900
                    : kGovGreen),
          ),
        ],
      ),
    );
  }

  // ── STEP 2: Static Risk Index (Section B) ──────────────────────────────────
  Step _buildStep2SRI() {
    return Step(
      title: Text('Step 2: Static Risk Index (SRI: $_calculatedSri/24)',
          style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: const Text('Historical offense factors (Section B)'),
      isActive: _currentStep >= 1,
      content: Column(
        children: [
          _buildScoreDropdown(
              'Age at First Conviction',
              _sriAgeFirstConviction,
              [
                {'label': 'Under 18 (Score: 3)', 'val': 3},
                {'label': '18 - 21 (Score: 2)', 'val': 2},
                {'label': '22 - 25 (Score: 1)', 'val': 1},
                {'label': '26 or older (Score: 0)', 'val': 0},
              ],
              (v) => setState(() => _sriAgeFirstConviction = v)),
          _buildScoreDropdown(
              'Prior Convictions Count',
              _sriPriorConvictions,
              [
                {'label': '5 or more (Score: 4)', 'val': 4},
                {'label': '3 - 4 (Score: 3)', 'val': 3},
                {'label': '1 - 2 (Score: 2)', 'val': 2},
                {'label': 'None (Score: 0)', 'val': 0},
              ],
              (v) => setState(() => _sriPriorConvictions = v)),
          _buildScoreDropdown(
              'Prior Custodial Sentences',
              _sriPriorCustodial,
              [
                {'label': '3 or more (Score: 3)', 'val': 3},
                {'label': '1 - 2 (Score: 2)', 'val': 2},
                {'label': 'None (Score: 0)', 'val': 0},
              ],
              (v) => setState(() => _sriPriorCustodial = v)),
          _buildScoreDropdown(
              'Prior Violent Conviction History',
              _sriPriorViolent,
              [
                {'label': 'Multiple Violent Offenses (Score: 3)', 'val': 3},
                {'label': 'One Violent Offense (Score: 2)', 'val': 2},
                {'label': 'Non-Violent Only (Score: 0)', 'val': 0},
              ],
              (v) => setState(() => _sriPriorViolent = v)),
          _buildScoreDropdown(
              'Supervision Failure (Last 5 Years)',
              _sriSupervisionFailure,
              [
                {'label': 'Revoked / Breach (Score: 3)', 'val': 3},
                {'label': 'Technical Failure (Score: 1)', 'val': 1},
                {'label': 'No Prior Supervision / Clean (Score: 0)', 'val': 0},
              ],
              (v) => setState(() => _sriSupervisionFailure = v)),
        ],
      ),
    );
  }

  // ── STEP 3: Dynamic Needs Index (Section C) ────────────────────────────────
  Step _buildStep3DNI() {
    return Step(
      title: Text('Step 3: Dynamic Needs Index (DNI: $_calculatedDni/36)',
          style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: const Text('7 Criminogenic Domains (Section C)'),
      isActive: _currentStep >= 2,
      content: Column(
        children: [
          _buildScoreDropdown(
              '1. Education & Employment Need',
              _dniEducationEmployment,
              [
                {'label': 'Unemployed & Unskilled (Score: 5)', 'val': 5},
                {'label': 'Unemployed / Seeking Work (Score: 3)', 'val': 3},
                {'label': 'Employed / Enrolled Training (Score: 1)', 'val': 1},
                {'label': 'Stable Employment (Score: 0)', 'val': 0},
              ],
              (v) => setState(() => _dniEducationEmployment = v)),
          _buildScoreDropdown(
              '2. Family / Marital Support',
              _dniFamilyMarital,
              [
                {
                  'label': 'Severe Family Conflict / Isolated (Score: 4)',
                  'val': 4
                },
                {'label': 'Moderate Support Needed (Score: 2)', 'val': 2},
                {'label': 'Strong Family Support (Score: 0)', 'val': 0},
              ],
              (v) => setState(() => _dniFamilyMarital = v)),
          _buildScoreDropdown(
              '3. Companions / Peers',
              _dniCompanionsPeers,
              [
                {'label': 'Pro-Criminal Peer Association (Score: 5)', 'val': 5},
                {'label': 'Mixed Peer Group (Score: 3)', 'val': 3},
                {'label': 'Pro-Social Peers Only (Score: 0)', 'val': 0},
              ],
              (v) => setState(() => _dniCompanionsPeers = v)),
          _buildScoreDropdown(
              '4. Substance Use History',
              _dniSubstanceUse,
              [
                {'label': 'Active Dependence / Heavy (Score: 5)', 'val': 5},
                {'label': 'Occasional Abuse (Score: 2)', 'val': 2},
                {'label': 'No Abuse Reported (Score: 0)', 'val': 0},
              ],
              (v) => setState(() => _dniSubstanceUse = v)),
          _buildScoreDropdown(
              '5. Attitudes / Cognition',
              _dniAttitudesCognition,
              [
                {
                  'label': 'Anti-Social / Defiant Attitudes (Score: 5)',
                  'val': 5
                },
                {'label': 'Ambivalent / Partial Insight (Score: 2)', 'val': 2},
                {'label': 'Pro-Social & Remorseful (Score: 0)', 'val': 0},
              ],
              (v) => setState(() => _dniAttitudesCognition = v)),
        ],
      ),
    );
  }

  // ── STEP 4: PCR (Section D) ────────────────────────────────────────────────
  Step _buildStep4PCR() {
    return Step(
      title: Text(
          'Step 4: Personality & Conflict Response (PCR: $_calculatedPcr/16)',
          style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle:
          const Text('Situational judgement & officer observation checklist'),
      isActive: _currentStep >= 3,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildScoreDropdown(
              'Situational Conflict Handling',
              _pcrSituationalJudgement,
              [
                {'label': 'High Aggression / Hostility (Score: 6)', 'val': 6},
                {'label': 'Moderate Impulsivity (Score: 4)', 'val': 4},
                {'label': 'Controlled / Cooperative (Score: 1)', 'val': 1},
              ],
              (v) => setState(() => _pcrSituationalJudgement = v)),
          const SizedBox(height: 10),
          const Text(
              'Officer Observational Responsivity Checklist (Informs Case Responsivity):',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          CheckboxListTile(
            title: const Text('Displays emotional regulation during interview'),
            value: _obsEmotionalRegulation,
            onChanged: (v) => setState(() => _obsEmotionalRegulation = v!),
          ),
          CheckboxListTile(
            title:
                const Text('Demonstrates impulse control in conflict prompts'),
            value: _obsConflictResolution,
            onChanged: (v) => setState(() => _obsConflictResolution = v!),
          ),
          CheckboxListTile(
            title: const Text('Impulsivity or hostility noted in observation'),
            value: _obsImpulsivityNoted,
            onChanged: (v) => setState(() => _obsImpulsivityNoted = v!),
          ),
          CheckboxListTile(
            title: const Text('Requires specific learning accommodation'),
            value: _obsResponsivityNeedsSpecialAppr,
            onChanged: (v) =>
                setState(() => _obsResponsivityNeedsSpecialAppr = v!),
          ),
        ],
      ),
    );
  }

  // ── STEP 5: PFI (Section E) ────────────────────────────────────────────────
  Step _buildStep5PFI() {
    return Step(
      title: Text(
          'Step 5: Protective Factors Index (PFI: -$_calculatedPfi Score)',
          style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: const Text('Pro-social strengths (Deducted from risk total)'),
      isActive: _currentStep >= 4,
      content: Column(
        children: [
          CheckboxListTile(
            title: const Text('Verified Stable Job Offer (-2)'),
            value: _pfiVerifiedJob,
            onChanged: (v) => setState(() => _pfiVerifiedJob = v!),
          ),
          CheckboxListTile(
            title: const Text('Enrolled in Training / Education (-1)'),
            value: _pfiEnrolledEducation,
            onChanged: (v) => setState(() => _pfiEnrolledEducation = v!),
          ),
          CheckboxListTile(
            title: const Text('Pro-Social Community Mentor Identified (-1)'),
            value: _pfiProsocialMentor,
            onChanged: (v) => setState(() => _pfiProsocialMentor = v!),
          ),
          CheckboxListTile(
            title: const Text('Weekly Religious / Community Engagement (-1)'),
            value: _pfiReligiousEngagement,
            onChanged: (v) => setState(() => _pfiReligiousEngagement = v!),
          ),
          CheckboxListTile(
            title: const Text('Stable Housing with Supportive Family (-2)'),
            value: _pfiStableHousing,
            onChanged: (v) => setState(() => _pfiStableHousing = v!),
          ),
          CheckboxListTile(
            title: const Text('Clean Substance Record > 6 Months (-1)'),
            value: _pfiNoSubstanceUse6Months,
            onChanged: (v) => setState(() => _pfiNoSubstanceUse6Months = v!),
          ),
        ],
      ),
    );
  }

  // ── STEP 6: Scoring Worksheet (Section F) ──────────────────────────────────
  Step _buildStep6ScoringWorksheet() {
    return Step(
      title: const Text('Step 6: Scoring Worksheet (Section F)',
          style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: const Text('Automated Tally Formula: SRI + DNI + PCR - PFI'),
      isActive: _currentStep >= 5,
      content: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            _buildTallyRow('Static Risk Index (SRI)', '+$_calculatedSri'),
            _buildTallyRow('Dynamic Needs Index (DNI)', '+$_calculatedDni'),
            _buildTallyRow('Personality & Conflict (PCR)', '+$_calculatedPcr'),
            _buildTallyRow('Protective Factors (PFI)', '-$_calculatedPfi'),
            const Divider(thickness: 2),
            _buildTallyRow('FINAL PRNA SCORE', '$_calculatedTotalScore',
                isTotal: true),
          ],
        ),
      ),
    );
  }

  // ── STEP 7: Risk Band & Supervision Intensity (Section G) ─────────────────
  Step _buildStep7RiskBandMatrix() {
    final band = _calculatedRiskBand;
    return Step(
      title: Text('Step 7: Risk Band & Supervision ($band)',
          style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: const Text('Supervision Intensity Allocation'),
      isActive: _currentStep >= 6,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: kGovGreenSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kGovGreen),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Assigned Risk Band: $band',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kGovGreen),
                ),
                const SizedBox(height: 6),
                Text(
                  'Allocated Intensity: $_calculatedSupervisionIntensity',
                  style: const TextStyle(fontSize: 13, color: kTextDark),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFCD34D)),
            ),
            child: Row(
              children: const [
                Icon(Icons.info_outline, color: Color(0xFFD97706), size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Mandatory Note: “Risk bands are provisional and subject to Punjab validation.”',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF92400E)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── STEP 8: RNR-Aligned Case Plan (Section H) ──────────────────────────────
  Step _buildStep8CasePlan() {
    return Step(
      title: const Text('Step 8: RNR-Aligned Case Plan (Section H)',
          style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: const Text('SMART Goals & Action to Activity Conversion'),
      isActive: _currentStep >= 7,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Top Criminogenic Needs Targets:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Wrap(
            spacing: 8,
            children: [
              'Education and Employment',
              'Family / Marital',
              'Companions / Peers',
              'Substance Use',
              'Cognition',
              'Counselling',
              'Personal Discipline',
            ].map((need) {
              final isSel = _selectedTopNeeds.contains(need);
              return ChoiceChip(
                label: Text(need, style: const TextStyle(fontSize: 11)),
                selected: isSel,
                onSelected: (val) {
                  setState(() {
                    if (val) {
                      _selectedTopNeeds.add(need);
                    } else {
                      _selectedTopNeeds.remove(need);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _employmentStepsCtrl,
            decoration: const InputDecoration(
              labelText: 'Employment & Education Steps',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _housingStepsCtrl,
            decoration: const InputDecoration(
              labelText: 'Housing & Environment Steps',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _familyEngagementCtrl,
            decoration: const InputDecoration(
              labelText: 'Family / Mentor Engagement Steps',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _incentivesCtrl,
            decoration: const InputDecoration(
              labelText: 'Compliance Incentives & Positive Reinforcement',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          const Divider(),
          const Text('SMART Action Item & Activity Conversion:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 6),
          TextField(
            controller: _smartGoalCtrl,
            decoration: const InputDecoration(
              labelText: 'SMART Action Goal',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _referralCtrl,
            decoration: const InputDecoration(
              labelText: 'Intervention / Referral Agency',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: kGovGreen),
            icon: const Icon(Icons.add_task, color: Colors.white, size: 18),
            label: const Text('Convert Action to Assigned Activity',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            onPressed: _convertActionToActivity,
          ),
        ],
      ),
    );
  }

  // ── STEP 9: Declaration and Review (Section I) ────────────────────────────
  Step _buildStep9Declaration() {
    return Step(
      title: const Text('Step 9: Declaration & Review (Section I)',
          style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: const Text('Officer Sign-off & Supervisor Submission'),
      isActive: _currentStep >= 8,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _assessorRemarksCtrl,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Assessor Final Remarks',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _saveAssessment('Draft'),
                  child: const Text('Save as Draft'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: kGovGreen),
                  onPressed: () => _saveAssessment('Supervisor Review Pending'),
                  child: const Text('Submit to Supervisor',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text('$label: ',
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Text(value, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildScoreDropdown(String title, int currentValue,
      List<Map<String, dynamic>> options, ValueChanged<int> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<int>(
        value: currentValue,
        decoration: InputDecoration(
          labelText: title,
          border: const OutlineInputBorder(),
        ),
        items: options
            .map((o) => DropdownMenuItem<int>(
                  value: o['val'] as int,
                  child: Text(o['label'] as String,
                      style: const TextStyle(fontSize: 12)),
                ))
            .toList(),
        onChanged: (v) => onChanged(v!),
      ),
    );
  }

  Widget _buildTallyRow(String label, String val, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                fontSize: isTotal ? 14 : 12.5,
                color: isTotal ? kGovGreen : kTextDark,
              )),
          Text(val,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isTotal ? 16 : 13,
                color: isTotal ? kGovGreen : kTextDark,
              )),
        ],
      ),
    );
  }
}
