import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Event {
  final String weekDay;
  final int numberDay;
  final String month;
  final TimeOfDay time;
  final String location;
  final String homeTeam;
  final String visitorTeam;

  Event({
    required this.weekDay,
    required this.numberDay,
    required this.month,
    required this.time,
    required this.location,
    required this.homeTeam,
    required this.visitorTeam,
  });

  // Method to convert Event object to JSON
 /* Map<String, dynamic> toJson() {
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
  }*/


  factory Event.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    debugPrint("matches data: $data");
    return Event(
      weekDay: _getWeekDay(data['time'].toDate().weekday),
      numberDay: data['time'].toDate().day,
      month: data['time'].toDate().month.toString(),
      time: TimeOfDay(
        hour: (data['time'] as Timestamp).toDate().hour,
        minute: (data['time'] as Timestamp).toDate().minute,
      ),
      location: data['location'],
      homeTeam: data['home'],
      visitorTeam: data['visitor'],
    );
  }
}

 String _getWeekDay(int day) {
  switch (day) {
    case 1:
      return 'Lundi';
    case 2:
      return 'Mardi';
    case 3:
      return 'Mercredi';
    case 4:
      return 'Jeudi';
    case 5:
      return 'Vendredi';
    case 6:
      return 'Samedi';
    case 7:
      return 'Dimanche';
    default:
      return '';
  }
}