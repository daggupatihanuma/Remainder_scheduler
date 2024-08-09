import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'notification_service.dart'; // Import the notification service

class ReminderHomePage extends StatefulWidget {
  const ReminderHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ReminderHomePageState createState() => _ReminderHomePageState();
}

class _ReminderHomePageState extends State<ReminderHomePage> {
  TimeOfDay? _selectedTime;
  String? _selectedActivity;
  Day? _selectedDay;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones(); // Initialize time zones
    _initializeNotifications(); // Initialize notifications
  }

  Future<void> _scheduleNotification() async {
    if (_selectedDay != null && _selectedTime != null && _selectedActivity != null) {
      final now = DateTime.now();
      final selectedDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      // Schedule notification using the notification service
      await scheduleNotification(selectedDateTime, _selectedActivity!);
    } else {
      print('Cannot schedule notification. One or more fields are null.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminder App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Day selector
            DropdownButton<Day>(
              value: _selectedDay,
              hint: const Text('Select Day'),
              items: Day.values.map((Day day) {
                return DropdownMenuItem<Day>(
                  value: day,
                  child: Text(day.toString().split('.').last),
                );
              }).toList(),
              onChanged: (Day? newValue) {
                setState(() {
                  _selectedDay = newValue;
                });
              },
            ),
            // Time selector
            ElevatedButton(
              onPressed: () async {
                final TimeOfDay? time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) {
                  setState(() {
                    _selectedTime = time;
                  });
                }
              },
              child: Text(_selectedTime == null ? 'Select Time' : 'Selected Time: ${_selectedTime!.format(context)}'),
            ),
            // Activity selector
            DropdownButton<String>(
              value: _selectedActivity,
              hint: const Text('Select Activity'),
              items: <String>[
                'Wake up',
                'Go to gym',
                'Breakfast',
                'Meetings',
                'Lunch',
                'Quick nap',
                'Go to library',
                'Dinner',
                'Go to sleep',
              ].map((String activity) {
                return DropdownMenuItem<String>(
                  value: activity,
                  child: Text(activity),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedActivity = newValue;
                });
              },
            ),
            // Schedule button
            ElevatedButton(
              onPressed: _scheduleNotification,
              child: const Text('Schedule Reminder'),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class _initializeNotifications {
}

// ignore: constant_identifier_names
enum Day { Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday }
