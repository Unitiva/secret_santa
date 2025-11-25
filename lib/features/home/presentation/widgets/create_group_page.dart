import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:secret_santa/core/utils/size_extension.dart';

import '../../../../core/utils/const.dart';
import '../../data/models/user_model.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key, required this.backToInitial});

  final VoidCallback backToInitial;

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  String groupName = '';

  List<User> users = [];

  Map<User, User> assignments = {};

  bool isGeneratingPDF = false;

  TextEditingController groupNameController = TextEditingController();

  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    groupNameController.dispose();
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void _addUser() {
    FocusScope.of(context).unfocus();
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    if (name.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.red[500],
          content: Text(tr('messages.name_and_email_required')),
        ),
      );
      return;
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.red[500],
          content: Text(tr('messages.invalid_email')),
        ),
      );
      return;
    }
    setState(() {
      users.add(User(name: name, email: email));
      nameController.clear();
      emailController.clear();
    });
  }

  void _removeUser(int index) {
    setState(() {
      assignments.clear();
      users.removeAt(index);
    });
  }

  void _importFromCSV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (result != null) {
      final file = result.files.first;
      final content = String.fromCharCodes(file.bytes!);
      final lines = content.split('\n');
      for (var line in lines.skip(1)) {
        final parts = line.split(',');
        if (parts.length >= 2) {
          final name = parts[0].trim();
          final email = parts[1].trim();
          if (name.isNotEmpty && email.isNotEmpty) {
            users.add(User(name: name, email: email));
          }
        }
      }
    }
    setState(() {});
  }

  void _generateAssignments() {
    if (users.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.red[500],
          content: Text(tr('group.at_least_two_users')),
        ),
      );
      return;
    }
    // Shuffle and assign
    final shuffled = List<User>.from(users)..shuffle();
    assignments.clear();
    for (int i = 0; i < shuffled.length; i++) {
      assignments[shuffled[i]] = shuffled[(i + 1) % shuffled.length];
    }
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.green[500],
        content: Text(tr('group.assignments_generated')),
      ),
    );
  }

  Future<void> _generatePDF() async {
    if (assignments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.red[500],
          content: Text(tr('group.no_assignments_to_export')),
        ),
      );
      return;
    }

    setState(() {
      isGeneratingPDF = true;
    });

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                tr(
                  'group.assignments_secret_santa',
                  namedArgs: {'groupName': groupName},
                ),
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              ...assignments.entries.map(
                (entry) => pw.Text(
                  '${entry.key.displayName} -> ${entry.value.displayName}',
                  style: pw.TextStyle(fontSize: 16),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'assegnazioni_secret_santa.pdf',
    );

    setState(() {
      isGeneratingPDF = false;
    });
  }

  Future<void> _exportToCSV() async {
    if (users.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.red[500],
          content: Text(tr('group.no_users_to_export')),
        ),
      );
      return;
    }

    String csv = 'Name,Email\n';
    for (var user in users) {
      csv += '${user.name},${user.email}\n';
    }
    await Share.share(csv, subject: tr('group.export_csv'));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => widget.backToInitial(),
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary[100]!.withValues(
                              alpha: 0.2,
                            ),
                            blurRadius: 8.r,
                            offset: Offset(0, 2.h),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: AppColors.primary[900],
                        size: 24.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr('group.create_group'),
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary[900],
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Group Name
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary[100]!.withValues(alpha: 0.2),
                          blurRadius: 8.r,
                          offset: Offset(0, 2.h),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: groupNameController,
                      decoration: InputDecoration(
                        labelText: tr('group.group_name'),
                        border: InputBorder.none,
                        labelStyle: TextStyle(
                          color: AppColors.primary[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.primary[900],
                      ),
                      onChanged: (value) {
                        setState(() {
                          groupName = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Add User Form
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary[100]!.withValues(alpha: 0.2),
                          blurRadius: 8.r,
                          offset: Offset(0, 2.h),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr('group.add_users'),
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary[900],
                          ),
                        ),
                        SizedBox(height: 16.h),
                        // Name Field
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: tr('group.name'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(
                                color: AppColors.primary[200]!,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(
                                color: AppColors.primary[500]!,
                              ),
                            ),
                            labelStyle: TextStyle(
                              color: AppColors.primary[600],
                            ),
                          ),
                          style: TextStyle(color: AppColors.primary[900]),
                        ),
                        SizedBox(height: 12.h),
                        // Email Field
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: tr('group.email'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(
                                color: AppColors.primary[200]!,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(
                                color: AppColors.primary[500]!,
                              ),
                            ),
                            labelStyle: TextStyle(
                              color: AppColors.primary[600],
                            ),
                          ),
                          style: TextStyle(color: AppColors.primary[900]),
                        ),
                        SizedBox(height: 16.h),
                        // Add Button
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: const [
                                  Color(0xFF654AD2),
                                  Color(0xFF2173CF),
                                  Color(0xFF247CCC),
                                  Color(0xFF36B1BD),
                                ],
                                stops: const [0.0, 0.4, 0.49, 1.0],
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12.r),
                                onTap: _addUser,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 8.h,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 18.sp,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        tr('group.add_user'),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Import CSV Button
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _importFromCSV,
                      icon: Icon(
                        Icons.file_upload,
                        color: AppColors.primary[500],
                      ),
                      label: Text(
                        tr('group.import_csv'),
                        style: TextStyle(color: AppColors.primary[500]),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: AppColors.primary[500]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 12.h,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary[100]!.withValues(alpha: 0.2),
                      blurRadius: 8.r,
                      offset: Offset(0, 2.h),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${tr('group.users')} (${users.length})',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary[900],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    SizedBox(
                      height: 200.h,
                      child: users.isEmpty
                          ? Center(
                              child: Text(
                                tr('group.no_users_added'),
                                style: TextStyle(
                                  color: AppColors.primary[600],
                                  fontSize: 16.sp,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                final user = users[index];
                                return Container(
                                  margin: EdgeInsets.only(bottom: 8.h),
                                  padding: EdgeInsets.all(12.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary[50],
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              user.displayName,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.primary[900],
                                                fontSize: 16.sp,
                                              ),
                                            ),
                                            Text(
                                              user.email,
                                              style: TextStyle(
                                                color: AppColors.primary[600],
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: AppColors.red[500],
                                          size: 20.sp,
                                        ),
                                        onPressed: () => _removeUser(index),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Column(
                children: [
                  // Generate Assignments Button
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: const [
                          Color(0xFF654AD2),
                          Color(0xFF2173CF),
                          Color(0xFF247CCC),
                          Color(0xFF36B1BD),
                        ],
                        stops: const [0.0, 0.4, 0.49, 1.0],
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12.r),
                        onTap: _generateAssignments,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 16.w,
                          ),
                          child: Center(
                            child: Text(
                              tr('group.generate_assignments'),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),
                  // Generate PDF Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: (!isGeneratingPDF) ? _generatePDF : null,
                      icon: isGeneratingPDF
                          ? SizedBox(
                              width: 20.sp,
                              height: 20.sp,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Icon(
                              Icons.picture_as_pdf,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                      label: Text(
                        isGeneratingPDF
                            ? tr('group.generating')
                            : tr('group.generate_pdf'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary[500],
                        side: BorderSide(color: Colors.white, width: 2),
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 16.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 2,
                        shadowColor: AppColors.red[100]!.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Export CSV Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _exportToCSV,
                      icon: Icon(
                        Icons.download,
                        color: AppColors.cyan,
                        size: 20.sp,
                      ),
                      label: Text(
                        tr('group.export_csv'),
                        style: TextStyle(
                          color: AppColors.cyan,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: AppColors.cyan, width: 2),
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 16.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
