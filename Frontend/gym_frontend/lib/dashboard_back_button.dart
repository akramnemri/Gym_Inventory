import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

class DashboardBackButton extends StatelessWidget {
  final Map<String, dynamic> user;

  const DashboardBackButton({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BackButton(
      onPressed: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DashboardScreen(user: user),
        ),
      ),
    );
  }
}
