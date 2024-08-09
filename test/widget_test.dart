import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// Ensure this path is correct

void main() {
  testWidgets('Reminder App UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ReminderApp() as Widget);

    // Verify that the initial UI elements are present.
    expect(find.text('Reminder App'), findsOneWidget);
    expect(find.text('Select Day of the Week'), findsOneWidget);
    expect(find.text('Choose Time'), findsOneWidget);
    expect(find.text('Select Activity'), findsOneWidget);

    // Interact with the Day dropdown.
    await tester.tap(find.byType(DropdownButton<String>).first);
    await tester.pumpAndSettle();

    // Select 'Monday' from the dropdown.
    await tester.tap(find.text('Monday').last);
    await tester.pump();

    // Verify that 'Monday' is now selected.
    expect(find.text('Monday'), findsOneWidget);

    // Interact with the Time button.
    await tester.tap(find.text('Choose Time'));
    await tester.pumpAndSettle();

    // Simulate selecting a time (e.g., 10:00 AM).
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Select an activity from the dropdown.
    await tester.tap(find.byType(DropdownButton<String>).last);
    await tester.pumpAndSettle();

    // Select 'Go to gym' from the dropdown.
    await tester.tap(find.text('Go to gym').last);
    await tester.pump();

    // Verify that 'Go to gym' is now selected.
    expect(find.text('Go to gym'), findsOneWidget);

    // Tap the 'Set Reminder' button.
    await tester.tap(find.text('Set Reminder'));
    await tester.pump();

    // Verify that a SnackBar appears with the correct message.
    expect(find.text('Reminder set for Monday at 10:00 AM to Go to gym'), findsOneWidget);
  });
}

class ReminderApp {
  const ReminderApp();
}
