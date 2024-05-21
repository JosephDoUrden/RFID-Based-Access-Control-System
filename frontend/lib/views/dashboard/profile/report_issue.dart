import 'package:flutter/material.dart';
import 'package:frontend/components/custom_text_field.dart';
import 'package:frontend/controllers/profile_controller.dart';

class ReportIssueView extends StatefulWidget {
  const ReportIssueView({
    Key? key,
    required this.subject,
    required this.issue,
  }) : super(key: key);

  final String subject;
  final String issue;

  @override
  _ReportIssueViewState createState() => _ReportIssueViewState();
}

class _ReportIssueViewState extends State<ReportIssueView> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _issueController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _subjectController.text = widget.subject;
    _issueController.text = widget.issue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title:
            const Text('Report Issue', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[900],
      ),
      backgroundColor: Colors.blue[900],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
                controller: _subjectController,
                label: 'Subject',
                icon: Icons.person),
            const SizedBox(height: 10),
            TextField(
              controller: _issueController,
              maxLines: 5, 
              decoration: InputDecoration(
                labelText: 'Issue',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _reportIssue,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: Colors.white,
              ),
              child: Text('Submit',
                  style: TextStyle(fontSize: 18.0, color: Colors.blue[900])),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _reportIssue() async {
    try {
      final String subject = _subjectController.text;
      final String issue = _issueController.text;

      await ProfileController.reportIssue(subject, issue);

      // Profile updated successfully, navigate back or show success message
      Navigator.pop(context);
    } catch (error) {
      // Handle error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to submit: $error'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
