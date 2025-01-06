# Buni - Basket Match Tracker

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Technical Architecture](#technical-architecture)
- [Screens](#screens)
- [Data Persistence](#data-persistence)
- [Authentication](#authentication)
- [Dependencies](#dependencies)

## Overview
Buni is a mobile application for Android that allows basketball enthusiasts to track their favorite teams' matches on a weekly basis and sync them with their Google Calendar. The application pulls match data from the French Basketball Federation (FFBB) website and provides an intuitive interface for managing and following teams.

## Features
- Weekly match schedule viewing
- Team following system
- Google Calendar integration
- Match details viewing
- User profile management
- Team filtering and search
- Persistent data storage

## Technical Architecture

### APIs Used
- **Google Calendar API**: Used for creating and managing events in users' Google calendars
- **Firebase**: Backend services for data storage and authentication
- **Google Sign-In**: User authentication and calendar access authorization

### Data Flow
1. Match data is scraped from FFBB website
2. Data is stored in Firebase Firestore
3. App fetches and displays relevant matches based on user preferences
4. Selected matches can be synced to Google Calendar

## Screens

### 1. Loading Screen (`loading_page.dart`)
- Initial splash screen
- Displays app logo and branding

### 2. Welcome Screen (`welcome_page.dart`)
- Main screen of the application
- Weekly calendar view
- List of matches for selected teams
- Navigation to settings
- Custom app bar with calendar widget

### 3. Settings Screen (`settings_page.dart`)
- Account management
- Google account connection
- Team preferences access
- Navigation to other settings

### 4. Team Selection Screen (`teams_select_page.dart`)
- List of available teams
- Search functionality
- Filter options
- Team selection/deselection
- Refresh team data capability

### 5. Event Details Screen (`event_details_page.dart`)
- Match information display
- Team names and championship details
- Date and time information
- Google Calendar integration button
- Action menu for various operations

### 6. Profile Screen (`profile_page.dart`)
- User profile management
- Profile picture upload
- Name editing capabilities
- Save/update profile information

## Data Persistence

### Firebase Integration
- **Firestore**: Stores match data scraped from FFBB
- **Authentication**: Manages user accounts and sessions

### Local Storage
- **SharedPreferences**:
    - Stores user team selections
    - Caches team data for offline access
    - Maintains user preferences

## Authentication

### Google Sign-In Implementation
- Integrated through `google_sign_in` package
- Scopes:
    - Email access
    - Calendar API access
- Features:
    - Sign in/out functionality
    - Token management
    - Calendar API authorization

## Dependencies

### Major Packages
```yaml
dependencies:
  # Navigation
  go_router: ^14.6.2

  # UI Components
  google_fonts: ^6.2.1
  flutter_svg: ^2.0.16
  animated_custom_dropdown: ^3.1.1

  # Google Services
  googleapis: 13.2.0
  google_sign_in: ^6.2.2
  extension_google_sign_in_as_googleapis_auth: ^2.0.12

  # Firebase
  firebase_core: ^3.9.0
  firebase_auth: ^5.3.4
  cloud_firestore: ^5.6.0

  # Local Storage
  shared_preferences: ^2.0.6

  # Calendar Integration
  add_2_calendar: ^2.1.0

  # Utilities
  intl: ^0.20.1
  image_picker: ^1.1.2
```

### Development Dependencies
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
```

## Future Improvements
1. Implementation of global state management
2. Enhanced offline capabilities
3. Additional calendar integration options
4. Performance optimizations
5. Extended team statistics
6. Match notifications system

## Getting Started

### Prerequisites
- Flutter SDK
- Android Studio / VS Code
- Firebase account
- Google Cloud Platform account

### Configuration
1. Set up Firebase project
2. Configure Google Calendar API
3. Add required API keys and configurations
4. Run `flutter pub get`
5. Build and run the application

