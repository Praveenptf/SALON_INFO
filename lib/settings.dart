import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  void _changePassword(BuildContext context) {
    // Add your change password logic here
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Change Password feature coming soon'),
    ));
  }

  void _about(BuildContext context) {
    // Add your about logic here
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('About feature coming soon'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: Icon(Icons.lock),
                title: Text('Change Password'),
                onTap: () => _changePassword(context),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text('About'),
                onTap: () => _about(context),
              ),
            ],
          ),
        ),
      );
  }
}
