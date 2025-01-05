import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/calendar_client.dart';

class EventDetailsPage extends StatelessWidget {
  final Event event;

  const EventDetailsPage({Key? key, required this.event}) : super(key: key);

  Future<void> _createEvent(BuildContext context) async {

    // Build the start date time from e.g. date = 'dd/mm/yyyy' and time = 'hh:mm'
    List<String> dateParts = event.date.split('/');
    List<String> timeParts = event.time.split(':');
    DateTime startDateTime = DateTime(
      int.parse(dateParts[2]),
      int.parse(dateParts[1]),
      int.parse(dateParts[0]),
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );

    DateTime endDateTime = startDateTime.add(const Duration(hours: 2)); // Assuming the event lasts 2 hours

    CalendarClient calendarClient = CalendarClient();
    await calendarClient.insert(
      title: '${event.homeTeam} vs. ${event.visitorTeam}',
      attendeeEmailList: [], // Add attendee emails if needed
      shouldNotifyAttendees: false,
      startTime: startDateTime,
      endTime: endDateTime,
      description: 'Sports event',
      location: 'Stadium',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Event created successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Home Team: ${event.homeTeam}', style: const TextStyle(fontSize: 18)),
            Text('Visitor Team: ${event.visitorTeam}', style: const TextStyle(fontSize: 18)),
            Text('Date: ${event.date}', style: const TextStyle(fontSize: 18)),
            Text('Time: ${event.time}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _createEvent(context),
              child: const Text('Create Event'),
            ),
          ],
        ),
      ),
    );
  }
}