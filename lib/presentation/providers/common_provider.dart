import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

final selectedViewIndexProvider = StateProvider(
  (ref) => 0,
);

final selectedCalendarFormatProvider = StateProvider(
  (ref) => CalendarFormat.month,
);

final selectedCalendarDayProvider = StateProvider(
  (ref) => DateTime.now(),
);

final focusedCalendarDayProvider = StateProvider(
  (ref) => DateTime.now(),
);
