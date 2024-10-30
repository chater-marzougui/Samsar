import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:samsar/helpers/user_manager.dart';
import 'package:samsar/values/app_constants.dart';
import '../../Widgets/widgets.dart';
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
        showSnackBar(context, 'Support request sent successfully!');
      }

      _subjectController.clear();
      _messageController.clear();
    } catch (e) {
      if (mounted) {
        showSnackBar(
            context, 'Failed to send support request. Please try again.');
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
        title: Text('Contact Support'),
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
                    buildTextField(_nameController, 'Name', 'Enter your name'),
                    buildTextField(
                        _emailController, 'Email', 'Enter your email',
                        email: true),
                    buildTextField(
                        _subjectController, 'Subject', 'Enter the subject'),
                    buildTextField(
                      _messageController,
                      'Message',
                      'Describe your issue',
                      maxLines: 10,
                    ),
                    SizedBox(height: 20),
                    _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            style: theme.elevatedButtonTheme.style,
                            onPressed: _submitSupportRequest,
                            child: Text('Submit'),
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              buildInfoCard(
                context,
                Icons.support_agent_sharp,
                'Or Contact Us Directly',
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildDetailRow(context, Icons.location_on_outlined,
                        'Location', AppConstants.contactInfo.location,
                        wrapText: true),
                    buildDetailRow(context, Icons.phone, 'Phone',
                        AppConstants.contactInfo.phoneNumber),
                    buildDetailRow(context, Icons.email, 'Email',
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
            return '$label is required';
          }
          if (email && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
            return 'Enter a valid email address';
          }
          return null;
        },
      ),
    );
  }
}
