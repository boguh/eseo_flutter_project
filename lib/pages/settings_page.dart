import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
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
    return Scaffold(
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
              context.go('/welcome'); // Fallback navigation
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
              // Navigation Options
              ListTile(
                leading: const Icon(
                  Icons.checklist_rounded,
                  size: 30,
                  color: Colors.black,
                ), // Icon on the left
                title: Text(
                  'Select Teams',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
                onTap: () {
                  context.go('/teams'); // Navigate to Select Teams page
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.person_rounded,
                  size: 30,
                  color: Colors.black,
                ), // Icon on the left
                title: Text(
                  'Manage Profile',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
                onTap: () {
                  context.go('/profile'); // Navigate to Manage Profile page
                },
              ),
            ],
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
