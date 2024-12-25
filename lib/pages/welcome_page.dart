import 'package:eseo_flutter_project/widgets/calendar_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/router.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  // State variables
  bool _isLoading = false;
  int _selectedWeek = 1;

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  Future<void> _initializePage() async {
    setState(() => _isLoading = true);
    try {
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
                        });
                      },
                      onWeekChanged: (week) {
                        setState(() {
                          _selectedWeek = week;
                          _getEvents(_selectedWeek);
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
                      if (events.isNotEmpty)
                        for (final event in events)
                          Container(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event['title'],
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                Text(
                                  event['description'],
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          )
                      else
                        const Text(
                            'No events found',
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

  @override
  void dispose() {
    // Clean up controllers, listeners, etc.
    super.dispose();
  }
}
