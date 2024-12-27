import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models/event.dart';
import '../utils/router.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import '../widgets/calendar_widget.dart';
import 'event_details_page.dart';
String userEmail= '';
String userName= '';
List<String> favoriteTeams = ['SLB'];
List <Event> displayedEvents = [];

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}
int getCurrentWeekNumber() {
  DateTime now = DateTime.now();
  int dayOfYear = int.parse(DateFormat("D").format(now));
  return ((dayOfYear - now.weekday + 10) / 7).floor();
}

class _WelcomePageState extends State<WelcomePage> {
  // State variables
  bool _isLoading = false;
  int _selectedWeek=  getCurrentWeekNumber();

  String _testData = '';
  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  Future<void> _initializePage() async {
    setState(() => _isLoading = true);
    try {
      getFavoriteTeamsMatches(favoriteTeams);
      // Async initialization logic (API calls, data loading)



    } catch (e) {
      // Error handling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Get the events from the database based on the selected week as JSON
  List<Map<String, dynamic>> _getEvents(int week) {
    // Get the events from the database
    print('Fetching events for week $week');
    return [];
  }

  @override
  Widget build(BuildContext context) {

    // Get the events from the database according to the selected week
    final events = _getEvents(_selectedWeek);

    return Scaffold(
      backgroundColor: Colors.black, // Black background
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: IntrinsicHeight(
          child: Column(
            children: [
              // Custom AppBar
              Container(
                width: double.infinity, // Full width
                margin: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                decoration: BoxDecoration(
                  color: Colors.blueAccent, // Blue color
                  borderRadius: BorderRadius.circular(20), // Border radius
                ),
                // Column with children, all aligned to the start
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Add an extra space between the children
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Calendar widget
                    IconButton(
                      icon: const Icon(
                        Icons.menu_rounded,
                        size: 35,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        context.go(RouteNames.settings.path); // Navigate to settings page
                      },
                      tooltip: 'Settings',
                    ),
                    Calendar(
                      onMonthChanged: (month) {
                        setState(() {
                          // _getEvents(_selectedWeek);
                          getFavoriteTeamsMatches(favoriteTeams);

                        });
                      },
                      onWeekChanged: (week) {
                        setState(() {
                          _selectedWeek = week;
                          debugPrint ('Week: $week');
                          getFavoriteTeamsMatches(favoriteTeams);
                        });
                      },
                    ),
                  ],
                ),
              ),
              // Main content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Add the events here if there are any, else display a message
                      if (displayedEvents.isNotEmpty)
                        for (final match in displayedEvents)
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EventDetailsPage(event: match),
                                ),
                              );
                            },
                          child:Container(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                const SizedBox(height: 5.0),
                                Text(
                                  'Team: ${match.homeTeam}',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                                Text(
                                  'Opponent: ${match.visitorTeam}',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                                Text(
                                  'Date: ${match.weekDay}, ${match.numberDay}/${match.month}',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          )
                      else
                        const Text(
                            'No events found ',
                            style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
  bool isDateInWeek(Timestamp timestamp, int weekNumber, int year) {
    DateTime date = timestamp.toDate();
    DateTime startOfYear = DateTime(year, 1, 1);
    DateTime startOfWeek = startOfYear.add(Duration(days: (weekNumber - 1) * 7));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

    return date.isAfter(startOfWeek) && date.isBefore(endOfWeek.add(Duration(days: 1)));
  }
  Future<void> getFavoriteTeamsMatches(List<String> teamIds) async {
    List<QueryDocumentSnapshot> matches = [];
    int s = 0;
    for (String teamId in teamIds) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('matches')
          .where('visitor', isEqualTo: teamId)
          .get();
      matches.addAll(querySnapshot.docs);
      s += querySnapshot.docs.length;
      QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance
          .collection('matches')
          .where('home', isEqualTo: teamId)
          .get();
      matches.addAll(querySnapshot2.docs);
      s += querySnapshot2.docs.length;
    }
    debugPrint('Matches: $s');

    List<QueryDocumentSnapshot> matchesToRemove = [];
    for (QueryDocumentSnapshot match in matches) {
      if (_selectedWeek > 30) {
        if (!isDateInWeek(match['time'], _selectedWeek, DateTime.now().year)) {
          debugPrint('Match: $match');
          matchesToRemove.add(match);
        }
      } else {
        if (!isDateInWeek(match['time'], _selectedWeek, DateTime.now().year + 1)) {
          matchesToRemove.add(match);
        }
      }
    }

    matches.removeWhere((match) => matchesToRemove.contains(match));

    setState(() {
      displayedEvents = matches.map((e) => Event.fromFirestore(e)).toList();
    });
  }
  }
