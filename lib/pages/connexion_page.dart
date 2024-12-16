import 'package:app/pages/home_screen.dart';
import 'package:app/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';

import '../services/calendar_client.dart';
import '../widgets/google_auth_button.dart';
void logout() async {
  WidgetsFlutterBinding.ensureInitialized();

  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/calendar',
    ],
  );

  await googleSignIn.signOut();
  print('DEBUGGGG: Google user signed out');
}
Future<bool> login() async {
  WidgetsFlutterBinding.ensureInitialized();

  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/calendar',
    ],
  );

  try {
    await googleSignIn.signOut();
    // Utilisez await directement
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    print ('DEBUGGGG: Google user signed in: ${googleUser!.email}');



    print('DEBUGGGG: Google user signed in: ${googleUser.email}');
    final client = await googleSignIn.authenticatedClient();
    if (client == null) {
      print('DEBUGGGG: Client is null');

    } else {
      CalendarClient.calendar = cal.CalendarApi(client);
      print('DEBUGGGG: Calendar client created');




        userEmail= googleUser.email;
        userName= googleUser.displayName!;
        isAuthenticated = true;
        return true;
    }
  } on PlatformException catch (e) {
    print('DEBUGGGG: PlatformException: ${e.message}');

  } catch (e) {
    print('DEBUGGGG: Exception: $e');

  }
  return false;
}






