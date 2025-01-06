import '../widgets/google_auth_button.dart';
import '../widgets/notifications_toggle.dart';
import '../widgets/team_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/actions_menu.dart';

/// Class representing the [SettingsPage] as a [StatefulWidget]
/// with a [State] class [_SettingsPageState]
class SettingsPage extends StatefulWidget {

  // Constructor
  const SettingsPage({super.key});

  // Create a state object for this widget
  @override
  State<SettingsPage> createState() => _SettingsPageState();

  // Static method to build the page
  static void build(BuildContext context) {
    SettingsPage.build(context);
  }
}

/// Private state class for [SettingsPage] with [State<SettingsPage>]
/// It manages the state of the [SettingsPage] widget
/// Also includes methods for building the UI and managing state that include :
/// - [initState] : Initializes the state of the widget
/// - [build] : Builds the UI of the widget
/// - [dispose] : Cleans up resources when the widget is removed from the tree
class _SettingsPageState extends State<SettingsPage> {

  // State variables
  bool _isLoading = false;

  /// Method to initialize the state of the widget
  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  /// Asynchronous method to initialize the page
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

  /// Method to build the UI of the widget
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Gestion explicite du retour arrière
        if (GoRouter.of(context).canPop()) {
          context.pop();
        } else {
          context.go(RouteNames.welcome.path); // Page fallback
        }
        return false; // Empêche le comportement par défaut
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          centerTitle: true,
          title: Text(
            'Settings',
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
                context.go(RouteNames.welcome.path); // Fallback navigation
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Account settings
                const ActionsMenu(
                  title: 'Account',
                  children: [
                    GoogleAccountToggle(),
                  ],
                ),
                // Add some space between sections
                const SizedBox(height: 30),
                // Third section: Preferences
                ActionsMenu(
                  title: 'Preferences',
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Redirection when tapping the entire widget
                        context.go(RouteNames.teams.path);
                      },
                      child: const TeamsListRedirect(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up controllers, listeners, etc.
    super.dispose();
  }
}
