import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Event {
  final String date;
  final String time;
  final String homeTeam;
  final String visitorTeam;

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

  /// Creates an [Event] object from a Firestore document
  factory Event.fromFirestore(DocumentSnapshot<Object?> doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Event.fromMap(data);
  }
}