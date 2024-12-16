import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import '../services/calendar_client.dart';
import 'event_creation_screen.dart';
class HomeScreen extends StatelessWidget {
  final String userEmail;
  final String userName;

  const HomeScreen({
    Key? key,
    required this.userEmail,
    required this.userName
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenue'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bonjour, $userName!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 10),
            Text(
              'Email: $userEmail',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventCreationScreen(),
                  ),
                );
              },
              child: Text('Créer un événement'),
            ),
          ],
        ),
      ),
    );
  }
}

