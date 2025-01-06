import '../widgets/google_auth_button.dart';
import '../widgets/notifications_toggle.dart';
import '../widgets/personal_information.dart';
import '../widgets/team_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/actions_menu.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();

  static void build(BuildContext context) {
    SettingsPage.build(context);
  }
}

class _SettingsPageState extends State<SettingsPage> {
  // State variables
  bool _isLoading = false;

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
