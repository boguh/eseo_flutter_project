import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../utils/router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/icon_checkbox.dart';

/// Page for selecting teams
/// Here are the coded features :
///   - Fetch teams from Firestore
///   - Select a team
///   - Mark a team as favorite
///   - Filter by selected and/or marked teams
///   - Search for a team
///   - Refresh teams
///   - Save selected and marked teams to SharedPreferences
///   - Display a list of teams
///   - Show a loading indicator while fetching teams
///   - Show a snackbar on the status of fetching teams
class TeamsPage extends StatefulWidget {

  /// Constructor for the [TeamsPage] widget
  const TeamsPage({super.key});

  /// Create a state for the [TeamsPage] widget
  @override
  State<TeamsPage> createState() => _TeamsPageState();
}

/// State class for the [TeamsPage] widget
/// This class contains the state for the [TeamsPage] widget
/// and implements the build method
/// The state class also contains methods for fetching teams,
/// selecting all teams, marking all teams, filtering teams,
/// searching for teams, and saving team states to SharedPreferences
/// The state class also initializes the page and loads teams from Firestore
class _TeamsPageState extends State<TeamsPage> {

  /// State variables
  bool _isInitialLoading = true; // Initial loading state
  bool _isFetching = false; // Fetching teams state
  String _searchTerm = ''; // Search term
  final Map<String, Map<String, dynamic>> _teams = {}; // Teams data

  bool _showSelectedOnly = false; // Show selected teams only
  bool _showMarkedOnly = false; // Show marked teams only

  /// Keys used for storing data in SharedPreferences
  static const String _teamsPrefsKey = 'stored_teams'; // Key for storing teams
  static const String _selectedTeamsKey = 'selected_teams'; // Key for storing selected teams
  static const String _markedTeamsKey = 'marked_teams'; // Key for storing marked teams

  late SharedPreferences _prefs; // SharedPreferences instance

  /// Initialize the state of the widget
  @override
  void initState() {
    super.initState();
    _initializePreferences();
  }

  /// Initialize the SharedPreferences instance and load stored teams
  Future<void> _initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    await Future.wait([
      _loadStoredTeams(),
      _loadTeamStates(),
    ]);

    if (_teams.isEmpty) {
      await _initializePage();
    }

    if (mounted) {
      setState(() => _isInitialLoading = false);
    }
  }

  /// Load the selected and marked states of teams from SharedPreferences
  Future<void> _loadTeamStates() async {
    final selectedTeams = _prefs.getStringList(_selectedTeamsKey) ?? [];
    final markedTeams = _prefs.getStringList(_markedTeamsKey) ?? [];

    setState(() {
      for (var teamId in _teams.keys) {
        _teams[teamId]?['selected'] = selectedTeams.contains(teamId);
        _teams[teamId]?['marked'] = markedTeams.contains(teamId);
      }
    });
  }

  /// Save the selected and marked states of teams to SharedPreferences
  Future<void> _saveTeamStates() async {
    final selectedTeams = _teams.entries
        .where((e) => e.value['selected'] == true)
        .map((e) => e.key)
        .toList();

    final markedTeams = _teams.entries
        .where((e) => e.value['marked'] == true)
        .map((e) => e.key)
        .toList();

    await Future.wait([
      _prefs.setStringList(_selectedTeamsKey, selectedTeams),
      _prefs.setStringList(_markedTeamsKey, markedTeams),
    ]);
  }

  /// Load stored teams from SharedPreferences
  Future<void> _loadStoredTeams() async {
    final String? storedTeams = _prefs.getString(_teamsPrefsKey);
    if (storedTeams != null) {
      setState(() {
        final Map<String, dynamic> decodedTeams = json.decode(storedTeams);
        _teams.clear();
        decodedTeams.forEach((key, value) {
          _teams[key] = Map<String, dynamic>.from(value);
        });
      });
    }
  }

  /// Save teams to SharedPreferences
  Future<void> _saveTeamsToPreferences() async {
    final String encodedTeams = json.encode(_teams);
    await _prefs.setString(_teamsPrefsKey, encodedTeams);
  }

  /// Initialize the page by fetching teams from Firestore
  Future<void> _initializePage() async {
    setState(() => _isFetching = true);
    try {
      await _fetchTeams();
      await _saveTeamsToPreferences();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading teams: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isFetching = false);
      }
    }
  }

  /// Fetch teams from Firestore
  Future<void> _fetchTeams() async {
    final QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('equipes').get();
    if (!mounted) return;
    setState(() {
      _teams.clear();
      for (var doc in querySnapshot.docs) {
        _teams[doc.id] = {
          'teamName': doc['teamName'] as String,
          'selected': false,
          'marked': false,
        };
      }
    });
  }

  /// Filter teams based on search term, selected state, and marked state
  Map<String, Map<String, dynamic>> _getFilteredTeams() {
    return Map.fromEntries(
        _teams.entries.where((entry) {
          final team = entry.value;
          final matchesSearch = _searchTerm.isEmpty ||
              team['teamName'].toString().toUpperCase().contains(_searchTerm.toUpperCase());
          final matchesSelected = !_showSelectedOnly || team['selected'] == true;
          final matchesMarked = !_showMarkedOnly || team['marked'] == true;
          return matchesSearch && matchesSelected && matchesMarked;
        })
    );
  }

  /// Build the widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      floatingActionButton: _buildFilterFAB(),
      body: _isInitialLoading
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading teams...'),
          ],
        ),
      )
          : _buildBody(),
    );
  }

  /// Widget for the filter FAB
  Widget _buildFilterFAB() {
    return FloatingActionButton.extended(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Filter Teams'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CheckboxListTile(
                  title: const Text('Show Selected Only'),
                  value: _showSelectedOnly,
                  activeColor: Colors.blueAccent,
                  onChanged: (value) {
                    setState(() => _showSelectedOnly = value ?? false);
                    Navigator.pop(context);
                  },
                ),
                CheckboxListTile(
                  title: const Text('Show Marked Only'),
                  value: _showMarkedOnly,
                  activeColor: Colors.blueAccent,
                  onChanged: (value) {
                    setState(() => _showMarkedOnly = value ?? false);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _showSelectedOnly = false;
                    _showMarkedOnly = false;
                  });
                  Navigator.pop(context);
                },
                child: const Text(
                    'Clear Filters',
                    style: TextStyle(
                      color: Colors.blueAccent,
                    ),
                  ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Close',
                  style: TextStyle(
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      label: const Text(
          'Filter',
          style: TextStyle(
            color: Colors.white,
          ),
      ),
      icon: const Icon(
          Icons.filter_list,
          color: Colors.white,
      ),
      backgroundColor: Colors.blueAccent,
    );
  }

  /// Build the app bar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
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
        icon: const Icon(Icons.arrow_back_rounded, size: 35),
        onPressed: () {
          if (GoRouter.of(context).canPop()) {
            context.pop();
          } else {
            context.go(RouteNames.settings.path);
          }
        },
        tooltip: 'Go back',
      ),
    );
  }

  /// Build the body of the widget
  Widget _buildBody() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAddTeamButton(),
            const SizedBox(height: 20),
            _buildSearchBar(),
            const SizedBox(height: 20),
            Expanded(
              child: _isFetching
                  ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Fetching teams...'),
                  ],
                ),
              )
                  : _buildTeamsList(),
            ),
          ],
        ),
      ),
    );
  }

  /// Build the add team button widget
  Widget _buildAddTeamButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isFetching
            ? null
            : () async {
          await _initializePage();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Teams updated and saved'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        icon: _isFetching
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : const Icon(Icons.refresh_rounded, color: Colors.white),
        label: Text(
          _isFetching ? 'Loading...' : 'Refresh Teams',
          style: const TextStyle(fontSize: 16, color: Colors.white),
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

  /// Build the search bar widget
  Widget _buildSearchBar() {
    return TextField(
      decoration: const InputDecoration(
        hintText: 'Search for a team',
        prefixIcon: Icon(Icons.search_rounded),
      ),
      onChanged: (value) => setState(() => _searchTerm = value),
    );
  }

  /// Build the teams list widget
  Widget _buildTeamsList() {
    final filteredTeams = _getFilteredTeams();

    if (filteredTeams.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _teams.isEmpty
                  ? 'No teams available.\nTap the refresh button to fetch teams.'
                  : _showSelectedOnly || _showMarkedOnly
                    ? 'No teams match the selected filters.'
                    : 'No teams match the search term.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredTeams.length,
      itemBuilder: (context, index) {
        final team = filteredTeams.values.elementAt(index);
        final teamId = filteredTeams.keys.elementAt(index);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconCheckbox(
                iconChecked: Icons.indeterminate_check_box,
                iconUnchecked: Icons.check_box_outline_blank,
                initialValue: team['selected'],
                onChanged: (value) {
                  setState(() {
                    _teams[teamId]?['selected'] = value;
                  });
                  _saveTeamStates();
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    team['teamName'],
                    style: const TextStyle(fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              IconCheckbox(
                iconChecked: Icons.star_rounded,
                iconUnchecked: Icons.star_outline_rounded,
                checkedColor: const Color(0xFFFFD700),
                initialValue: team['marked'],
                onChanged: (value) {
                  setState(() {
                    _teams[teamId]?['marked'] = value;
                    if (value == true) {
                      _teams[teamId]?['selected'] = true;
                    }
                  });
                  _saveTeamStates();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _saveTeamsToPreferences();
    _saveTeamStates();
    super.dispose();
  }
}