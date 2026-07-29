import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:web_portal/core/backend/supabase_config.dart';
import 'package:web_portal/core/backend/user_management_models.dart';

class UserManagementAdminWidget extends StatefulWidget {
  const UserManagementAdminWidget({Key? key}) : super(key: key);

  @override
  State<UserManagementAdminWidget> createState() =>
      _UserManagementAdminWidgetState();
}

class _UserManagementAdminWidgetState extends State<UserManagementAdminWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _usersHorizontalScrollController = ScrollController();
  final ScrollController _matrixHorizontalScrollController = ScrollController();
  final ScrollController _loginAuditHorizontalScrollController =
      ScrollController();
  final ScrollController _activityAuditHorizontalScrollController =
      ScrollController();

  final List<UserProfileModel> _users =
      List.generate(8, (i) => UserProfileModel.fallback(i));
  final List<LoginAuditLogModel> _loginLogs =
      List.generate(8, (i) => LoginAuditLogModel.fallback(i));
  final List<ActivityAuditLogModel> _activityLogs =
      List.generate(8, (i) => ActivityAuditLogModel.fallback(i));

  // Users Tab Filters
  String _userSearchQuery = '';
  String _userRoleFilter = 'All';
  String _userDistrictFilter = 'All';
  String _userStatusFilter = 'All';

  // Roles Tab Filters
  String _roleSearchQuery = '';

  // Login Audit Filters
  String _loginSearchQuery = '';
  String _loginStatusFilter = 'All';

  // Activity Audit Filters
  String _activitySearchQuery = '';
  String _activityModuleFilter = 'All';

  // Static Role Catalog
  final List<Map<String, dynamic>> _allRoles = const [
    {
      'code': 'super_admin',
      'name': 'Super Administrator',
      'desc': 'Full unrestricted system administration authority.',
      'system': true
    },
    {
      'code': 'system_admin',
      'name': 'System Administrator',
      'desc': 'User management, RBAC, and system configuration admin.',
      'system': true
    },
    {
      'code': 'directorate_general',
      'name': 'Directorate General Officer',
      'desc': 'Provincial oversight, analytics, and policy monitoring.',
      'system': true
    },
    {
      'code': 'divisional_admin',
      'name': 'Divisional Administrator',
      'desc': 'Divisional monitoring, officer supervision, and audits.',
      'system': true
    },
    {
      'code': 'district_admin',
      'name': 'District Administrator',
      'desc': 'District probation officer supervision and case plan approvals.',
      'system': true
    },
    {
      'code': 'supervisory_officer',
      'name': 'Supervisory Officer',
      'desc': 'Case reviews, field visit supervision, and attendance checks.',
      'system': true
    },
    {
      'code': 'probation_officer',
      'name': 'Probation Officer',
      'desc':
          'Direct supervision, PRNA assessments, case planning, and visits.',
      'system': true
    },
    {
      'code': 'parole_officer',
      'name': 'Parole Officer',
      'desc': 'Parolee supervision, compliance checks, and rehab tracking.',
      'system': true
    },
    {
      'code': 'data_entry_operator',
      'name': 'Data Entry Operator',
      'desc': 'OMIS data import and initial record verification.',
      'system': false
    },
    {
      'code': 'read_only_viewer',
      'name': 'Read-Only Viewer',
      'desc': 'Auditor view access without edit or approval permissions.',
      'system': false
    },
  ];

  // Role permission matrix state for interactive preview
  final Map<String, Map<String, bool>> _matrixState = {
    'Dashboard': {
      'read': true,
      'create': false,
      'update': false,
      'delete': false,
      'review': false,
      'approve': false,
      'manage': false
    },
    'User Management': {
      'read': true,
      'create': true,
      'update': true,
      'delete': false,
      'review': true,
      'approve': true,
      'manage': true
    },
    'OMIS Data': {
      'read': true,
      'create': true,
      'update': true,
      'delete': false,
      'review': false,
      'approve': false,
      'manage': false
    },
    'Supervisee Records': {
      'read': true,
      'create': true,
      'update': true,
      'delete': false,
      'review': true,
      'approve': false,
      'manage': false
    },
    'PRNA Assessment': {
      'read': true,
      'create': true,
      'update': true,
      'delete': false,
      'review': true,
      'approve': true,
      'manage': false
    },
    'Case Planning': {
      'read': true,
      'create': true,
      'update': true,
      'delete': false,
      'review': true,
      'approve': true,
      'manage': false
    },
    'Verified Attendance': {
      'read': true,
      'create': true,
      'update': true,
      'delete': false,
      'review': true,
      'approve': true,
      'manage': false
    },
    'Audit Trail': {
      'read': true,
      'create': false,
      'update': false,
      'delete': false,
      'review': false,
      'approve': false,
      'manage': false
    },
  };

  String _selectedRoleForMatrix = 'district_admin';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _usersHorizontalScrollController.dispose();
    _matrixHorizontalScrollController.dispose();
    _loginAuditHorizontalScrollController.dispose();
    _activityAuditHorizontalScrollController.dispose();
    super.dispose();
  }

  void _showCreateUserModal() {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final usernameCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();
    final confirmPasswordCtrl = TextEditingController();
    final designationCtrl = TextEditingController(text: 'Probation Officer');
    final cnicCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final officeCtrl = TextEditingController();

    String selectedOfficerType = 'Probation Officer';
    String selectedRole = 'probation_officer';
    String selectedDivision = 'Lahore Division';
    String selectedDistrict = 'Lahore';
    bool isActive = true;
    bool mustChangePassword = true;
    bool isSubmitting = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            officeCtrl.text = officeCtrl.text.isEmpty
                ? 'District Probation Office $selectedDistrict'
                : officeCtrl.text;

            bool isMismatch = (selectedOfficerType == 'Probation Officer' &&
                    selectedRole != 'probation_officer') ||
                (selectedOfficerType == 'Parole Officer' &&
                    selectedRole != 'parole_officer');

            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              title: Row(
                children: const [
                  Icon(Icons.person_add_alt_1, color: Color(0xFF0F5A47)),
                  SizedBox(width: 10),
                  Text('Create Authorised Officer Login Account',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              content: SizedBox(
                width: 600,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Master Admin Login & Profile Provisioning (Supabase Edge Function: create-raahnuma-user)',
                        style:
                            TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 14),

                      // Full Name & Username Row
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: nameCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Full Name *',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: usernameCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Username *',
                                hintText: 'e.g. tariq.mehmood',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Official Email & Designation
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: emailCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Official Email *',
                                hintText: 'officer@ppps.punjab.gov.pk',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: designationCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Designation',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Temporary Password & Confirm Password
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: passwordCtrl,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Temporary Password *',
                                hintText: 'Min 8 chars',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: confirmPasswordCtrl,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Confirm Temporary Password *',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Officer Type & Assigned Role
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: selectedOfficerType,
                              decoration: const InputDecoration(
                                labelText: 'Officer Type *',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              items: [
                                'Probation Officer',
                                'Parole Officer',
                                'Supervisory Officer',
                                'Administrative Officer',
                                'System Administrator'
                              ]
                                  .map((t) => DropdownMenuItem(
                                      value: t, child: Text(t)))
                                  .toList(),
                              onChanged: (v) {
                                setModalState(() {
                                  selectedOfficerType = v!;
                                  if (v == 'Probation Officer') {
                                    selectedRole = 'probation_officer';
                                  } else if (v == 'Parole Officer') {
                                    selectedRole = 'parole_officer';
                                  } else if (v == 'Supervisory Officer') {
                                    selectedRole = 'supervisory_officer';
                                  }
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: selectedRole,
                              decoration: const InputDecoration(
                                labelText: 'Assigned Role *',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              items: [
                                'probation_officer',
                                'parole_officer',
                                'supervisory_officer',
                                'district_admin',
                                'divisional_admin',
                                'system_admin'
                              ]
                                  .map((r) => DropdownMenuItem(
                                      value: r, child: Text(r)))
                                  .toList(),
                              onChanged: (v) =>
                                  setModalState(() => selectedRole = v!),
                            ),
                          ),
                        ],
                      ),
                      if (isMismatch) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade50,
                            border: Border.all(color: Colors.amber.shade400),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.warning_amber_rounded,
                                  color: Colors.amber.shade900, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Notice: Officer Type is "$selectedOfficerType" but assigned Role Code is "$selectedRole".',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.amber.shade900),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),

                      // Division, District, Office Scopes
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: selectedDivision,
                              decoration: const InputDecoration(
                                labelText: 'Division Scope *',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              items: [
                                'Lahore Division',
                                'Rawalpindi Division',
                                'Faisalabad Division',
                                'Multan Division',
                                'Gujranwala Division'
                              ]
                                  .map((d) => DropdownMenuItem(
                                      value: d, child: Text(d)))
                                  .toList(),
                              onChanged: (v) =>
                                  setModalState(() => selectedDivision = v!),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: selectedDistrict,
                              decoration: const InputDecoration(
                                labelText: 'District Scope *',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              items: [
                                'Lahore',
                                'Rawalpindi',
                                'Faisalabad',
                                'Multan',
                                'Gujranwala'
                              ]
                                  .map((d) => DropdownMenuItem(
                                      value: d, child: Text(d)))
                                  .toList(),
                              onChanged: (v) {
                                setModalState(() {
                                  selectedDistrict = v!;
                                  officeCtrl.text =
                                      'District Probation Office $selectedDistrict';
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      TextField(
                        controller: officeCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Office Name Scope *',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // CNIC & Phone Masked
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: cnicCtrl,
                              decoration: const InputDecoration(
                                labelText: 'CNIC Masked (Optional)',
                                hintText: '35201-1234567-1',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: phoneCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Phone Masked (Optional)',
                                hintText: '0300-1234567',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Toggles: Active Status & Must Change Password
                      Row(
                        children: [
                          Expanded(
                            child: SwitchListTile(
                              title: const Text('Active Status',
                                  style: TextStyle(fontSize: 12)),
                              value: isActive,
                              activeColor: const Color(0xFF0F5A47),
                              contentPadding: EdgeInsets.zero,
                              onChanged: (v) =>
                                  setModalState(() => isActive = v),
                            ),
                          ),
                          Expanded(
                            child: SwitchListTile(
                              title: const Text('Force Password Change',
                                  style: TextStyle(fontSize: 12)),
                              value: mustChangePassword,
                              activeColor: const Color(0xFF0F5A47),
                              contentPadding: EdgeInsets.zero,
                              onChanged: (v) =>
                                  setModalState(() => mustChangePassword = v),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting ? null : () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F5A47),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 12),
                  ),
                  icon: isSubmitting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.person_add,
                          color: Colors.white, size: 18),
                  label: const Text('Create Login and Profile',
                      style: TextStyle(color: Colors.white)),
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          // Validation
                          if (nameCtrl.text.trim().isEmpty ||
                              emailCtrl.text.trim().isEmpty ||
                              usernameCtrl.text.trim().isEmpty ||
                              passwordCtrl.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Please fill all required fields marked with *.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          if (!emailCtrl.text.contains('@')) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Please enter a valid official email address.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          if (passwordCtrl.text != confirmPasswordCtrl.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Temporary passwords do not match. Please re-enter.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          if (passwordCtrl.text.length < 8) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Temporary password must be at least 8 characters long.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          setModalState(() => isSubmitting = true);

                          final newUserId =
                              'user-master-${DateTime.now().millisecondsSinceEpoch}';
                          final fullName = nameCtrl.text.trim();
                          final email = emailCtrl.text.trim();
                          final username = usernameCtrl.text.trim();
                          final password = passwordCtrl.text;
                          final cnic = cnicCtrl.text.isEmpty
                              ? '35201-*******-1'
                              : cnicCtrl.text.trim();
                          final phone = phoneCtrl.text.isEmpty
                              ? '0300-*******'
                              : phoneCtrl.text.trim();
                          final designation = designationCtrl.text.isEmpty
                              ? selectedOfficerType
                              : designationCtrl.text.trim();

                          if (SupabaseConfig.hasBackend) {
                            try {
                              await Supabase.instance.client.functions.invoke(
                                'create-raahnuma-user',
                                body: {
                                  'full_name': fullName,
                                  'official_email': email,
                                  'username': username,
                                  'temporary_password': password,
                                  'designation': designation,
                                  'officer_type': selectedOfficerType,
                                  'role_code': selectedRole,
                                  'division': selectedDivision,
                                  'district': selectedDistrict,
                                  'office_name': officeCtrl.text.trim(),
                                  'phone_masked': phone,
                                  'cnic_masked': cnic,
                                  'must_change_password': mustChangePassword,
                                  'is_active': isActive,
                                },
                              );
                            } catch (_) {}
                          }

                          // Insert into UI model list
                          setState(() {
                            _users.insert(
                              0,
                              UserProfileModel(
                                id: newUserId,
                                fullName: fullName,
                                officialEmail: email,
                                username: username,
                                cnicMasked: cnic,
                                designation: designation,
                                officerType: selectedOfficerType,
                                district: selectedDistrict,
                                division: selectedDivision,
                                officeName: officeCtrl.text.trim(),
                                phoneMasked: phone,
                                isActive: isActive,
                                mustChangePassword: mustChangePassword,
                                createdAt: DateTime.now()
                                    .toIso8601String()
                                    .replaceAll('T', ' ')
                                    .substring(0, 19),
                                assignedRoleCode: selectedRole,
                                authStatus: 'Linked',
                              ),
                            );
                          });

                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'User login, profile, role and access scope created successfully.'),
                              backgroundColor: Color(0xFF0F5A47),
                              duration: Duration(seconds: 4),
                            ),
                          );
                        },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditUserModal(UserProfileModel user) {
    final nameCtrl = TextEditingController(text: user.fullName);
    final emailCtrl = TextEditingController(text: user.officialEmail);
    final usernameCtrl = TextEditingController(text: user.username);
    String selectedRole = user.assignedRoleCode;
    String selectedDistrict = user.district;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: const Text('Edit Authorised Officer Profile',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Full Name', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Official Email',
                      border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: usernameCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Username', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: const InputDecoration(
                      labelText: 'Assigned Role', border: OutlineInputBorder()),
                  items: [
                    'probation_officer',
                    'parole_officer',
                    'supervisory_officer',
                    'district_admin',
                    'divisional_admin',
                    'system_admin'
                  ]
                      .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                      .toList(),
                  onChanged: (v) => selectedRole = v!,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedDistrict,
                  decoration: const InputDecoration(
                      labelText: 'Assigned District Scope',
                      border: OutlineInputBorder()),
                  items: [
                    'Lahore',
                    'Rawalpindi',
                    'Faisalabad',
                    'Multan',
                    'Gujranwala'
                  ]
                      .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                      .toList(),
                  onChanged: (v) => selectedDistrict = v!,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F5A47)),
              onPressed: () {
                setState(() {
                  final idx = _users.indexWhere((x) => x.id == user.id);
                  if (idx != -1) {
                    _users[idx] = UserProfileModel(
                      id: user.id,
                      fullName:
                          nameCtrl.text.isEmpty ? user.fullName : nameCtrl.text,
                      officialEmail: emailCtrl.text.isEmpty
                          ? user.officialEmail
                          : emailCtrl.text,
                      username: usernameCtrl.text.isEmpty
                          ? user.username
                          : usernameCtrl.text,
                      cnicMasked: user.cnicMasked,
                      designation: user.designation,
                      officerType: user.officerType,
                      district: selectedDistrict,
                      division: user.division,
                      officeName: user.officeName,
                      phoneMasked: user.phoneMasked,
                      isActive: user.isActive,
                      createdAt: user.createdAt,
                      assignedRoleCode: selectedRole,
                      authStatus: user.authStatus,
                    );
                  }
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Officer profile updated successfully.'),
                    backgroundColor: Color(0xFF0F5A47),
                  ),
                );
              },
              child: const Text('Save Changes',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top Section Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          color: Colors.white,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 720;
              if (isCompact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'User Management & Security Administration',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Role-Based Access Control (RBAC), user scoping, login audits, and security configuration',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F5A47),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        icon: const Icon(Icons.person_add, size: 18),
                        label: const Text('Create User Account',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: _showCreateUserModal,
                      ),
                    ),
                  ],
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'User Management & Security Administration',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Role-Based Access Control (RBAC), user scoping, login audits, and security configuration',
                          style:
                              TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F5A47),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    icon: const Icon(Icons.person_add, size: 18),
                    label: const Text('Create User Account',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: _showCreateUserModal,
                  ),
                ],
              );
            },
          ),
        ),

        // Navigation Tabs Bar
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: const Color(0xFF0F5A47),
            unselectedLabelColor: const Color(0xFF64748B),
            indicatorColor: const Color(0xFF0F5A47),
            indicatorWeight: 3,
            tabs: const [
              Tab(icon: Icon(Icons.people_alt, size: 18), text: 'Users'),
              Tab(icon: Icon(Icons.badge, size: 18), text: 'Roles'),
              Tab(icon: Icon(Icons.vpn_key, size: 18), text: 'Permissions'),
              Tab(
                  icon: Icon(Icons.grid_on, size: 18),
                  text: 'Role Permission Matrix'),
              Tab(icon: Icon(Icons.map, size: 18), text: 'Access Scope'),
              Tab(
                  icon: Icon(Icons.history_toggle_off, size: 18),
                  text: 'Login Audit'),
              Tab(
                  icon: Icon(Icons.assignment_ind, size: 18),
                  text: 'Activity Audit'),
              Tab(
                  icon: Icon(Icons.admin_panel_settings, size: 18),
                  text: 'Security Settings'),
            ],
          ),
        ),

        // Tab Body Views
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildUsersTab(),
              _buildRolesTab(),
              _buildPermissionsTab(),
              _buildMatrixTab(),
              _buildAccessScopeTab(),
              _buildLoginAuditTab(),
              _buildActivityAuditTab(),
              _buildSecuritySettingsTab(),
            ],
          ),
        ),
      ],
    );
  }

  // ── TAB 1: USERS ───────────────────────────────────────────────────────────
  Widget _buildUsersSearchFilterBar() {
    final isFiltered = _userSearchQuery.isNotEmpty ||
        _userRoleFilter != 'All' ||
        _userDistrictFilter != 'All' ||
        _userStatusFilter != 'All';

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 260,
              child: TextField(
                onChanged: (val) => setState(() => _userSearchQuery = val),
                decoration: InputDecoration(
                  hintText: 'Search name, email, CNIC...',
                  prefixIcon: const Icon(Icons.search,
                      size: 18, color: Color(0xFF64748B)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                  ),
                  isDense: true,
                ),
              ),
            ),
            SizedBox(
              width: 170,
              child: DropdownButtonFormField<String>(
                value: _userRoleFilter,
                decoration: InputDecoration(
                  labelText: 'Role',
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  isDense: true,
                ),
                items: [
                  'All',
                  'probation_officer',
                  'parole_officer',
                  'supervisory_officer',
                  'district_admin',
                  'divisional_admin',
                  'system_admin'
                ]
                    .map((r) => DropdownMenuItem(
                        value: r,
                        child: Text(r, style: const TextStyle(fontSize: 12))))
                    .toList(),
                onChanged: (val) => setState(() => _userRoleFilter = val!),
              ),
            ),
            SizedBox(
              width: 140,
              child: DropdownButtonFormField<String>(
                value: _userDistrictFilter,
                decoration: InputDecoration(
                  labelText: 'District',
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  isDense: true,
                ),
                items: [
                  'All',
                  'Lahore',
                  'Rawalpindi',
                  'Faisalabad',
                  'Multan',
                  'Gujranwala'
                ]
                    .map((d) => DropdownMenuItem(
                        value: d,
                        child: Text(d, style: const TextStyle(fontSize: 12))))
                    .toList(),
                onChanged: (val) => setState(() => _userDistrictFilter = val!),
              ),
            ),
            SizedBox(
              width: 120,
              child: DropdownButtonFormField<String>(
                value: _userStatusFilter,
                decoration: InputDecoration(
                  labelText: 'Status',
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  isDense: true,
                ),
                items: ['All', 'Active', 'Inactive']
                    .map((s) => DropdownMenuItem(
                        value: s,
                        child: Text(s, style: const TextStyle(fontSize: 12))))
                    .toList(),
                onChanged: (val) => setState(() => _userStatusFilter = val!),
              ),
            ),
            if (isFiltered)
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _userSearchQuery = '';
                    _userRoleFilter = 'All';
                    _userDistrictFilter = 'All';
                    _userStatusFilter = 'All';
                  });
                },
                icon: const Icon(Icons.clear, size: 16, color: Colors.red),
                label: const Text('Reset Filters',
                    style: TextStyle(color: Colors.red, fontSize: 12)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersTab() {
    final filteredUsers = _users.where((u) {
      final matchesSearch = _userSearchQuery.isEmpty ||
          u.fullName.toLowerCase().contains(_userSearchQuery.toLowerCase()) ||
          u.username.toLowerCase().contains(_userSearchQuery.toLowerCase()) ||
          u.officialEmail
              .toLowerCase()
              .contains(_userSearchQuery.toLowerCase()) ||
          u.cnicMasked.contains(_userSearchQuery);

      final matchesRole =
          _userRoleFilter == 'All' || u.assignedRoleCode == _userRoleFilter;

      final matchesDistrict = _userDistrictFilter == 'All' ||
          u.district.toLowerCase() == _userDistrictFilter.toLowerCase();

      final matchesStatus = _userStatusFilter == 'All' ||
          (_userStatusFilter == 'Active' && u.isActive) ||
          (_userStatusFilter == 'Inactive' && !u.isActive);

      return matchesSearch && matchesRole && matchesDistrict && matchesStatus;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUsersSearchFilterBar(),
          Card(
            elevation: 1.5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Scrollbar(
                    controller: _usersHorizontalScrollController,
                    thumbVisibility: true,
                    trackVisibility: true,
                    child: SingleChildScrollView(
                      controller: _usersHorizontalScrollController,
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: math.max(constraints.maxWidth, 1080),
                        ),
                        child: DataTable(
                          headingRowColor:
                              WidgetStateProperty.all(const Color(0xFFF1F5F9)),
                          columnSpacing: 18,
                          horizontalMargin: 16,
                          columns: const [
                            DataColumn(
                                label: Text('Official Name & Username',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Email & CNIC',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Officer Type',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Auth Status',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Assigned Role',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Access Scope',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Status',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Actions',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                          ],
                          rows: filteredUsers.map((u) {
                            return DataRow(cells: [
                              DataCell(
                                SizedBox(
                                  width: 160,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        u.fullName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        u.username,
                                        style: const TextStyle(
                                            fontSize: 10, color: Colors.grey),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: 180,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        u.officialEmail,
                                        style: const TextStyle(fontSize: 11),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        u.cnicMasked,
                                        style: const TextStyle(
                                            fontSize: 10, color: Colors.grey),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: 120,
                                  child: Text(
                                    u.officerType,
                                    style: const TextStyle(fontSize: 11),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              DataCell(
                                Chip(
                                  avatar: const Icon(Icons.check_circle,
                                      size: 14, color: Color(0xFF0F5A47)),
                                  label: Text(
                                    u.authStatus,
                                    style: const TextStyle(
                                        fontSize: 9.5,
                                        color: Color(0xFF0F5A47),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor: const Color(0xFFF0F7F4),
                                  visualDensity: VisualDensity.compact,
                                ),
                              ),
                              DataCell(
                                Chip(
                                  label: Text(
                                    u.assignedRoleCode,
                                    style: const TextStyle(
                                        fontSize: 9.5,
                                        color: Color(0xFF0F5A47)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  backgroundColor: const Color(0xFFF0F7F4),
                                  visualDensity: VisualDensity.compact,
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: 110,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        u.district,
                                        style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        u.division,
                                        style: const TextStyle(
                                            fontSize: 9.5, color: Colors.grey),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              DataCell(
                                Chip(
                                  label: Text(
                                    u.isActive ? 'Active' : 'Inactive',
                                    style: const TextStyle(
                                        fontSize: 9.5, color: Colors.white),
                                  ),
                                  backgroundColor: u.isActive
                                      ? const Color(0xFF0F5A47)
                                      : Colors.red.shade800,
                                  visualDensity: VisualDensity.compact,
                                ),
                              ),
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          size: 16, color: Color(0xFF0F5A47)),
                                      onPressed: () => _showEditUserModal(u),
                                      tooltip: 'Edit Profile & Scope',
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        u.isActive
                                            ? Icons.block
                                            : Icons.check_circle,
                                        size: 16,
                                        color: u.isActive
                                            ? Colors.red.shade800
                                            : Colors.green.shade800,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          final idx = _users
                                              .indexWhere((x) => x.id == u.id);
                                          if (idx != -1) {
                                            _users[idx] = UserProfileModel(
                                              id: u.id,
                                              fullName: u.fullName,
                                              officialEmail: u.officialEmail,
                                              username: u.username,
                                              cnicMasked: u.cnicMasked,
                                              designation: u.designation,
                                              officerType: u.officerType,
                                              district: u.district,
                                              division: u.division,
                                              officeName: u.officeName,
                                              phoneMasked: u.phoneMasked,
                                              isActive: !u.isActive,
                                              createdAt: u.createdAt,
                                              assignedRoleCode:
                                                  u.assignedRoleCode,
                                              authStatus: u.authStatus,
                                            );
                                          }
                                        });
                                      },
                                      tooltip: u.isActive
                                          ? 'Deactivate User'
                                          : 'Activate User',
                                    ),
                                  ],
                                ),
                              ),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── TAB 2: ROLES ───────────────────────────────────────────────────────────
  Widget _buildRolesTab() {
    final filteredRoles = _allRoles.where((r) {
      if (_roleSearchQuery.isEmpty) return true;
      final q = _roleSearchQuery.toLowerCase();
      return r['name'].toString().toLowerCase().contains(q) ||
          r['code'].toString().toLowerCase().contains(q) ||
          r['desc'].toString().toLowerCase().contains(q);
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                onChanged: (val) => setState(() => _roleSearchQuery = val),
                decoration: InputDecoration(
                  hintText: 'Search roles by title, code, or description...',
                  prefixIcon: const Icon(Icons.search,
                      size: 18, color: Color(0xFF64748B)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                  ),
                  isDense: true,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredRoles.length,
              itemBuilder: (context, index) {
                final r = filteredRoles[index];
                return Card(
                  elevation: 1.5,
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xFFF0F7F4),
                          child: Text('${index + 1}',
                              style: const TextStyle(
                                  color: Color(0xFF0F5A47),
                                  fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${r['name']} (${r['code']})',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                r['desc'] as String,
                                style: const TextStyle(
                                    fontSize: 11.5, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Chip(
                          label: Text(
                            r['system'] == true ? 'System Role' : 'Custom Role',
                            style: const TextStyle(fontSize: 9.5),
                          ),
                          backgroundColor: const Color(0xFFEFF6FF),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── TAB 3: PERMISSIONS ─────────────────────────────────────────────────────
  Widget _buildPermissionsTab() {
    final modules = [
      'Dashboard',
      'User Management',
      'OMIS Data',
      'Supervisee Records',
      'Officer Caseload',
      'Check-Ins',
      'Verified Attendance',
      'Assigned Activities',
      'PRNA Assessment',
      'Case Planning',
      'Rehabilitation Referrals',
      'Alerts and Compliance',
      'Reports and Analytics',
      'Audit Trail',
      'System Settings'
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: modules.length,
      itemBuilder: (context, index) {
        final mod = modules[index];
        return ExpansionTile(
          title: Text(mod,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          leading: const Icon(Icons.folder_special, color: Color(0xFF0F5A47)),
          children: [
            ListTile(
              dense: true,
              title: Text('$mod: Standard Read & View Permission'),
              subtitle: Text('${mod.toLowerCase().replaceAll(' ', '_')}:read'),
            ),
            ListTile(
              dense: true,
              title: Text('$mod: Create & Entry Permission'),
              subtitle:
                  Text('${mod.toLowerCase().replaceAll(' ', '_')}:create'),
            ),
            ListTile(
              dense: true,
              title: Text('$mod: Approval & Management Permission'),
              subtitle:
                  Text('${mod.toLowerCase().replaceAll(' ', '_')}:approve'),
            ),
          ],
        );
      },
    );
  }

  // ── TAB 4: ROLE PERMISSION MATRIX ──────────────────────────────────────────
  Widget _buildMatrixTab() {
    final actions = [
      'read',
      'create',
      'update',
      'delete',
      'review',
      'approve',
      'manage'
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                children: [
                  const Text('Select Role to Configure: ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  DropdownButton<String>(
                    value: _selectedRoleForMatrix,
                    items: [
                      'district_admin',
                      'probation_officer',
                      'parole_officer',
                      'supervisory_officer',
                      'divisional_admin',
                      'directorate_general'
                    ]
                        .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedRoleForMatrix = val!;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 1.5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Scrollbar(
                    controller: _matrixHorizontalScrollController,
                    thumbVisibility: true,
                    trackVisibility: true,
                    child: SingleChildScrollView(
                      controller: _matrixHorizontalScrollController,
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: math.max(constraints.maxWidth, 850),
                        ),
                        child: DataTable(
                          headingRowColor:
                              WidgetStateProperty.all(const Color(0xFFF1F5F9)),
                          columns: [
                            const DataColumn(
                                label: Text('Module / Sub-Feature',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            ...actions.map((act) => DataColumn(
                                label: Text(act.toUpperCase(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11)))),
                          ],
                          rows: _matrixState.keys.map((mod) {
                            final actMap = _matrixState[mod]!;
                            return DataRow(cells: [
                              DataCell(Text(mod,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12))),
                              ...actions.map((act) {
                                final val = actMap[act] ?? false;
                                return DataCell(Checkbox(
                                  value: val,
                                  activeColor: const Color(0xFF0F5A47),
                                  onChanged: (newVal) {
                                    setState(() {
                                      actMap[act] = newVal ?? false;
                                    });
                                  },
                                ));
                              }).toList(),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── TAB 5: ACCESS SCOPE ───────────────────────────────────────────────────
  Widget _buildAccessScopeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Data Boundaries & Access Scoping Hierarchy',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          const Text(
              'Configure Geographic and Caseload access restrictions for operational roles.',
              style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 16),
          Card(
            elevation: 1.5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const Padding(
              padding: EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '1. Provincial Scope (Directorate General & Super Admin)',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Color(0xFF0F5A47))),
                  SizedBox(height: 4),
                  Text('Access across all 36 Districts of Punjab.',
                      style: TextStyle(fontSize: 12)),
                  SizedBox(height: 14),
                  Text('2. Divisional Scope (Divisional Administrators)',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Color(0xFF0F5A47))),
                  SizedBox(height: 4),
                  Text(
                      'Access across assigned Division (e.g., Lahore Division: Lahore, Kasur, Nankana Sahib, Sheikhupura).',
                      style: TextStyle(fontSize: 12)),
                  SizedBox(height: 14),
                  Text(
                      '3. District Scope (District Administrators & Supervisory Officers)',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Color(0xFF0F5A47))),
                  SizedBox(height: 4),
                  Text(
                      'Access restricted to assigned District bounds (e.g., District Lahore).',
                      style: TextStyle(fontSize: 12)),
                  SizedBox(height: 14),
                  Text(
                      '4. Officer Caseload Scope (Probation & Parole Officers)',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Color(0xFF0F5A47))),
                  SizedBox(height: 4),
                  Text(
                      'Access strictly limited to assigned supervisees under probation or parole orders.',
                      style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── TAB 6: LOGIN AUDIT ────────────────────────────────────────────────────
  Widget _buildLoginAuditTab() {
    final filteredLogs = _loginLogs.where((l) {
      final matchesSearch = _loginSearchQuery.isEmpty ||
          l.usernameOrEmail
              .toLowerCase()
              .contains(_loginSearchQuery.toLowerCase()) ||
          l.ipAddress.contains(_loginSearchQuery) ||
          (l.failureReason != null &&
              l.failureReason!
                  .toLowerCase()
                  .contains(_loginSearchQuery.toLowerCase()));
      final matchesStatus =
          _loginStatusFilter == 'All' || l.loginStatus == _loginStatusFilter;
      return matchesSearch && matchesStatus;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: 260,
                    child: TextField(
                      onChanged: (val) =>
                          setState(() => _loginSearchQuery = val),
                      decoration: InputDecoration(
                        hintText: 'Search username, IP, reason...',
                        prefixIcon: const Icon(Icons.search,
                            size: 18, color: Color(0xFF64748B)),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Color(0xFFCBD5E1)),
                        ),
                        isDense: true,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 160,
                    child: DropdownButtonFormField<String>(
                      value: _loginStatusFilter,
                      decoration: InputDecoration(
                        labelText: 'Status',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        isDense: true,
                      ),
                      items: ['All', 'Success', 'Failed']
                          .map((s) => DropdownMenuItem(
                              value: s,
                              child: Text(s,
                                  style: const TextStyle(fontSize: 12))))
                          .toList(),
                      onChanged: (val) =>
                          setState(() => _loginStatusFilter = val!),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 1.5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Scrollbar(
                    controller: _loginAuditHorizontalScrollController,
                    thumbVisibility: true,
                    trackVisibility: true,
                    child: SingleChildScrollView(
                      controller: _loginAuditHorizontalScrollController,
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: math.max(constraints.maxWidth, 880),
                        ),
                        child: DataTable(
                          headingRowColor:
                              WidgetStateProperty.all(const Color(0xFFF1F5F9)),
                          columns: const [
                            DataColumn(
                                label: Text('Username / Email',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Login Status',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('IP Address',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Device / User Agent',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Failure Reason',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Date & Time',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                          ],
                          rows: filteredLogs.map((l) {
                            return DataRow(cells: [
                              DataCell(
                                SizedBox(
                                  width: 140,
                                  child: Text(l.usernameOrEmail,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                              DataCell(Chip(
                                label: Text(l.loginStatus,
                                    style: const TextStyle(
                                        fontSize: 9.5, color: Colors.white)),
                                backgroundColor: l.loginStatus == 'Success'
                                    ? const Color(0xFF0F5A47)
                                    : l.loginStatus == 'Failed'
                                        ? Colors.red.shade800
                                        : Colors.orange.shade800,
                                visualDensity: VisualDensity.compact,
                              )),
                              DataCell(Text(l.ipAddress,
                                  style: const TextStyle(fontSize: 11))),
                              DataCell(
                                SizedBox(
                                  width: 200,
                                  child: Text(l.userAgent,
                                      style: const TextStyle(fontSize: 11),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: 150,
                                  child: Text(l.failureReason ?? 'None',
                                      style: const TextStyle(fontSize: 11),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                              DataCell(Text(l.createdAt,
                                  style: const TextStyle(fontSize: 11))),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── TAB 7: ACTIVITY AUDIT ─────────────────────────────────────────────────
  Widget _buildActivityAuditTab() {
    final filteredLogs = _activityLogs.where((a) {
      final matchesSearch = _activitySearchQuery.isEmpty ||
          a.actorName
              .toLowerCase()
              .contains(_activitySearchQuery.toLowerCase()) ||
          a.recordId
              .toLowerCase()
              .contains(_activitySearchQuery.toLowerCase()) ||
          a.actionSummary
              .toLowerCase()
              .contains(_activitySearchQuery.toLowerCase());
      final matchesModule = _activityModuleFilter == 'All' ||
          a.moduleCode == _activityModuleFilter;
      return matchesSearch && matchesModule;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: 260,
                    child: TextField(
                      onChanged: (val) =>
                          setState(() => _activitySearchQuery = val),
                      decoration: InputDecoration(
                        hintText: 'Search actor, record ID, summary...',
                        prefixIcon: const Icon(Icons.search,
                            size: 18, color: Color(0xFF64748B)),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Color(0xFFCBD5E1)),
                        ),
                        isDense: true,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: DropdownButtonFormField<String>(
                      value: _activityModuleFilter,
                      decoration: InputDecoration(
                        labelText: 'Module',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        isDense: true,
                      ),
                      items: [
                        'All',
                        'user_management',
                        'prna_assessment',
                        'verified_attendance'
                      ]
                          .map((m) => DropdownMenuItem(
                              value: m,
                              child: Text(m,
                                  style: const TextStyle(fontSize: 12))))
                          .toList(),
                      onChanged: (val) =>
                          setState(() => _activityModuleFilter = val!),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 1.5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Scrollbar(
                    controller: _activityAuditHorizontalScrollController,
                    thumbVisibility: true,
                    trackVisibility: true,
                    child: SingleChildScrollView(
                      controller: _activityAuditHorizontalScrollController,
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: math.max(constraints.maxWidth, 920),
                        ),
                        child: DataTable(
                          headingRowColor:
                              WidgetStateProperty.all(const Color(0xFFF1F5F9)),
                          columns: const [
                            DataColumn(
                                label: Text('Actor Name',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Module / Feature',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Action',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Record ID',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Action Summary',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Timestamp',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                          ],
                          rows: filteredLogs.map((a) {
                            return DataRow(cells: [
                              DataCell(
                                SizedBox(
                                  width: 140,
                                  child: Text(a.actorName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                      '${a.moduleCode} / ${a.featureCode}',
                                      style: const TextStyle(fontSize: 11),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                              DataCell(Chip(
                                label: Text(a.actionCode,
                                    style: const TextStyle(
                                        fontSize: 9.5,
                                        color: Color(0xFF0F5A47))),
                                backgroundColor: const Color(0xFFF0F7F4),
                                visualDensity: VisualDensity.compact,
                              )),
                              DataCell(Text(a.recordId,
                                  style: const TextStyle(fontSize: 11))),
                              DataCell(
                                SizedBox(
                                  width: 250,
                                  child: Text(a.actionSummary,
                                      style: const TextStyle(fontSize: 11),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                              DataCell(Text(a.createdAt,
                                  style: const TextStyle(fontSize: 11))),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── TAB 8: SECURITY SETTINGS ──────────────────────────────────────────────
  Widget _buildSecuritySettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 1.5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('System Security & Password Policy Settings',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 16),
                  _buildSettingRow('Minimum Password Length',
                      '8 Characters (Uppercase, Number, Symbol)'),
                  _buildSettingRow(
                      'Session Idle Timeout', '30 Minutes Automatic Lock'),
                  _buildSettingRow('Failed Login Lockout',
                      '5 Consecutive Attempts (15 Mins Lockout)'),
                  _buildSettingRow('Force First Login Change',
                      'Enabled for all new officer profiles'),
                  _buildSettingRow('Audit Log Retention',
                      'Permanent Audit Trail (Insert-Only)'),
                  const Divider(height: 24),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF93C5FD)),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.security,
                            color: Color(0xFF1D4ED8), size: 22),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Roadmap Notice: “Two-factor authentication (SMS OTP or TOTP Authenticator App) may be enabled in restricted production deployment following Home Department cybersecurity clearance.”',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E40AF),
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingRow(String title, String val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              val,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF0F5A47),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
