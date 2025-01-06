import 'package:flutter/material.dart';
import '../models/event.dart';
import '../pages/event_details_page.dart';

class EventCard extends StatelessWidget {
  final BuildContext context;
  final Event match;
  final List<String> selectedTeams;

  const EventCard({super.key, required this.context, required this.match, required this.selectedTeams});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailsPage(event: match),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: 100.0,
        margin: const EdgeInsets.only(bottom: 10.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          children: [
            // Date section on the left
            _buildDateTime(match.date),
            const Spacer(),  // Pushes the location icon to the right
            // Team avatars in the middle
            SizedBox(
              width:100.0,  // Width to accommodate both avatars with overlap
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  _buildLogoFromName(match.homeTeam),
                  Positioned(
                    left: 45.0,  // Adjust this value to control overlap amount
                    child: _buildLogoFromName(match.visitorTeam),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20.0),
            // Location status on the right
            _buildLocationStatusLogo(match.isAwayTeam),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoFromName(String teamName) {
    return CircleAvatar(
      backgroundColor: const Color(0x77D9D9D9),
      radius: 25.0,  // Made slightly larger for better visibility
      child: Text(
        // Get the first 3 letters of the team name
        teamName.substring(0, 3).toUpperCase(),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
      ),
    );
  }

  Widget _buildLocationStatusLogo(bool isAwayTeam) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Icon(
        isAwayTeam ? Icons.flight_rounded : Icons.home_rounded,
        color: isAwayTeam ? Colors.blue : Colors.lightGreen,
        size: 24.0,
      ),
    );
  }

  Widget _buildDateTime(String date) {
    var temp = date.toString().split("/");
    var day = temp[0];
    var month = temp[1];
    if (day[0] == "0") {
      day = day[1];
    }
    String monthName = _getMonthName(month);
    return SizedBox(
      width: 60.0,  // Fixed width for consistent alignment
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            day,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            monthName,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(String month) {
    switch (month) {
      case "01":
        return "Jan";
      case "02":
        return "Feb";
      case "03":
        return "Mar";
      case "04":
        return "Apr";
      case "05":
        return "May";
      case "06":
        return "Jun";
      case "07":
        return "Jul";
      case "08":
        return "Aug";
      case "09":
        return "Sep";
      case "10":
        return "Oct";
      case "11":
        return "Nov";
      case "12":
        return "Dec";
      default:
        return "";
    }
  }
}