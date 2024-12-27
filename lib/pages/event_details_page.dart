import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import '../models/event.dart';
import '../services/calendar_client.dart';

class EventDetailsPage extends StatelessWidget {
  final Event event;

  const EventDetailsPage({Key? key, required this.event}) : super(key: key);

  Future<void> _createEvent(BuildContext context) async {
    DateTime startDateTime = DateTime(
      DateTime.now().year,
      int.parse(event.month),
      event.numberDay,
      event.time.hour,
      event.time.minute,
    );

    DateTime endDateTime = startDateTime.add(Duration(hours: 2)); // Assuming the event lasts 2 hours

    CalendarClient calendarClient = CalendarClient();
    await calendarClient.insert(
      title: '${event.homeTeam} vs ${event.visitorTeam}',
      description: 'Match at ${event.location}',
      location: event.location,
      attendeeEmailList: [], // Add attendee emails if needed
      shouldNotifyAttendees: false,
      startTime: startDateTime,
      endTime: endDateTime,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Event created successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Location: ${event.location}', style: TextStyle(fontSize: 18)),
            Text('Home Team: ${event.homeTeam}', style: TextStyle(fontSize: 18)),
            Text('Visitor Team: ${event.visitorTeam}', style: TextStyle(fontSize: 18)),
            Text('Date: ${event.weekDay}, ${event.numberDay}/${event.month}', style: TextStyle(fontSize: 18)),
            Text('Time: ${event.time.format(context)}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _createEvent(context),
              child: Text('Create Event'),
            ),
          ],
        ),
      ),
    );
  }
}