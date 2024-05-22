import 'package:flutter/material.dart';
import 'package:frontend/components/custom_text_field.dart';
import 'package:frontend/controllers/profile_controller.dart';

class ReportIssueView extends StatefulWidget {
  const ReportIssueView({Key? key}) : super(key: key);

  @override
  _ReportIssueViewState createState() => _ReportIssueViewState();
}

class _ReportIssueViewState extends State<ReportIssueView> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _issueController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text('Report Issue', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[900],
      ),
      backgroundColor: Colors.blue[900],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(controller: _subjectController, label: 'Subject', icon: Icons.subject),
            const SizedBox(height: 20),
            TextField(
              controller: _issueController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Issue',
                prefixIcon: const Icon(Icons.report_problem),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _reportIssue,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue[900],
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Submit', style: TextStyle(fontSize: 18.0)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _reportIssue() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final String subject = _subjectController.text;
      final String issue = _issueController.text;

      if (subject.isEmpty || issue.isEmpty) {
        throw Exception('All fields are required.');
      }

      await ProfileController.reportIssue(subject, issue);

      setState(() {
        _isLoading = false;
      });

      // Show success message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Issue reported successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (error) {
      setState(() {
        _isLoading = false;
      });

      // Show error message
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
