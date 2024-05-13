import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
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
          Expanded(
            child: Center(
              child: _errorMessage.isNotEmpty
                  ? Text(_errorMessage)
                  : _logs.isNotEmpty
                      ? ListView.builder(
                          itemCount: _logs.length,
                          itemBuilder: (context, index) {
                            Log log = _logs[index];
                            return ListTile(
                              title: Text('Gate: ${log.gateName}'),
                              subtitle: Text('Direction: ${log.direction}, Time: ${log.timeStamp}'),
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
