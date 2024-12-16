import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:eseo_flutter_project/pages/event_details_page.dart';
import 'package:eseo_flutter_project/pages/loading_page.dart';
import 'package:eseo_flutter_project/pages/settings_page.dart';
import 'package:eseo_flutter_project/pages/profile_settings_page.dart';
import 'package:eseo_flutter_project/pages/teams_select_page.dart';
import 'package:eseo_flutter_project/pages/welcome_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.loading.path, // Correct reference to the enum's path
    routes: [
      GoRoute(
        path: RouteNames.loading.path, // Correct reference to the enum's path
        builder: (context, state) => const LoadingPage(),
      ),
      GoRoute(
        path: RouteNames.welcome.path, // Correct reference to the enum's path
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: RouteNames.details.path, // Correct reference to the enum's path
        builder: (context, state) => const DetailsPage(),
      ),
      GoRoute(
        path: RouteNames.settings.path, // Correct reference to the enum's path
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: RouteNames.teams.path, // Correct reference to the enum's path
        builder: (context, state) => const TeamsPage(),
      ),
      GoRoute(
        path: RouteNames.profile.path, // Correct reference to the enum's path
        builder: (context, state) => const ProfilePage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Navigation error: ${state.error}'),
      ),
    ),
  );
}

enum RouteNames {
  loading('/loading'),
  welcome('/welcome'),
  details('/details'),
  settings('/settings'),
  teams('/teams'),
  profile('/profile');

  final String path;
  const RouteNames(this.path);
}
