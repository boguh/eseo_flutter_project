import 'package:app/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event.dart';
import '../services/matches_service.dart';
import '../utils/router.dart';
import '../widgets/calendar_widget.dart';

String userEmail = '';
String userName = '';

/// The [WelcomePage] widget displays the main page of the application
/// It contains a calendar widget and a list of events
/// The events are fetched from the database based on the selected week
/// The user can navigate to the settings page by clicking on the settings icon
/// The user can navigate to the event details page by clicking on an event
class WelcomePage extends StatefulWidget {
  /// Creates a [WelcomePage] widget
  const WelcomePage({super.key});

  /// Creates the mutable state for this widget
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

/// Get the current week number
int getCurrentWeekNumber() {
  DateTime now = DateTime.now();
  int dayOfYear = int.parse(DateFormat("D").format(now));
  return ((dayOfYear - now.weekday + 10) / 7).floor();
}

/// The private state class for a [WelcomePage] widget
class _WelcomePageState extends State<WelcomePage> {
  /// The list of events to display
  bool _isLoading = false;
  int _selectedWeek = getCurrentWeekNumber();
  List<String> selectedTeams = [];
  List<Event> selectedTeamsEvents = [];

  /// The list of events to display
  static const String _selectedTeamsKey = 'selected_teams';
  late SharedPreferences _prefs;

  /// Initialize the state
  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  /// Initialize the page
  Future<void> _initializePage() async {
    setState(() => _isLoading = true);
    try {
      // First we get the shared preferences instance
      _prefs = await SharedPreferences.getInstance();
      // We get the selected teams from the stored teams
      selectedTeams = _prefs.getStringList(_selectedTeamsKey) ?? [];
      selectedTeamsEvents.clear();
      selectedTeamsEvents = await getSelectedTeamsMatches(selectedTeams, _selectedWeek,mounted,selectedTeamsEvents);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }



  /// Build the widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildCustomAppBar(), // L'appbar est toujours visible
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator()) // Affiche uniquement un loader pour la liste des événements
                  : _buildEventList(), // Affiche la liste des événements
            ),
          ],
        ),
      ),
    );
  }

  /// Build the list of events
  Widget _buildEventList() {
    if (selectedTeamsEvents.isNotEmpty) {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final match in selectedTeamsEvents) EventCard(context: context, match: match, selectedTeams: selectedTeams),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          selectedTeams.isEmpty ? 'No team followed' : 'No events found',
          style: const TextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }
  }

  /// Build the custom app bar
  Widget _buildCustomAppBar() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              Icons.menu_rounded,
              size: 35,
              color: Colors.white,
            ),
            onPressed: () {
              context.go(RouteNames.settings.path);
            },
            tooltip: 'Settings',
          ),
          Calendar(
            onMonthChanged: (month) async {
              setState(() {
                _isLoading = true;
              });
              selectedTeamsEvents.clear();
              selectedTeamsEvents=await getSelectedTeamsMatches(selectedTeams, _selectedWeek,mounted, selectedTeamsEvents);
              setState(() {
                _isLoading = false;
              });
            },
            onWeekChanged: (week) async {
              setState(() {
                _isLoading = true;
                _selectedWeek = week;
                debugPrint('Week: $week');
              });
              selectedTeamsEvents.clear();
              selectedTeamsEvents=await getSelectedTeamsMatches(selectedTeams, _selectedWeek,mounted, selectedTeamsEvents);
              setState(() {
                _isLoading = false;
              });
            },
          ),
        ],
      ),
    );
  }
}