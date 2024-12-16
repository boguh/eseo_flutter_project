import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/event_details_page.dart';
import '../pages/loading_page.dart';

import '../pages/profile_settings_page.dart';
import '../pages/teams_select_page.dart';
import '../pages/welcome_page.dart';



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
  teams('/teams'),
  profile('/profile');

  final String path;
  const RouteNames(this.path);
}
