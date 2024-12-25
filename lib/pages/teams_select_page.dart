import 'package:eseo_flutter_project/widgets/icon_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:eseo_flutter_project/utils/router.dart';
import 'package:google_fonts/google_fonts.dart';

/// Page to select the teams
class TeamsPage extends StatefulWidget {

  // Constructor
  const TeamsPage({super.key});

  @override
  State<TeamsPage> createState() => _TeamsPageState();
}

/// State of the TeamsPage
class _TeamsPageState extends State<TeamsPage> {

  // State variables
  bool _isLoading = false;
  bool _isSelectingAll = false;
  bool _isMarkingAll = false;
  Map<String, dynamic> _teams = {
    '1': {
      'name': 'Team 1',
      'selected': false,
      'marked': false,
    },
    '2': {
      'name': 'Team 2',
      'selected': false,
      'marked': false,
    },
  };

  /// Initialize the state variables
  @override
  void initState() {
    super.initState();
    _initializeTeams();
    _initializePage();
  }

  /// Initialize the teams
  void _initializeTeams() {
    // Get the teams from the database
    print('Fetching teams');
    // TODO : Fetch the teams from the database
  }

  /// Initialize the page
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

  /// Build the list of teams
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        centerTitle: true,
        title: Text(
          'Select Teams',
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
          onPressed: () {
            if (GoRouter.of(context).canPop()) {
              context.pop();
            } else {
              context.go(RouteNames.settings.path); // Fallback navigation
            }
          },
          tooltip: 'Go back',
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add Team button
              _buildAddTeamButton(),
              const SizedBox(height: 20),
              // Action buttons
              _buildActionButtons(),
              const SizedBox(height: 20),
              // List of teams
              _buildListOfTeams(),
            ],
          ),
        ),
      ),
    );
  }

  /// Build the Add Team button
  Widget _buildAddTeamButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          // Navigate to the add team page
          print('Navigate to the add team page');
        },
        icon: const Icon(
            Icons.add_rounded,
          color: Colors.white,
        ),
        label: const Text(
            'Add a team',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  /// Build the "Select All" checkbox and "Mark all" checkbox
  Widget _buildActionButtons() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // Build the "Select All" checkbox
      children: [
        Row(
          children: [
            IconCheckbox(iconChecked: Icons.indeterminate_check_box, iconUnchecked: Icons.check_box_outline_blank),
            SizedBox(width: 5),
            Text(
              'Select All',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
        // Build the "Mark all" checkbox
        Row(
          children: [
            Text(
              'Mark all',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(width: 5),
            IconCheckbox(iconChecked: Icons.star_rounded, iconUnchecked: Icons.star_outline_rounded, checkedColor: Color(0xFFFFD700)),
          ],
        ),
      ],
    );
  }

  _buildListOfTeams() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _teams.length,
      itemBuilder: (context, index) {
        final team = _teams.values.elementAt(index);
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Checkbox to select the team
            IconCheckbox(
              iconChecked: Icons.indeterminate_check_box,
              iconUnchecked: Icons.check_box_outline_blank,
              initialValue: team['selected'],
              onChanged: (value) {
                setState(() {
                  _teams.values.elementAt(index)['selected'] = value;
                });
              },
            ),
            // Team name
            Text(
              team['name'],
              style: const TextStyle(
                fontSize: 24,
                color: Colors.black,
              ),
            ),
            // Checkbox to mark the team
            IconCheckbox(
              iconChecked: Icons.star_rounded,
              iconUnchecked: Icons.star_outline_rounded,
              checkedColor: const Color(0xFFFFD700),
              initialValue: team['marked'],
              onChanged: (value) {
                setState(() {
                  _teams.values.elementAt(index)['marked'] = value;
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // Clean up controllers, listeners, etc.
    super.dispose();
  }
}