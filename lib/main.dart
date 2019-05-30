import 'package:flutter/material.dart';
import 'package:neumont_planner/views/day_view.dart';
import 'package:neumont_planner/views/hour_view.dart';
import 'package:neumont_planner/views/month_view.dart';
import 'package:neumont_planner/views/week_view.dart';

import 'models/objects/Course.dart';
import 'models/objects/assignment.dart';
import 'models/objects/custom_event.dart';
import 'views/view_manager.dart';


enum View { MONTH, WEEK, DAY, HOUR }

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neumont Planner',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: MyHomePage(title: 'Neumont Planner'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  View _currentViewType = View.MONTH;
  DateTime _today = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  List<Assignment> _assignments = [];
  List<Course> _courses = [];
  List<CustomEvent> _events = [];

  Widget getView(View view, Function(View, DateTime) changeView) {
    if (view == View.DAY && _selectedDate.day == _today.day) {
      return HourView(_assignments, _courses, _events, changeView);
    } else if (view == View.DAY) {
      return DayView(_assignments, _courses, _events, changeView);
    } else if (view == View.WEEK) {
      return WeekView(
          _assignments, _courses, _events, changeView, _selectedDate);
    } else if (view == View.MONTH) {
      return MonthView(_assignments, _courses, _events, changeView);
    } else {
      return Text('Yikes');
    }
  }

  void changeView(View view, DateTime newDate) {
    _assignments.clear();
    _courses.clear();
    _events.clear();
    setState(() {
      _currentViewType = view;
      _selectedDate = newDate;
      //simulates Assignment api call;
      for (int i = 0; i < 30; i++) {
        //_assignments.add(new Assignment(i, "Assignment " + i.toString(), "This is worth alotta points", 25.0, DateTime.now().add(new Duration(days: -15+i)), false));
        var assignment = new Assignment(id: i, name: "Assignment " + i.toString(), description: "Eh you could probably skip this", pp: 25, dueAt: DateTime.now().add(new Duration(days: -15 + 1)), hasSubmitted: false);
        print(assignment.id);
        _assignments.add(assignment);
      }
      for (var i = 0; i < 2; i++) {
        // _events.add(new Event(id:i, "This is a test event", "Test Event",
        //     DateTime.now(), DateTime.now().add(new Duration(days: 7))));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            ViewManager(changeView, _selectedDate, _currentViewType),
            getView(_currentViewType, changeView),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: null,
      //   tooltip: 'Add Event',
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
