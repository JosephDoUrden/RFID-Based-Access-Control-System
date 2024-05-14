import 'package:flutter/material.dart';
import 'package:frontend/controllers/dashboard_controller.dart';
import 'package:frontend/models/log.dart';
import 'package:intl/date_symbol_data_local.dart'; // Import for date formatting
import 'package:intl/intl.dart';

class AccessLogsView extends StatefulWidget {
  const AccessLogsView({Key? key}) : super(key: key);

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

  // Method to format the timestamp into Turkish time format
  String formatTimestamp(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    var formatter = DateFormat('dd.MM.yyyy HH:mm', 'tr_TR'); // Turkish time format
    String formattedDate = formatter.format(dateTime);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    // Initialize locale data for date formatting
    initializeDateFormatting('tr_TR');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Access Logs',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _errorMessage.isNotEmpty
          ? Center(
              child: Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            )
          : _logs.isNotEmpty
              ? ListView.builder(
                  itemCount: _logs.length,
                  itemBuilder: (context, index) {
                    Log log = _logs[_logs.length - index - 1]; // Start from the last log in the list
                    String formattedTimestamp = formatTimestamp(log.timeStamp);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Card(
                        elevation: 2,
                        child: ListTile(
                          title: Text(
                            'Gate: ${log.gateName}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Direction: ${log.direction}\nTime: $formattedTimestamp',
                          ),
                        ),
                      ),
                    );
                  },
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
    );
  }
}
