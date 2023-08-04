// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../utils.dart';

class TableRangeExample extends StatefulWidget {
  @override
  _TableRangeExampleState createState() => _TableRangeExampleState();
}

class _TableRangeExampleState extends State<TableRangeExample> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.selectDistinct; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  DateTime? _reminderDay;
  late final ValueNotifier<SelectedDayMode> _selectedDayMode;

  @override
  void initState() {
    super.initState();
    _selectedDayMode = ValueNotifier<SelectedDayMode>(SelectedDayMode.none);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TableCalendar - Range'),
      ),
      body: Column(
        children: [
          ValueListenableBuilder(valueListenable: _selectedDayMode, builder: (context, value, child){
            return  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    ElevatedButton(onPressed: () {
                      _selectedDayMode.value = SelectedDayMode.start;
                    }, child: Text('bat dau')),
                    Text(
                      _rangeStart?.toIso8601String().split('T')[0] ?? '',
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(onPressed: () {
                      _selectedDayMode.value = SelectedDayMode.end;
                    }, child: Text('toi han')),
                    Text(_rangeEnd?.toIso8601String().split('T')[0] ?? '', style: TextStyle(color: Colors.red))
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(onPressed: () {
                      _selectedDayMode.value = SelectedDayMode.reminder;
                    }, child: Text('Nhac viec')),
                    Text(_reminderDay?.toIso8601String().split('T')[0] ?? '', style: TextStyle(color: Colors.red))
                  ],
                ),
              ],
            );
          }),
          TableCalendar(
            calendarBuilders: CalendarBuilders(
              headerTitleBuilder: (context, day){
                return Container(
                  child: Text(
                    'Tháng ${day.month} năm ${day.year}'
                  ),
                );
              }
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleTextFormatter: (date, locale) => 'Tháng ${DateFormat('MM y').format(date)}',
            ),
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            selectedDayMode: _selectedDayMode,
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            reminderDay: _reminderDay,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            calendarStyle: CalendarStyle(isTodayHighlighted: false),
            onStartDaySelected: (selectedDay) {
              setState(() {
                _selectedDay = null;
                _rangeStart = selectedDay;
              });
            },
            onEndDaySelected: (selectedDay) {
              setState(() {
                _selectedDay = null;
                _rangeEnd = selectedDay;
              });
            },
            onReminderDaySelected: (selectedDay) {
              setState(() {
                _reminderDay = selectedDay;
              });
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
        ],
      ),
    );
  }
}
