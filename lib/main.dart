import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
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

class CalendarClient {
  static cal.CalendarApi? calendar;

  Future<Map<String, String>?> insert({
    required String title,
    required String description,
    required String location,
    required List<cal.EventAttendee> attendeeEmailList,
    required bool shouldNotifyAttendees,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    String calendarId = "primary";
    cal.Event event = cal.Event();

    event.summary = title;
    event.description = description;
    event.attendees = attendeeEmailList;
    event.location = location;

    cal.EventDateTime start = cal.EventDateTime();
    start.dateTime = startTime;
    start.timeZone = "GMT+05:30";
    event.start = start;

    cal.EventDateTime end = cal.EventDateTime();
    end.timeZone = "GMT+05:30";
    end.dateTime = endTime;
    event.end = end;

    await calendar?.events.insert(event, calendarId,
        sendUpdates: shouldNotifyAttendees ? "all" : "none");

    return null;
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

class EventCreationScreen extends StatefulWidget {
  @override
  _EventCreationScreenState createState() => _EventCreationScreenState();
}

class _EventCreationScreenState extends State<EventCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  String? currentTitle;
  String? currentDesc;
  String? currentLocation;
  List<String> attendeeEmails = [];
  bool shouldNofityAttendees = false;
  int startTimeInEpoch = DateTime.now().millisecondsSinceEpoch;
  int endTimeInEpoch = DateTime.now().add(Duration(hours: 1)).millisecondsSinceEpoch;

  void _submitEvent() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      CalendarClient calendarClient = CalendarClient();
      await calendarClient.insert(
        title: currentTitle ?? '',
        description: currentDesc ?? '',
        location: currentLocation ?? '',
        attendeeEmailList: attendeeEmails.map((email) => cal.EventAttendee()..email = email).toList(),
        shouldNotifyAttendees: shouldNofityAttendees,
        startTime: DateTime.fromMillisecondsSinceEpoch(startTimeInEpoch),
        endTime: DateTime.fromMillisecondsSinceEpoch(endTimeInEpoch),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Événement créé avec succès')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Créer un événement')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Titre'),
              onSaved: (value) => currentTitle = value,
              validator: (value) => value!.isEmpty ? 'Entrez un titre' : null,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),
              onSaved: (value) => currentDesc = value,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Lieu'),
              onSaved: (value) => currentLocation = value,
            ),
            ElevatedButton(
              onPressed: _submitEvent,
              child: Text('Créer l\'événement'),
            ),
          ],
        ),
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