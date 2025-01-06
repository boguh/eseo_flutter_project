import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models/event.dart';
import '../services/matches_service.dart';
import '../services/teams_qubit.dart';
import '../utils/router.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/event_card.dart';


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
  bool _isLoading = false;

  int _selectedWeek = getCurrentWeekNumber();
  List<Event> selectedTeamsEvents = [];

  @override
  void initState() {
    super.initState();
    context.read<TeamsCubit>().loadPreferences().then((_) {
      _initializePage();
    });
  }

  Future<void> _initializePage() async {
    setState(() => _isLoading = true);
    try {
      final selectedTeams = context.read<TeamsCubit>().selectedTeams;
      selectedTeamsEvents.clear();
      selectedTeamsEvents = await getSelectedTeamsMatches(selectedTeams, _selectedWeek, mounted, selectedTeamsEvents);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildCustomAppBar(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildEventList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventList() {
    final selectedTeams = context.watch<TeamsCubit>().selectedTeams;
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

  Widget _buildCustomAppBar() {
    return Container(
      width: double.infinity,
      // Margin Top, Left and Right : 20.0
      // Margin Bottom : 10.0
      margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
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
              selectedTeamsEvents = await getSelectedTeamsMatches(
                context.read<TeamsCubit>().selectedTeams,
                _selectedWeek,
                mounted,
                selectedTeamsEvents,
              );
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
              selectedTeamsEvents = await getSelectedTeamsMatches(
                context.read<TeamsCubit>().selectedTeams,
                _selectedWeek,
                mounted,
                selectedTeamsEvents,
              );
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