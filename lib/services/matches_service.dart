import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../models/event.dart';

/// Get the week number from a date
int getWeekNumber(String date) {
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  DateTime dateTime = dateFormat.parse(date);
  int dayOfYear = int.parse(DateFormat('D').format(dateTime));
  return ((dayOfYear - dateTime.weekday + 10) / 7).floor();
}

/// Fetch the matches for a selected team
Future<List<Event>> _fetchSelectedTeamMatches(String teamName, int selectedWeek,mounted, selectedTeamsEvents) async {

  final QuerySnapshot querySnapshot =
  await FirebaseFirestore.instance.collection('equipes').get();
  if (!mounted) return List.empty();

    for (var doc in querySnapshot.docs) {
      if (doc.id == teamName) {
        for (Map<String, dynamic> match in doc['matches']) {
          String date = match['date'];
          if (getWeekNumber(date) == selectedWeek) {
            Event event = Event.fromMap(match);
            event.setIsAwayTeam(doc['teamName'].contains(event.visitorTeam.split(' ')[0]));
            selectedTeamsEvents.add(event);
          }
        }
      }
    }
 return selectedTeamsEvents;
}

/// Fetch teams from Firestore
Future<List<Event>> getSelectedTeamsMatches(selectedTeams,selectedWeek,mounted,selectedTeamsEvents) async {
  if (selectedTeams == List.empty()) {
    return List.empty();
  }
  for (var team in selectedTeams) {
    await _fetchSelectedTeamMatches(team, selectedWeek,mounted, selectedTeamsEvents);
  }
  return selectedTeamsEvents;
}