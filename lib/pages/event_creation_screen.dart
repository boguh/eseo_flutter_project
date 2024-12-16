import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import '../models/calendar_client.dart';
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