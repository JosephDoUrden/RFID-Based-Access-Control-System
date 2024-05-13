import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/controllers/dashboard_controller.dart';
import 'package:frontend/models/log.dart';
import 'package:frontend/models/user_profile.dart';

class AccessLogsView extends StatefulWidget {
  const AccessLogsView({super.key});

  @override
  State<AccessLogsView> createState() => _AccessLogsViewState();
}

class _AccessLogsViewState extends State<AccessLogsView> {
  String _errorMessage = '';
  List<Log> _logs = [];

  @override
  void initState() {
    super.initState();
    _fetchLogs();
  }

  Future<void> _fetchLogs() async {
    try {
      List<Log> logs = await DashboardController.fetchLogsData();
      setState(() {
        _logs = logs;
        _errorMessage = ''; // Clear error message if data is successfully fetched
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Error: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Access Logs',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Expanded(
            child: Center(
              child: _errorMessage.isNotEmpty
                  ? Text(_errorMessage)
                  : _logs.isNotEmpty
                      ? ListView.builder(
                          itemCount: _logs.length,
                          itemBuilder: (context, index) {
                            Log log = _logs[_logs.length - index - 1]; // Start from the last log in the list
                            return Card(
                              color: Colors.grey[200],
                              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              elevation: 2,
                              child: ListTile(
                                title: Text('Gate: ${log.gateName}'),
                                subtitle: Text('Direction: ${log.direction}, Time: ${log.timeStamp}'),
                              ),
                            );
                          },
                        )
                      : const CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
