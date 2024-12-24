import 'package:app/pages/welcome_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
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
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      return false; // The user canceled the sign-in
    }

    final GoogleSignInAuthentication googleAuth = await googleUser
        .authentication;
   /* final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithCredential(credential);
    User? user = userCredential.user;
    if (user == null) {
      return false;
    }*/

    final client = await googleSignIn.authenticatedClient();
    if (client == null) {
      return false;
    } else {
      CalendarClient.calendar = cal.CalendarApi(client);
      userEmail = googleUser.email;
      userName = googleUser.displayName!;
      isAuthenticated = true;
      return true;
    }
  } catch (e) {
    print('DEBUGGGG: Exception: $e');
    return false;
  }
}
