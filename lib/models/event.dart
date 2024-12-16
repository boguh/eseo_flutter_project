import 'package:flutter/material.dart';

class Event {
  final DateTime date;
  final TimeOfDay time;
  final String location;
  final String homeTeam;
  final String visitorTeam;

  Event({
    required this.date,
    required this.time,
    required this.location,
    required this.homeTeam,
    required this.visitorTeam,
  });

  // Method to convert Event object to JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'time': time.format(DateTime(0) as BuildContext),
      'location': location,
      'homeTeam': homeTeam,
      'visitorTeam': visitorTeam,
    };
  }

  // Method to create Event object from JSON
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      date: DateTime.parse(json['date']),
      time: TimeOfDay(
        hour: int.parse(json['time'].split(":")[0]),
        minute: int.parse(json['time'].split(":")[1]),
      ),
      location: json['location'],
      homeTeam: json['homeTeam'],
      visitorTeam: json['visitorTeam'],
    );
  }
}