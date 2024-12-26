import 'package:flutter/material.dart';
import '../models/event.dart';

class EventDetailsPage extends StatelessWidget {
  final Event event;

  const EventDetailsPage({Key? key, required this.event}) : super(key: key);

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
            Text('Date: ${event.weekDay}, ${event.numberDay}/ ${event.month}', style: TextStyle(fontSize: 18)),

            Text('Time: ${event.time.format(context)}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}