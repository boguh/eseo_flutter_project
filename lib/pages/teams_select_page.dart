import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../services/teams_select_service.dart';
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
  bool _isInitialLoading = true;
  bool _isFetching = false;
  String _searchTerm = '';
   Map<String, Map<String, dynamic>> _teams = {};
  bool _showSelectedOnly = false;

  static const String _teamsPrefsKey = 'stored_teams';
  static const String _selectedTeamsKey = 'selected_teams';

  late SharedPreferences _prefs;

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

    setState(() {
      for (var teamId in _teams.keys) {
        _teams[teamId]?['selected'] = selectedTeams.contains(teamId);
      }
    });
  }

  /// Save the selected and marked states of teams to SharedPreferences
  Future<void> _saveTeamStates() async {
    final selectedTeams = _teams.entries
        .where((e) => e.value['selected'] == true)
        .map((e) => e.key)
        .toList();

    await Future.wait([
      _prefs.setStringList(_selectedTeamsKey, selectedTeams),
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
      _teams= await fetchTeams(mounted, _teams) ;
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

  /// Build the widget
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (GoRouter.of(context).canPop()) {
          context.pop();
        } else {
          context.go(RouteNames.settings.path);
        }
        return false;
      },
      child: Scaffold(
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
      ),
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
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _showSelectedOnly = false;
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
        // Remove the underline
        border: InputBorder.none,
      ),
      onChanged: (value) => setState(() => _searchTerm = value),
    );
  }

  /// Build the teams list widget
  Widget _buildTeamsList() {
    final filteredTeams = getFilteredTeams(_teams, _searchTerm, _showSelectedOnly);

    if (filteredTeams.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _teams.isEmpty
                  ? 'No teams available.\nTap the refresh button to fetch teams.'
                  : _showSelectedOnly
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
              const SizedBox(width: 12), // Add spacing between checkbox and text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatTeamName(team),
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      team['championnat'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatTeamName(Map<String, dynamic> team) {
    return team['teamName'].split(' - ')[1];
  }

  @override
  void dispose() {
    _saveTeamsToPreferences();
    _saveTeamStates();
    super.dispose();
  }
}