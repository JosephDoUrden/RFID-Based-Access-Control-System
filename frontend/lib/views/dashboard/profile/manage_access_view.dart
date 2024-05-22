import 'package:flutter/material.dart';
import 'package:frontend/controllers/manage_access_controller.dart';
import 'package:frontend/models/permission.dart';

class ManageAccessView extends StatefulWidget {
  const ManageAccessView({super.key});

  @override
  State<ManageAccessView> createState() => _ManageAccessViewState();
}

class _ManageAccessViewState extends State<ManageAccessView> {
  final ManageAccessController _controller = ManageAccessController();
  late Future<List<Permission>> _permissionsFuture;

  @override
  void initState() {
    super.initState();
    _permissionsFuture = _controller.fetchPermissions();
  }

  Future<void> _refreshPermissions() async {
    setState(() {
      _permissionsFuture = _controller.fetchPermissions();
    });
  }

  String getGateName(int gateID) {
    switch (gateID) {
      case 1:
        return 'Main Gate';
      case 2:
        return 'Side Gate';
      default:
        return 'Unknown Gate';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Access',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[900],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Permission>>(
          future: _permissionsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No permissions found'));
            } else {
              final permissions = snapshot.data!;
              return RefreshIndicator(
                onRefresh: _refreshPermissions,
                child: ListView.builder(
                  itemCount: permissions.length,
                  itemBuilder: (context, index) {
                    final permission = permissions[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        title: Text(
                          permission.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text('Gate: ${getGateName(permission.gateID)}'),
                        ),
                        trailing: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: permission.permissionLevel,
                            items: ['Full Access', 'Restricted Access', 'No access'].map((String level) {
                              return DropdownMenuItem<String>(
                                value: level,
                                child: Text(level),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                _controller.updatePermission(permission.permissionID, newValue).then((_) {
                                  _refreshPermissions(); // Refresh the list after updating the permission
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Permission updated successfully'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }).catchError((error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Failed to update permission: $error'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
