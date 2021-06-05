import 'package:flutter/foundation.dart';

class CalendarEvent{
  final String title;

  CalendarEvent({@required this.title});

  String toString() => this.title;
}