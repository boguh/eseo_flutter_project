import 'package:flutter/material.dart';
import 'event_creation_screen.dart';
class HomeScreen extends StatelessWidget {
  final String userEmail;
  final String userName;

  const HomeScreen({
    super.key,
    required this.userEmail,
    required this.userName
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenue'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bonjour, $userName!',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 10),
            Text(
              'Email: $userEmail',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventCreationScreen(),
                  ),
                );
              },
              child: const Text('Créer un événement'),
            ),
          ],
        ),
      ),
    );
  }
}

