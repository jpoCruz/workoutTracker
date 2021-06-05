import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:workout_tracker/addWorkout.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:workout_tracker/editWorkout.dart';
import 'package:workout_tracker/calendarevent.dart';
import 'package:intl/intl.dart';

class WorkoutPage extends StatefulWidget {
  @override
  _WorkoutPageState createState() {
    return _WorkoutPageState();
  }
}

class _WorkoutPageState extends State<WorkoutPage> {

  Query _ref;
  Query _refWeek;
  DatabaseReference _reference = FirebaseDatabase.instance.reference().child('Exercises');
  String _today = "";
  String _todayFull = "";



  int _currentIndex = 0;
  PageController _pageController;
  SharedPreferences _sharedPreferences;
  String _name = "";
  String _buttonText = "Start timer";

  //CALENDAR
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<CalendarEvent>> selectedEvents;
  DateTime selectedDay = DateTime.now();

  List<CalendarEvent> _getEventsFromDay(DateTime date){
    return selectedEvents[date] ?? [];
  }


  _showDeleteDialog({Map exercise}){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        backgroundColor: Color(0xff242333),
        title: Text("Delete " + exercise['name']),
        content: Text("Are you sure you want to delete this exercise from your list?"),
        
        actions: [
          TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text("Cancel", style: TextStyle(
                color: Color(0xff7C8496)
              ),)),

          TextButton(
              onPressed: (){
                _reference.child(exercise['key']).remove().whenComplete(() => Navigator.pop(context));

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text("Exercise deleted successfully")
                  ),
                );
              },
              child: Text("Delete", style: TextStyle(
                color:  Color(0xff39BA6C)
              ),))
        ],
      );
    });
  }

  _showSettingsDialog(){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        backgroundColor: Color(0xff242333),
        title: Text("Edit timer settings"),
        content: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget> [
              Text("Seconds", style: TextStyle(
                  color: Color(0xff7C8496),
                  fontSize: 15
              ),),
              SizedBox(height: 5,),



            ],
          ),
        ),

        actions: [
          TextButton(
              onPressed: (){

              },
              child: Text("Cancel", style: TextStyle(
                  color: Color(0xff7C8496)
              ),)),

          TextButton(
              onPressed: (){

              },
              child: Text("Update", style: TextStyle(
                  color:  Color(0xff39BA6C)
              ),))
        ],
      );
    });
  }

  Widget _buildExerciseItem({Map exercises}){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color(0xff2E2D42),
      ),

      //height: 80,
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(exercises['name'], style: TextStyle(fontSize: 25,
              fontWeight: FontWeight.w700, color: Color(0xff39BA6C)),),
              MaterialButton(
                height: 25,
                minWidth: 5,
                onPressed: (){},
                child: Text(exercises['muscleGroup']),
                color: Color(0xff39BA6C),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)
                ),
              )
            ],
          ),
          SizedBox(height: 5,),
          Row(
            children: [
              Text(exercises['sets'] + " set(s) of " +  exercises['reps'] + " rep(s)", style: TextStyle(fontSize: 16,
                  fontWeight: FontWeight.w600),),
            ],
          ),
          SizedBox(height: 5,),
          Row(
            children: [
              Icon(Icons.timer, size: 16),
              SizedBox(width: 6,),
              Text(exercises['seconds'] + " seconds ", style: TextStyle(fontSize: 16,
                  fontWeight: FontWeight.w600),)
            ],
          ),
          SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (_) => EditWorkout(
                          exerciseKey: exercises['key'],
                      )));
                },
                child: Row(children: [
                  Icon(Icons.edit, color: Color(0xff1D1D2A), size: 18,)
                ],),
              ),
              SizedBox(width: 8,),
              GestureDetector(
                onTap: (){
                  _showDeleteDialog(exercise: exercises);
                },
                child: Row(children: [
                  Icon(Icons.delete, color: Color(0xff1D1D2A), size: 18,)
                ],),
              ),
            ],
          )
        ],
      ),
      );
  }

  Widget _buildExerciseItemHome({Map exercises}){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color(0xff2E2D42),
      ),

      //height: 80,
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(11),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(exercises['name'], style: TextStyle(fontSize: 26,
                  fontWeight: FontWeight.w700, color: Color(0xff39BA6C)),),
              MaterialButton(
                height: 25,
                minWidth: 5,
                onPressed: (){},
                child: Text(exercises['muscleGroup']),
                color: Color(0xff39BA6C),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)
                ),
              )
            ],
          ),
          SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(exercises['sets'] + " set(s) of " +  exercises['reps'] + " rep(s)", style: TextStyle(fontSize: 14,
                  fontWeight: FontWeight.w600),),

              Row(
                children: [
                  Icon(Icons.timer, size: 16),
                  SizedBox(width: 6,),
                  Text(exercises['seconds'] + " seconds ", style: TextStyle(fontSize: 14,
                      fontWeight: FontWeight.w600),),
                ],
              )
            ],
          ),
          SizedBox(height: 5,),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    sharedPrefs();

    setState(() {
    });
    selectedEvents = {};

    _today = DateFormat('EEE').format(DateTime.now());
    _todayFull = DateFormat('EEEE').format(DateTime.now());

    _ref =     FirebaseDatabase.instance.reference().child('Exercises').orderByChild('name');
    _refWeek = FirebaseDatabase.instance.reference().child('Exercises').orderByChild('day').startAt(_today);
  }

  Future<void> sharedPrefs() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    await Future.delayed(Duration(milliseconds: 1)); //needed to stop crashes while getting name
    _sharedPreferences.setString('name', 'João');

    setState(() {
      _name = _sharedPreferences.getString('name');
    });
  }


  @override
  void dispose() async {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,

        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.menu, color: Color(0xff7C8496)),
              onPressed:(){
                _showSettingsDialog();
              } )
        ],
      ),

      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: <Widget>[
            Padding(// HOME
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget> [
                    Text("Hello, " + _name + '.',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30
                    )),
                    SizedBox(height: 5,),
                    Text("Healthy habits are built one day at a time.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Color(0xff7C8496),
                          fontSize: 15
                      ),),
                    SizedBox(height: 40,),
                    Text("Today is " + _todayFull + ".",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Color(0xff7C8496),
                          fontSize: 15
                      ),),
                    SizedBox(height: 5,),
                    Text("Your workout:",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Color(0xff47C87A)
                        )),

                    SizedBox(height: 10),

                    Container(
                      height: 340,
                      child: FirebaseAnimatedList(
                        query: _refWeek,
                        itemBuilder: (BuildContext context,
                          DataSnapshot snapshot, Animation<double> animation, int index){
                        Map exercises = snapshot.value;
                        exercises['key'] = snapshot.key;
                        return _buildExerciseItemHome(exercises: exercises);
                      },
                      ),
                    ),

                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: MediaQuery.of(context).size.height / 3,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/main-page-illustration.png')
                              )
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),


            Padding(//WORKOUTS
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget> [
                        Text("Workouts ",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30
                            )),
                        SizedBox(height: 15),

                        Container(
                          height: 550,
                          child: FirebaseAnimatedList(query: _ref, itemBuilder: (BuildContext context,
                              DataSnapshot snapshot, Animation<double> animation, int index){
                            Map exercises = snapshot.value;
                            exercises['key'] = snapshot.key;
                            return _buildExerciseItem(exercises: exercises);
                          },
                          ),
                        ),



                        Expanded( //NEW EXERCISE BUTTON
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: MaterialButton(
                              minWidth: double.infinity,
                              height: 60,
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AddWorkout()));
                              },
                              color: Theme.of(context).accentColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)
                              ),
                              child: Text("New Exercise", style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18
                              )),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,)
                      ]
                  )
              ),
            ),

            Padding(//CALENDAR
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget> [
                      Text("Tracker ",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30
                          )),
                      SizedBox(height: 40),
                      Column(
                        children: [
                          TableCalendar(
                            eventLoader: _getEventsFromDay,
                            firstDay: DateTime.utc(2011, 1, 1),
                            lastDay: DateTime.utc(2031, 12, 31),
                            focusedDay: DateTime.now(),

                            calendarFormat: CalendarFormat.month,
                            startingDayOfWeek: StartingDayOfWeek.monday,
                            daysOfWeekStyle: DaysOfWeekStyle(
                              weekdayStyle: TextStyle(
                                  color: Color(0xff47C87A),
                                  fontSize: 14
                              ),
                              weekendStyle: TextStyle(
                                  color: Color(0xff47C87A),
                                  fontSize: 14
                              ),
                            ),
                            headerStyle: HeaderStyle(
                              formatButtonVisible: false,
                              titleCentered: true,
                              titleTextStyle: TextStyle(color: Color(0xff39BA6C), fontSize: 17, fontWeight: FontWeight.w800)
                            ),
                            calendarStyle: CalendarStyle(
                              //markersMaxCount: 1,
                              isTodayHighlighted: true,
                              weekendTextStyle: TextStyle(
                                color: Color(0xffF5F5F5),
                                fontSize: 14
                              ),
                              defaultTextStyle: TextStyle(
                                  color: Color(0xffF5F5F5),
                                  fontSize: 14
                              ),
                              outsideTextStyle: TextStyle(
                                  color: Color(0xff2E2D42),
                                  fontSize: 14
                              ),
                              todayDecoration: BoxDecoration(
                                color: Color(0x6639BA6C),
                                shape: BoxShape.circle,
                              ),
                              selectedDecoration: BoxDecoration(
                                  color: Color(0xff39BA6C),
                                  //borderRadius: BorderRadius.circular(0)
                                  shape: BoxShape.circle,
                              ),
                              rowDecoration: BoxDecoration(
                              ),
                              markerDecoration: BoxDecoration(
                                color: Color(0xff39BA6C),
                              ),
                              markersAutoAligned: true,
                              markersAnchor: 0.5
                            ),

                            selectedDayPredicate: (day) {
                              return isSameDay(_selectedDay, day);
                            },

                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay; // update `_focusedDay` here as well
                              });
                            },


                            ),
                          ..._getEventsFromDay(selectedDay).map((CalendarEvent event) => ListTile(title: Text(event.title),)),
                        ],
                      ),

                      Expanded( //workout complete button
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: MaterialButton(
                            minWidth: double.infinity,
                            height: 60,
                            onPressed: (){

                              if(selectedEvents[selectedDay] != null){
                                selectedEvents[selectedDay].add(CalendarEvent(title: "Workout complete!"));
                              }else{
                                selectedEvents[selectedDay] = [CalendarEvent(title:"Workout complete!")];
                              }
                              setState(() {
                              });

                            },
                            color: Theme.of(context).accentColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)
                            ),
                            child: Text("Workout Done", style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18
                            )),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,)

                      ]
                )
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        curve: Curves.ease,
        backgroundColor: Color(0xff242333),
        containerHeight: 60,

        onItemSelected: (index){

          setState(() {
            _currentIndex = index;
          });
          _pageController.animateToPage(index,
              duration: Duration(milliseconds: 300), curve: Curves.ease);
        },
        items: <BottomNavyBarItem> [
          BottomNavyBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
            activeColor: Theme.of(context).accentColor,
            textAlign: TextAlign.center,
            inactiveColor: Color(0xff7C8496)
          ),
          BottomNavyBarItem(
              icon: Icon(Icons.fitness_center),
              title: Text("Exercises"),
              activeColor: Theme.of(context).accentColor,
              textAlign: TextAlign.center,
              inactiveColor: Color(0xff7C8496)
          ),
          BottomNavyBarItem(
              icon: Icon(Icons.today),
              title: Text("Calendar"),
              activeColor: Theme.of(context).accentColor,
              textAlign: TextAlign.center,
              inactiveColor: Color(0xff7C8496)
          ),
        ],
      )
    );

  }
}