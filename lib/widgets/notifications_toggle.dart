import 'package:flutter/material.dart';

class NotificationToggle extends StatefulWidget {
  const NotificationToggle({super.key});

  @override
  State<NotificationToggle> createState() => _NotificationToggleState();
}

class _NotificationToggleState extends State<NotificationToggle> {
  bool _isNotificationEnabled = true; // Default state of the toggle

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // Notification icon inside a rounded square with shadow
            Container(
              padding: const EdgeInsets.all(10), // Padding inside the container
              decoration: BoxDecoration(
                color: Colors.white, // White background for the icon
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // Shadow color
                    blurRadius: 6, // Blur effect for shadow
                    offset: const Offset(0, 2), // Position of shadow
                  ),
                ],
              ),
              child: const Icon(
                Icons.notifications_outlined,
                color: Colors.black, // Icon color
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Notifications',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ],
        ),
        Switch(
          value: _isNotificationEnabled, // Toggle switch state
          onChanged: (bool value) {
            setState(() {
              _isNotificationEnabled = value; // Update state
            });
          },
          activeColor: Colors.white, // Color when the switch is ON
          inactiveThumbColor: Colors.white, // Color of the thumb when OFF
          inactiveTrackColor: Colors.black.withOpacity(0.1), // Track color when OFF
          activeTrackColor: Colors.blueAccent, // Track color when ON
          trackOutlineWidth: const WidgetStatePropertyAll(0.0),
        ),
      ],
    );
  }
}
