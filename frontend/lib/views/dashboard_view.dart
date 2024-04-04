import 'package:flutter/material.dart';
import 'package:frontend/components/rfid_card.dart';
import 'package:frontend/controllers/dashboard_controller.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  String _dashboardData = '';
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    try {
      String dashboardData = await DashboardController.fetchDashboardData();
      setState(() {
        _dashboardData = dashboardData;
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
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Column(
        children: [
          const RfidCard(
            cardNumber: '1234 5678 9012 3456',
            cardHolder: 'John Doe',
            expiryDate: '10/25',
          ),
          Center(
            child: _errorMessage.isNotEmpty
                ? Text(_errorMessage)
                : _dashboardData.isNotEmpty
                    ? Text(_dashboardData)
                    : const CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
