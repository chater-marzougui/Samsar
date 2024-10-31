import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:samsar/helpers/user_manager.dart';
import 'package:samsar/values/app_constants.dart';
import '../../Widgets/widgets.dart';
import '../../l10n/l10n.dart';
import '../../values/structures.dart';

class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final UserManager _userManager = UserManager();
  final db = FirebaseFirestore.instance;
  SamsarUser? samsarUser;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  bool _isLoading = false;

  Future<void> _submitSupportRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await db.collection('supportRequests').doc(samsarUser!.uid).set({
        'name': _nameController.text,
        'email': samsarUser!.email,
        'userId': samsarUser!.uid,
        'messages': FieldValue.arrayUnion([
          {
            'timestamp': Timestamp.now(),
            'subject': _subjectController.text,
            'message': _messageController.text,
            'answered': false,
          }
        ])
      }, SetOptions(merge: true));

      if (mounted) {
        showSnackBar(context, S.of(context).supportRequestSent);
      }

      _subjectController.clear();
      _messageController.clear();
    } catch (e) {
      if (mounted) {
        showSnackBar(context, S.of(context).supportRequestFailed);
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (mounted) {
      setState(() {
        samsarUser = _userManager.samsarUser!;
        _nameController.text = samsarUser!.displayName;
        _emailController.text = samsarUser!.email;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).contactSupport),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    buildTextField(
                      _nameController,
                      S.of(context).name,
                      S.of(context).enterName,
                    ),
                    buildTextField(
                      _emailController,
                      S.of(context).email,
                      S.of(context).enterEmail,
                      email: true,
                    ),
                    buildTextField(
                      _subjectController,
                      S.of(context).subject,
                      S.of(context).enterSubject,
                    ),
                    buildTextField(
                      _messageController,
                      S.of(context).message,
                      S.of(context).describeIssue,
                      maxLines: 10,
                    ),
                    SizedBox(height: 20),
                    _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                          style: theme.elevatedButtonTheme.style,
                          onPressed: _submitSupportRequest,
                          child: Text(S.of(context).submit),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
              buildInfoCard(
                context,
                Icons.support_agent_sharp,
                S.of(context).contactUsDirectly,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildDetailRow(context, Icons.location_on_outlined,
                        S.of(context).location, AppConstants.contactInfo.location,
                        wrapText: true),
                    buildDetailRow(context, Icons.phone, S.of(context).phone,
                        AppConstants.contactInfo.phoneNumber),
                    buildDetailRow(context, Icons.email, S.of(context).email,
                        AppConstants.contactInfo.email,
                        wrapText: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      TextEditingController controller, String label, String hint,
      {bool email = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: email ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(),
        ),
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return S.of(context).fieldRequired(label);
          }
          if (email && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
            return S.of(context).invalidEmail;
          }
          return null;
        },
      ),
    );
  }
}
