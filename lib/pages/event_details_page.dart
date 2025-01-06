import 'package:app/widgets/google_auth_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/event.dart';
import '../services/account_cubit.dart';
import '../services/calendar_client.dart';
import '../widgets/actions_menu.dart';

class EventDetailsPage extends StatelessWidget {
  final Event event;

  const EventDetailsPage({super.key, required this.event});

  Future<void> _createEvent(BuildContext context) async {
  final  accountCubit = context.read<AccountCubit>();
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
  }@override
  Widget build(BuildContext context) {
    final accountCubit = context.read<AccountCubit>();
    bool showButton = accountCubit.isAuthenticated; // Votre condition ici.

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        centerTitle: true,
        title: Text(
          'Event Details',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w600,
            fontSize: 25,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            size: 35,
          ),
          tooltip: 'Go back',
          onPressed: () {
            if (GoRouter.of(context).canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildEventDetails(),
            Visibility(
              visible: showButton,
              replacement: ElevatedButton(
                onPressed: null, // Bouton désactivé (grisé)
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.grey, // Couleur grise
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Create Event',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              child: ElevatedButton(
                onPressed: () => _createEvent(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Create Event',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildEventDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ActionsMenu(
          title: 'Teams',
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.home_rounded, size: 30),
                Text(_formatTeamName(event.homeTeam), style: const TextStyle(fontSize: 18)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.flight_rounded, size: 30),
                Text(_formatTeamName(event.visitorTeam), style: const TextStyle(fontSize: 18)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        ActionsMenu(
          title: 'Event Details',
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.date_range_rounded, size: 30),
                Text(event.date, style: const TextStyle(fontSize: 18)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.access_time_rounded, size: 30),
                Text(event.time, style: const TextStyle(fontSize: 18)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// Format the team name to be displayed by shorting it to the first 20 characters and adding ellipsis
  String _formatTeamName(String teamName) {
    if (teamName.length > 20) {
      return '${teamName.substring(0, 20)}...';
    }
    return teamName;
  }
}