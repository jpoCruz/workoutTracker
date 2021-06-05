import 'package:flutter/material.dart';
import 'package:workout_tracker/workout.dart';
import 'package:firebase_database/firebase_database.dart' as firebase;
import 'dart:io';

class AddWorkout extends StatefulWidget {
  @override
  _AddWorkoutState createState() => _AddWorkoutState();
}

class _AddWorkoutState extends State<AddWorkout> {

  TextEditingController _exerciseNameController = TextEditingController();
  TextEditingController _exerciseRepController = TextEditingController();
  TextEditingController _exerciseSetController = TextEditingController();
  TextEditingController _exerciseSecondsController = TextEditingController();

  String _typeSelected = "";
  String _weekdaySelected = "";


  Widget _buildExerciseType(String title){
    return InkWell(
      child: Container(
        height: 40, width: 97,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: _typeSelected == title? Color(0xff47C87A) : Color(0xff2E2D42),
        ),
        child: Center(
          child: Text(title, style: TextStyle(fontSize: 15, color: Color(0xffF5F5F5)),),
        ),
      ),
      onTap: (){
        setState(() {
          _typeSelected = title;
        });
      },
    );

  }
  Widget _buildWeekday(String weekday){
    return InkWell(
      child: Container(
        height: 40, width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: _weekdaySelected == weekday? Color(0xff47C87A) : Color(0xff2E2D42),
        ),
        child: Center(
          child: Text(weekday, style: TextStyle(fontSize: 15, color: Color(0xffF5F5F5)),),
        ),
      ),
      onTap: (){
        setState(() {
          _weekdaySelected = weekday;
        });
      },
    );
  }

  firebase.DatabaseReference _ref;

  @override
  void initState(){
    super.initState();
    _ref = firebase.FirebaseDatabase.instance.reference().child('Exercises');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutPage()));
            },
            icon: Icon(Icons.keyboard_arrow_left, color: Color(0xff7C8496))
        ),
      ),
      body: SizedBox.expand(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text("Add a new exercise",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30
                    )),
                SizedBox(height: 25,),

                Text("Day", style: TextStyle(
                    color: Color(0xff7C8496),
                    fontSize: 15
                ),),
                SizedBox(height: 5,),
                Container(
                  height: 30,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildWeekday('Mon'),
                      SizedBox(width: 5,),
                      _buildWeekday('Tue'),
                      SizedBox(width: 5,),
                      _buildWeekday('Wed'),
                      SizedBox(width: 5,),
                      _buildWeekday('Thu'),
                      SizedBox(width: 5,),
                      _buildWeekday('Fri'),
                      SizedBox(width: 5,),
                      _buildWeekday('Sat'),
                      SizedBox(width: 5,),
                      _buildWeekday('Sun'),
                      SizedBox(width: 5,),
                    ],
                  ),
                ),
                SizedBox(height: 15,),

                Text("Exercise name", style: TextStyle(
                    color: Color(0xff7C8496),
                    fontSize: 15
                ),),
                SizedBox(height: 5,),
                TextField(
                  controller: _exerciseNameController,
                  decoration: InputDecoration(
                    //errorText: _nameValidate ? 'Name Can\'t Be Empty' : null,
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff47C87A))
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff47C87A))
                    ),
                  ),
                ),
                SizedBox(height: 15,),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Number of sets", style: TextStyle(
                        color: Color(0xff7C8496),
                        fontSize: 15
                    ),),
                    Text("Number of reps            ", style: TextStyle(
                        color: Color(0xff7C8496),
                        fontSize: 15
                    ),),
                  ],
                ),
                SizedBox(height: 5,),
                Row(
                  children: [
                    Flexible(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _exerciseSetController,
                        decoration: InputDecoration(
                          //errorText: _nameValidate ? 'Name Can\'t Be Empty' : null,
                          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff47C87A))
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff47C87A))
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 15,),
                    Flexible(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _exerciseRepController,
                        decoration: InputDecoration(
                          //errorText: _nameValidate ? 'Name Can\'t Be Empty' : null,
                          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff47C87A))
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff47C87A))
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15,),

                Text("Seconds", style: TextStyle(
                    color: Color(0xff7C8496),
                    fontSize: 15
                ),),
                SizedBox(height: 5,),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _exerciseSecondsController,
                  decoration: InputDecoration(
                    //errorText: _nameValidate ? 'Name Can\'t Be Empty' : null,
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff47C87A))
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff47C87A))
                    ),
                  ),
                ),
                SizedBox(height: 15,),

                Text("Muscle Group", style: TextStyle(
                    color: Color(0xff7C8496),
                    fontSize: 15
                ),),
                SizedBox(height: 5,),
                Container(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildExerciseType('Shoulders'),
                      SizedBox(width: 10,),
                      _buildExerciseType('Chest'),
                      SizedBox(width: 10,),
                      _buildExerciseType('Back'),
                      SizedBox(width: 10,),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildExerciseType('Arms'),
                      SizedBox(width: 10,),
                      _buildExerciseType('Abdominals'),
                      SizedBox(width: 10,),
                      _buildExerciseType('Legs'),
                      SizedBox(width: 10,),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildExerciseType('Aerobic'),
                      SizedBox(width: 10,),
                      _buildExerciseType('Full Body'),
                    ],
                  ),
                ),

                Expanded( //NEW EXERCISE BUTTON
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: (){
                        saveWorkout();
                      },
                      color: Theme.of(context).accentColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)
                      ),
                      child: Text("Add Exercise", style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18
                      )),
                    ),
                  ),
                ),
                SizedBox(height: 70,)
              ],
            ),
          ),
        ),
      )
    );
  }

  void saveWorkout(){

    String name = _exerciseNameController.text;
    String sets = _exerciseSetController.text;
    String reps = _exerciseRepController.text;
    String seconds = _exerciseSecondsController.text;
    String muscleGroup = _typeSelected;
    String weekday = _weekdaySelected;

    Map<String, String> workout = {
      'name':name,
      'sets':sets,
      'reps':reps,
      'seconds':seconds,
      'muscleGroup':muscleGroup,
      'day':weekday
    };

    _ref.push().set(workout);
    Navigator.pop(context);

  }
}
