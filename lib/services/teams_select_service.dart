import 'package:cloud_firestore/cloud_firestore.dart';

/// Filter teams based on search term, selected state, and marked state
Map<String, Map<String, dynamic>> getFilteredTeams(teams,searchTerm,showSelectedOnly) {
  return Map.fromEntries(
      teams.entries.where((entry) {
        final team = entry.value;
        final matchesSearch = searchTerm.isEmpty ||
            team['teamName'].toString().toUpperCase().contains(searchTerm.toUpperCase());
        final matchesSelected = !showSelectedOnly || team['selected'] == true;
        return matchesSearch && matchesSelected;


      })
  );
}
/// Fetch teams from Firestore
Future<Map<String, Map<String, dynamic>>> fetchTeams(mounted,teams) async {
  final QuerySnapshot querySnapshot =
  await FirebaseFirestore.instance.collection('equipes').get();
 // if (!mounted) return teams;
  teams.clear();
  print ('teams');
    for (var doc in querySnapshot.docs) {
      teams[doc.id] = {
        'teamName': doc['teamName'] as String,
        'championnat': doc['championnat'] as String?  ?? '',
        'selected': false,
        'marked': false,
      };
    }
    print ('teams: $teams');
return teams;
}

