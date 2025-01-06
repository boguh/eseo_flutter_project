import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeamsCubit extends Cubit<Map<String, dynamic>> {
  TeamsCubit() : super({});

  static const String _selectedTeamsKey = 'selected_teams';

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedTeams = prefs.getStringList(_selectedTeamsKey) ?? [];
    emit({'selectedTeams': selectedTeams});
  }

  Future<void> updateSelectedTeams(List<String> selectedTeams) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_selectedTeamsKey, selectedTeams);
    emit({'selectedTeams': selectedTeams});
  }

  List<String> get selectedTeams => state['selectedTeams'] ?? [];
}