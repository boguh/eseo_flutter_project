import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import '../utils/router.dart';
import 'package:go_router/go_router.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key, this.onMonthChanged, this.onWeekChanged});

  /// Callback to notify the selected month
  final void Function(String)? onMonthChanged;

  /// Callback to notify the selected week
  final void Function(int)? onWeekChanged;

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {

  // State variables
  String _selectedMonth = Month.values.firstWhere((month) => month.value == DateTime.now().month).name;
  int _selectedWeek = 0;
  List<int> _weeks = [];

  /// Initialize the state variables
  @override
  void initState() {
    super.initState();
    _updateWeeks();
  }

  List<int> getWeeks(int year, int month) {
    // Get the first day of the month (based on the year) to compute the first week
    final firstDay = DateTime(year, month, 1);
    final firstWeek = firstDay.weekday;
    final firstWeekIndex = firstWeek == 6 || firstWeek == 7 ? (firstDay.dayOfYear / 7).floor() : (firstDay.dayOfYear / 7).ceil();
    // Get the last day of the month (based on the year) to compute the last week
    final lastDay = DateTime(year, month + 1, 0);
    final lastWeek = lastDay.weekday;
    final lastWeekIndex = lastWeek == 6 || lastWeek == 7 ? (lastDay.dayOfYear / 7).ceil() : (lastDay.dayOfYear / 7).floor();
    // Generate the list of weeks between the first and last week
    final weeks = List<int>.generate(lastWeekIndex - firstWeekIndex + 1, (index) => firstWeekIndex + index);
    return weeks;
  }

    /// Update the selected week
  void _updateWeek(int week) {
    setState(() {
      _selectedWeek = week;
    });
  }

  /// Update the weeks based on the selected month
  void _updateWeeks() {
    final now = DateTime.now();
    final selectedMonth = Month.values.firstWhere((month) => month.name == _selectedMonth);
    final weeks = getWeeks(now.year, selectedMonth.value);

    if (now.month == selectedMonth.value) {
      final week = weeks.firstWhere((week) => now.dayOfYear <= week * 7);
      _updateWeek(week);
    } else {
      _updateWeek(weeks.first);
    }

    setState(() {
      _weeks = weeks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildMonthSelector(),
            _buildWeeksDisplay(),
          ],
        ),
      )
    );
  }

  Widget _buildMonthSelector() {
    return Container(
      // Align the dropdown to the left
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      width: MediaQuery.of(context).size.width * 0.5,
      child: CustomDropdown<String>(

        decoration: const CustomDropdownDecoration(
          closedFillColor: Colors.blueAccent,
          headerStyle: TextStyle(
            color: Colors.white,
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
          ),
          closedSuffixIcon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.white,
          ),
        ),
        hintText: 'Select a month',
        items: Month.values.map((month) => month.name).toList(),
        initialItem: _selectedMonth,
        onChanged: (value) {
          setState(() {
            _selectedWeek = 0;
            _selectedMonth = value!;
            _updateWeeks();
          });
          if (widget.onMonthChanged != null) {
            widget.onMonthChanged!(value!);
          }
        },
      ),
    );
  }


  Widget _buildWeeksDisplay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _weeks
          .map((week) => GestureDetector(
        onTap: () => {
          _updateWeek(week),
          if (widget.onWeekChanged != null) {
            widget.onWeekChanged!(week),
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(
              vertical: 12.0, horizontal: 12.0),
          decoration: BoxDecoration(
            color:
            _selectedWeek != week ? Colors.blueAccent : Colors.white,
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Wk',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: _selectedWeek != week
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              const SizedBox(height: 2.0),
              Text(
                '$week',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _selectedWeek != week
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ))
          .toList(),
    );
  }
}

/// Extension to get the day of the year from a DateTime object
extension on DateTime {
  int get dayOfYear => int.parse(DateFormat('D').format(this));
}

/// Enum to represent the months of the year according to the basketball season
enum Month {
  september(9, 'Sept', 30),
  october(10, 'Oct', 31),
  november(11, 'Nov', 30),
  december(12, 'Dec', 31),
  january(1, 'Jan', 31),
  february(2, 'Feb', 28),
  march(3, 'Mar', 31),
  april(4, 'Apr', 30),
  may(5, 'May', 31),
  june(6, 'Jun', 30),
  july(7, 'Jul', 31),
  august(8, 'Aug', 31);

  // Month properties
  final int value;
  final String name;
  final int days;

  // Month constructor
  const Month(this.value, this.name, this.days);

  // toString method (add the year to the month name)
  @override
  String toString() => '$name(${DateTime.now().year})';
}
