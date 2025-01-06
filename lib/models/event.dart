import 'package:flutter/material.dart';

/// The [Event] class represents a sports event
/// It contains the date, time, home team, and visitor team
/// It also has a factory constructor to create an [Event] object from a Map
class Event {

  /// The date, time, home team, and visitor team of the event
  final String date;
  final String time;
  final String homeTeam;
  final String visitorTeam;

  /// Constructor for the [Event] class
  Event({
    required this.date,
    required this.time,
    required this.homeTeam,
    required this.visitorTeam,
  });

  /// Creates an [Event] object from a Map
  factory Event.fromMap(Map<String, dynamic> data) {
    debugPrint("matches data: $data");
    return Event(
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      homeTeam: data['dom'] ?? '',
      visitorTeam: data['visit'] ?? '',
    );
  }
}