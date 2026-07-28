class PRNAAssessmentModel {
  final String id;
  final String superviseeId;
  final String superviseeName;
  final String caseNumber;
  final String officerId;
  final String officerName;
  final String assessmentType; // Initial, Reassessment, Major Event Review
  final String placementDate;
  final String dueDate;
  final String? completedAt;
  final String
      status; // Draft, Completed, Supervisor Review Pending, Approved, Returned for Correction, Reassessment Due
  final int sriScore;
  final int dniScore;
  final int pcrScore;
  final int pfiScore;
  final int totalScore;
  final String riskBand; // Low, Moderate, High, Very High
  final String supervisionIntensity;
  final String? nextReassessmentDate;
  final String? assessorRemarks;
  final String? supervisorRemarks;
  final String createdAt;

  PRNAAssessmentModel({
    required this.id,
    required this.superviseeId,
    required this.superviseeName,
    required this.caseNumber,
    required this.officerId,
    required this.officerName,
    required this.assessmentType,
    required this.placementDate,
    required this.dueDate,
    this.completedAt,
    required this.status,
    this.sriScore = 0,
    this.dniScore = 0,
    this.pcrScore = 0,
    this.pfiScore = 0,
    this.totalScore = 0,
    required this.riskBand,
    required this.supervisionIntensity,
    this.nextReassessmentDate,
    this.assessorRemarks,
    this.supervisorRemarks,
    required this.createdAt,
  });

  factory PRNAAssessmentModel.fromMap(Map<String, dynamic> map) {
    final supervisee = map['supervisees'] as Map<String, dynamic>? ?? {};
    final profile = supervisee['profiles'] as Map<String, dynamic>? ?? {};
    final officer = map['officers'] as Map<String, dynamic>? ?? {};
    final officerProfile = officer['profiles'] as Map<String, dynamic>? ?? {};

    final sri = (map['sri_score'] as num?)?.toInt() ?? 0;
    final dni = (map['dni_score'] as num?)?.toInt() ?? 0;
    final pcr = (map['pcr_score'] as num?)?.toInt() ?? 0;
    final pfi = (map['pfi_score'] as num?)?.toInt() ?? 0;
    final tot =
        (map['total_score'] as num?)?.toInt() ?? (sri + dni + pcr - pfi);

    return PRNAAssessmentModel(
      id: map['id']?.toString() ?? '',
      superviseeId: map['supervisee_id']?.toString() ?? '',
      superviseeName: profile['full_name']?.toString() ?? 'Tariq Mehmood',
      caseNumber: supervisee['case_number']?.toString() ?? 'LHR-2026-089',
      officerId: map['officer_id']?.toString() ?? '',
      officerName:
          officerProfile['full_name']?.toString() ?? 'Officer Tahir Mahmood',
      assessmentType: map['assessment_type']?.toString() ?? 'Initial',
      placementDate: map['placement_date']?.toString() ?? '',
      dueDate: map['due_date']?.toString() ?? '',
      completedAt: map['completed_at']?.toString(),
      status: map['status']?.toString() ?? 'Draft',
      sriScore: sri,
      dniScore: dni,
      pcrScore: pcr,
      pfiScore: pfi,
      totalScore: tot,
      riskBand: map['risk_band']?.toString() ?? 'Low',
      supervisionIntensity:
          map['supervision_intensity']?.toString() ?? 'Standard Supervision',
      nextReassessmentDate: map['next_reassessment_date']?.toString(),
      assessorRemarks: map['assessor_remarks']?.toString(),
      supervisorRemarks: map['supervisor_remarks']?.toString(),
      createdAt: map['created_at']?.toString() ?? '',
    );
  }

  factory PRNAAssessmentModel.fallback(int index) {
    final names = [
      'Tariq Mehmood',
      'Sajid Ali',
      'Muhammad Yasir',
      'Zainab Bibi'
    ];
    final cases = [
      'LHR-2026-089',
      'LHR-2026-112',
      'LHR-2026-215',
      'LHR-2026-443'
    ];
    final statuses = [
      'Approved',
      'Draft',
      'Supervisor Review Pending',
      'Reassessment Due'
    ];
    final types = ['Initial', 'Initial', 'Reassessment', 'Initial'];
    final sris = [8, 12, 14, 18];
    final dnis = [14, 16, 20, 22];
    final pcrs = [4, 6, 8, 10];
    final pfis = [4, 2, 6, 0];
    final totals = [22, 32, 36, 50];
    final bands = ['Moderate', 'High', 'Very High', 'Very High'];

    final i = index % names.length;

    return PRNAAssessmentModel(
      id: 'prna-doc-$index',
      superviseeId: 'supervisee-$i',
      superviseeName: names[i],
      caseNumber: cases[i],
      officerId: 'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d',
      officerName: 'Tahir Mahmood',
      assessmentType: types[i],
      placementDate: '2026-06-15',
      dueDate: '2026-07-15',
      completedAt: statuses[i] == 'Approved' ? '2026-07-05 11:30:00' : null,
      status: statuses[i],
      sriScore: sris[i],
      dniScore: dnis[i],
      pcrScore: pcrs[i],
      pfiScore: pfis[i],
      totalScore: totals[i],
      riskBand: bands[i],
      supervisionIntensity: bands[i] == 'Low'
          ? 'Low Intensity Supervision'
          : bands[i] == 'Moderate'
              ? 'Standard Supervision (Bi-Weekly Reporting)'
              : 'Intensive Oversight (Weekly Reporting)',
      nextReassessmentDate: '2026-09-15',
      assessorRemarks: 'Initial intake assessment conducted within 30 days.',
      supervisorRemarks: 'Approved for active case plan execution.',
      createdAt: '2026-06-20 10:00:00',
    );
  }
}

class PRNAItemResponse {
  final String sectionCode;
  final String itemCode;
  final String itemLabel;
  final String selectedOption;
  final int score;
  final String? notes;

  PRNAItemResponse({
    required this.sectionCode,
    required this.itemCode,
    required this.itemLabel,
    required this.selectedOption,
    required this.score,
    this.notes,
  });

  factory PRNAItemResponse.fromMap(Map<String, dynamic> map) {
    return PRNAItemResponse(
      sectionCode: map['section_code']?.toString() ?? '',
      itemCode: map['item_code']?.toString() ?? '',
      itemLabel: map['item_label']?.toString() ?? '',
      selectedOption: map['selected_option']?.toString() ?? '',
      score: (map['score'] as num?)?.toInt() ?? 0,
      notes: map['notes']?.toString(),
    );
  }
}

class CasePlanModel {
  final String id;
  final String assessmentId;
  final String superviseeId;
  final String officerId;
  final String planTitle;
  final String
      planStatus; // Draft, Active, Supervisor Review Pending, Approved, Completed, Closed
  final List<String> topNeeds;
  final String? employmentEducationSteps;
  final String? housingSteps;
  final String? familyMentorEngagement;
  final String? complianceIncentives;
  final String startDate;
  final String reviewDate;
  final List<CasePlanActionModel> actions;

  CasePlanModel({
    required this.id,
    required this.assessmentId,
    required this.superviseeId,
    required this.officerId,
    required this.planTitle,
    required this.planStatus,
    required this.topNeeds,
    this.employmentEducationSteps,
    this.housingSteps,
    this.familyMentorEngagement,
    this.complianceIncentives,
    required this.startDate,
    required this.reviewDate,
    required this.actions,
  });

  factory CasePlanModel.fromMap(Map<String, dynamic> map,
      {List<CasePlanActionModel>? actions}) {
    List<String> needsList = [];
    if (map['top_needs'] is List) {
      needsList = (map['top_needs'] as List).map((e) => e.toString()).toList();
    }

    return CasePlanModel(
      id: map['id']?.toString() ?? '',
      assessmentId: map['assessment_id']?.toString() ?? '',
      superviseeId: map['supervisee_id']?.toString() ?? '',
      officerId: map['officer_id']?.toString() ?? '',
      planTitle: map['plan_title']?.toString() ?? 'Rehabilitation Case Plan',
      planStatus: map['plan_status']?.toString() ?? 'Active',
      topNeeds: needsList,
      employmentEducationSteps: map['employment_education_steps']?.toString(),
      housingSteps: map['housing_steps']?.toString(),
      familyMentorEngagement: map['family_mentor_engagement']?.toString(),
      complianceIncentives: map['compliance_incentives']?.toString(),
      startDate: map['start_date']?.toString() ?? '',
      reviewDate: map['review_date']?.toString() ?? '',
      actions: actions ?? [],
    );
  }

  factory CasePlanModel.fallback() {
    return CasePlanModel(
      id: 'case-plan-101',
      assessmentId: 'a1111111-1111-1111-1111-111111111111',
      superviseeId: 'f1e2d3c4-b5a6-9c8d-7e6f-5a4b3c2d1e0f',
      officerId: 'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d',
      planTitle: 'Initial Rehabilitation Supervision Plan for Tariq Mehmood',
      planStatus: 'Active',
      topNeeds: [
        'Education and Employment',
        'Companions / Peers',
        'Counselling'
      ],
      employmentEducationSteps:
          'Enroll in TEVTA electrician course and complete weekly practical sessions.',
      housingSteps: 'Maintain stable residence at family home in Lahore.',
      familyMentorEngagement:
          'Bi-weekly family check-in with pro-social uncle as mentor.',
      complianceIncentives:
          'Reduction in reporting frequency upon 60 days of clean compliance.',
      startDate: '2026-06-20',
      reviewDate: '2026-09-20',
      actions: [
        CasePlanActionModel(
          id: 'action-1',
          casePlanId: 'case-plan-101',
          topNeed: 'Education and Employment',
          smartGoal:
              'Complete 3-month TEVTA vocational electrical certificate by Sept 2026.',
          interventionReferral: 'TEVTA Lahore Center Referral',
          responsible: 'Supervisee & Probation Officer',
          startDate: '2026-07-01',
          reviewDate: '2026-09-30',
          status: 'In Progress',
          linkedAssignedActivityId: '22222222-2222-2222-2222-222222222222',
        ),
        CasePlanActionModel(
          id: 'action-2',
          casePlanId: 'case-plan-101',
          topNeed: 'Counselling',
          smartGoal:
              'Attend monthly guidance counselling for social integration.',
          interventionReferral: 'District Probation Guidance Center',
          responsible: 'Probation Officer Tahir Mahmood',
          startDate: '2026-06-20',
          reviewDate: '2026-12-20',
          status: 'In Progress',
          linkedAssignedActivityId: '44444444-4444-4444-4444-444444444444',
        ),
      ],
    );
  }
}

class CasePlanActionModel {
  final String id;
  final String casePlanId;
  final String topNeed;
  final String smartGoal;
  final String interventionReferral;
  final String responsible;
  final String startDate;
  final String reviewDate;
  final String
      status; // Planned, In Progress, Completed, Needs Follow-up, Cancelled
  final String? linkedAssignedActivityId;

  CasePlanActionModel({
    required this.id,
    required this.casePlanId,
    required this.topNeed,
    required this.smartGoal,
    required this.interventionReferral,
    required this.responsible,
    required this.startDate,
    required this.reviewDate,
    required this.status,
    this.linkedAssignedActivityId,
  });

  factory CasePlanActionModel.fromMap(Map<String, dynamic> map) {
    return CasePlanActionModel(
      id: map['id']?.toString() ?? '',
      casePlanId: map['case_plan_id']?.toString() ?? '',
      topNeed: map['top_need']?.toString() ?? '',
      smartGoal: map['smart_goal']?.toString() ?? '',
      interventionReferral: map['intervention_referral']?.toString() ?? '',
      responsible: map['responsible']?.toString() ?? '',
      startDate: map['start_date']?.toString() ?? '',
      reviewDate: map['review_date']?.toString() ?? '',
      status: map['status']?.toString() ?? 'Planned',
      linkedAssignedActivityId: map['linked_assigned_activity_id']?.toString(),
    );
  }
}
