import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:frontend/components/rfid_card.dart';
import 'package:frontend/controllers/dashboard_controller.dart';
import 'package:frontend/models/log.dart';
import 'package:frontend/models/user_profile.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  UserProfile? _userProfile;
  String _errorMessage = '';
  List<Log> _logs = [];

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
    _fetchLogs();
  }

  Future<void> _fetchDashboardData() async {
    try {
      UserProfile userProfile = await DashboardController.fetchDashboardData();
      setState(() {
        _userProfile = userProfile;
        _errorMessage = ''; // Clear error message if data is successfully fetched
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Error: $error';
      });
    }
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RfidCard(
              cardNumber: _userProfile?.cardID ?? 'N/A',
              cardHolder: '${_userProfile?.name ?? 'N/A'} ${_userProfile?.surname ?? 'N/A'}',
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Last 3 Activities',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: _errorMessage.isNotEmpty
                  ? Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                    )
                  : _logs.isNotEmpty
                      ? ListView.builder(
                          itemCount: _logs.length > 3 ? 3 : _logs.length,
                          itemBuilder: (context, index) {
                            Log log = _logs[_logs.length - index - 1];
                            String formattedTimestamp = formatTimestamp(log.timeStamp);
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                              child: Card(
                                elevation: 2,
                                child: ListTile(
                                  title: Text('Gate: ${log.gateName}'),
                                  subtitle: Text('Direction: ${log.direction}, Time: $formattedTimestamp'),
                                ),
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
