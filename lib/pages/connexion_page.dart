import 'package:app/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';

import 'services/calendar_client.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/calendar',
    ],
  );

  try {
    print('DEBUGGGG: Sign-in process started');

    // Utilisez await directement
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    print('DEBUGGGG: Sign-in method called');

    if (googleUser == null) {
      print('DEBUGGGG: Google user is null');
      runApp(const ErrorApp());
      return;
    }

    print('DEBUGGGG: Google user signed in: ${googleUser.email}');
    final client = await googleSignIn.authenticatedClient();
    if (client == null) {
      print('DEBUGGGG: Client is null');
      runApp(const ErrorApp());
    } else {
      CalendarClient.calendar = cal.CalendarApi(client);
      print('DEBUGGGG: Calendar client created');
      runApp(MyApp(
        userEmail: googleUser.email,
        userName: googleUser.displayName ?? 'Anonyme',
      ));
    }
  } on PlatformException catch (e) {
    print('DEBUGGGG: PlatformException: ${e.message}');
    runApp(const ErrorApp());
  } catch (e) {
    print('DEBUGGGG: Exception: $e');
    runApp(const ErrorApp());
  }
}


class MyApp extends StatelessWidget {
  final String userEmail;
  final String userName;

  const MyApp({
    Key? key,
    required this.userEmail,
    required this.userName
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(
          userEmail: userEmail,
          userName: userName
      ),
    );
  }
}

class ErrorApp extends StatelessWidget {
  const ErrorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Erreur de connexion'),
        ),
      ),
    );
  }
}