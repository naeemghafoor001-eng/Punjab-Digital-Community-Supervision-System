class UserProfileModel {
  final String id;
  final String fullName;
  final String officialEmail;
  final String username;
  final String cnicMasked;
  final String designation;
  final String
      officerType; // Probation Officer, Parole Officer, Supervisory Officer, Administrative Officer, System Administrator
  final String district;
  final String division;
  final String officeName;
  final String phoneMasked;
  final bool isActive;
  final bool mustChangePassword;
  final String? createdBy;
  final String createdAt;
  final String? lastLoginAt;
  final String assignedRoleCode;
  final String authStatus;

  UserProfileModel({
    required this.id,
    required this.fullName,
    required this.officialEmail,
    required this.username,
    required this.cnicMasked,
    required this.designation,
    required this.officerType,
    required this.district,
    required this.division,
    required this.officeName,
    required this.phoneMasked,
    this.isActive = true,
    this.mustChangePassword = false,
    this.createdBy,
    required this.createdAt,
    this.lastLoginAt,
    required this.assignedRoleCode,
    this.authStatus = 'Linked',
  });

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      id: map['id']?.toString() ?? '',
      fullName: map['full_name']?.toString() ?? '',
      officialEmail: map['official_email']?.toString() ?? '',
      username: map['username']?.toString() ?? '',
      cnicMasked: map['cnic_masked']?.toString() ?? '35201-******-1',
      designation: map['designation']?.toString() ?? 'Probation Officer',
      officerType: map['officer_type']?.toString() ?? 'Probation Officer',
      district: map['district']?.toString() ?? 'Lahore',
      division: map['division']?.toString() ?? 'Lahore Division',
      officeName:
          map['office_name']?.toString() ?? 'District Probation Office Lahore',
      phoneMasked: map['phone_masked']?.toString() ?? '0300-*******',
      isActive: map['is_active'] as bool? ?? true,
      mustChangePassword: map['must_change_password'] as bool? ?? false,
      createdBy: map['created_by']?.toString(),
      createdAt: map['created_at']?.toString() ?? '',
      lastLoginAt: map['last_login_at']?.toString(),
      assignedRoleCode:
          map['assigned_role_code']?.toString() ?? 'probation_officer',
      authStatus: map['auth_status']?.toString() ?? 'Linked',
    );
  }

  factory UserProfileModel.fallback(int index) {
    final names = [
      'Tahir Mahmood',
      'Asad Iqbal',
      'Kashif Raza',
      'Directorate Admin',
      'Zahid Hussain'
    ];
    final usernames = [
      'tahir.mahmood',
      'asad.iqbal',
      'kashif.raza',
      'dg.admin',
      'zahid.hussain'
    ];
    final emails = [
      'tahir.mahmood@ppps.punjab.gov.pk',
      'asad.iqbal@ppps.punjab.gov.pk',
      'kashif.raza@ppps.punjab.gov.pk',
      'dg.admin@ppps.punjab.gov.pk',
      'zahid.hussain@ppps.punjab.gov.pk'
    ];
    final types = [
      'Probation Officer',
      'Parole Officer',
      'Supervisory Officer',
      'System Administrator',
      'Administrative Officer'
    ];
    final roles = [
      'probation_officer',
      'parole_officer',
      'supervisory_officer',
      'system_admin',
      'district_admin'
    ];
    final districts = [
      'Lahore',
      'Lahore',
      'Rawalpindi',
      'Lahore',
      'Faisalabad'
    ];
    final i = index % names.length;

    return UserProfileModel(
      id: 'user-prof-$index',
      fullName: names[i],
      officialEmail: emails[i],
      username: usernames[i],
      cnicMasked: '35201-123456$i-1',
      designation: types[i],
      officerType: types[i],
      district: districts[i],
      division: 'Lahore Division',
      officeName: 'District Office ${districts[i]}',
      phoneMasked: '0300-123456$i',
      isActive: true,
      mustChangePassword: false,
      createdAt: '2026-06-01 09:00:00',
      lastLoginAt: '2026-07-28 10:15:00',
      assignedRoleCode: roles[i],
    );
  }
}

class SystemRoleModel {
  final String id;
  final String roleCode;
  final String roleName;
  final String roleDescription;
  final int roleLevel;
  final bool isSystemRole;
  final bool isActive;

  SystemRoleModel({
    required this.id,
    required this.roleCode,
    required this.roleName,
    required this.roleDescription,
    required this.roleLevel,
    this.isSystemRole = false,
    this.isActive = true,
  });

  factory SystemRoleModel.fromMap(Map<String, dynamic> map) {
    return SystemRoleModel(
      id: map['id']?.toString() ?? '',
      roleCode: map['role_code']?.toString() ?? '',
      roleName: map['role_name']?.toString() ?? '',
      roleDescription: map['role_description']?.toString() ?? '',
      roleLevel: (map['role_level'] as num?)?.toInt() ?? 10,
      isSystemRole: map['is_system_role'] as bool? ?? false,
      isActive: map['is_active'] as bool? ?? true,
    );
  }
}

class PermissionModel {
  final String id;
  final String moduleCode;
  final String moduleName;
  final String featureCode;
  final String featureName;
  final String actionCode;
  final String permissionCode;
  final String description;

  PermissionModel({
    required this.id,
    required this.moduleCode,
    required this.moduleName,
    required this.featureCode,
    required this.featureName,
    required this.actionCode,
    required this.permissionCode,
    required this.description,
  });
}

class LoginAuditLogModel {
  final String id;
  final String usernameOrEmail;
  final String loginStatus; // Success, Failed, Locked, Logged Out
  final String ipAddress;
  final String userAgent;
  final String? failureReason;
  final String createdAt;

  LoginAuditLogModel({
    required this.id,
    required this.usernameOrEmail,
    required this.loginStatus,
    required this.ipAddress,
    required this.userAgent,
    this.failureReason,
    required this.createdAt,
  });

  factory LoginAuditLogModel.fallback(int index) {
    final users = ['tahir.mahmood', 'asad.iqbal', 'unknown.user', 'dg.admin'];
    final statuses = ['Success', 'Success', 'Failed', 'Success'];
    final ips = [
      '192.168.1.104',
      '192.168.1.112',
      '110.39.42.18',
      '192.168.1.100'
    ];
    final reasons = [null, null, 'Invalid password attempt', null];
    final i = index % users.length;

    return LoginAuditLogModel(
      id: 'login-log-$index',
      usernameOrEmail: users[i],
      loginStatus: statuses[i],
      ipAddress: ips[i],
      userAgent: 'Chrome 126.0 / Windows 11 (Secure Web Portal)',
      failureReason: reasons[i],
      createdAt: '2026-07-28 11:${15 + index}:00',
    );
  }
}

class ActivityAuditLogModel {
  final String id;
  final String actorName;
  final String moduleCode;
  final String featureCode;
  final String actionCode;
  final String recordId;
  final String actionSummary;
  final String createdAt;

  ActivityAuditLogModel({
    required this.id,
    required this.actorName,
    required this.moduleCode,
    required this.featureCode,
    required this.actionCode,
    required this.recordId,
    required this.actionSummary,
    required this.createdAt,
  });

  factory ActivityAuditLogModel.fallback(int index) {
    final actors = ['Directorate Admin', 'Tahir Mahmood', 'Asad Iqbal'];
    final modules = [
      'user_management',
      'prna_assessment',
      'verified_attendance'
    ];
    final features = ['users', 'create_assessment', 'attendance_reviews'];
    final actions = ['assign', 'approve', 'review'];
    final summaries = [
      'Assigned role "probation_officer" and Lahore District scope to user Tariq Mehmood.',
      'Approved PRNA initial assessment for supervisee Tariq Mehmood (Score: 22, Moderate).',
      'Officer reviewed and accepted GPS verified attendance receipt PPPS-VA-2026-1042.',
    ];
    final i = index % actors.length;

    return ActivityAuditLogModel(
      id: 'act-log-$index',
      actorName: actors[i],
      moduleCode: modules[i],
      featureCode: features[i],
      actionCode: actions[i],
      recordId: 'REC-2026-09$index',
      actionSummary: summaries[i],
      createdAt: '2026-07-28 10:${20 + index}:00',
    );
  }
}
