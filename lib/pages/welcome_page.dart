import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
String userEmail= '';
String userName= '';
import '../utils/router.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
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
        backgroundColor: Colors.transparent,
        elevation: 0, // Remove shadow
        leading: IconButton(
          icon: const Icon(
            Icons.menu_rounded,
            size: 35,
          ), // Menu icon
          onPressed: () {
            context.go(RouteNames.profile.path); // Navigate to settings page
          },
          tooltip: 'Settings',
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          :  SafeArea( // TODO remettre const?
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main content of the page
              Text (
                'Welcome, $userName!',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
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