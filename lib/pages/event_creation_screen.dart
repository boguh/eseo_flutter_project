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
  DateTime? startDate;
  TimeOfDay? startTime;
  DateTime? endDate;
  TimeOfDay? endTime;

  void _submitEvent() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (startDate != null && startTime != null && endDate != null && endTime != null) {
        DateTime startDateTime = DateTime(
          startDate!.year,
          startDate!.month,
          startDate!.day,
          startTime!.hour,
          startTime!.minute,
        );

        DateTime endDateTime = DateTime(
          endDate!.year,
          endDate!.month,
          endDate!.day,
          endTime!.hour,
          endTime!.minute,
        );

        CalendarClient calendarClient = CalendarClient();
        await calendarClient.insert(
          title: currentTitle ?? '',
          description: currentDesc ?? '',
          location: currentLocation ?? '',
          attendeeEmailList: attendeeEmails.map((email) => cal.EventAttendee(email: email)).toList(),
          shouldNotifyAttendees: shouldNofityAttendees,
          startTime: startDateTime,
          endTime: endDateTime,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Événement créé avec succès')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Veuillez sélectionner la date et l\'heure')),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
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
            ListTile(
              title: Text('Date de début: ${startDate != null ? startDate.toString() : 'Non sélectionnée'}'),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, true),
            ),
            ListTile(
              title: Text('Heure de début: ${startTime != null ? startTime?.format(context) : 'Non sélectionnée'}'),
              trailing: Icon(Icons.access_time),
              onTap: () => _selectTime(context, true),
            ),
            ListTile(
              title: Text('Date de fin: ${endDate != null ? endDate.toString() : 'Non sélectionnée'}'),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, false),
            ),
            ListTile(
              title: Text('Heure de fin: ${endTime != null ? endTime?.format(context) : 'Non sélectionnée'}'),
              trailing: Icon(Icons.access_time),
              onTap: () => _selectTime(context, false),
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