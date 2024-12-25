import 'package:googleapis/calendar/v3.dart' as cal;

class CalendarClient {
  static cal.CalendarApi? calendar;

  Future<Map<String, String>?> insert({
    required String title,
    required String description,
    required String location,
    required List<cal.EventAttendee> attendeeEmailList,
    required bool shouldNotifyAttendees,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    String calendarId = "primary";
    cal.Event event = cal.Event();

    event.summary = title;
    event.description = description;
    event.attendees = attendeeEmailList;
    event.location = location;

    cal.EventDateTime start = cal.EventDateTime();
    start.dateTime = startTime;
    start.timeZone = "GMT+05:30";
    event.start = start;

    cal.EventDateTime end = cal.EventDateTime();
    end.timeZone = "GMT+05:30";
    end.dateTime = endTime;
    event.end = end;

    await calendar?.events.insert(event, calendarId,
        sendUpdates: shouldNotifyAttendees ? "all" : "none");

    return null;
  }
}