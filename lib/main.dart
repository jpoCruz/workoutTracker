import 'package:flutter/material.dart';
import 'package:workout_tracker/login.dart';
import 'package:workout_tracker/signup.dart';
import 'package:workout_tracker/workout.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(){
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Color(0xff39BA6C),
          accentColor:  Color(0xff47C87A),
          scaffoldBackgroundColor: Color(0xff1D1D2A),

          textTheme: const TextTheme(
              bodyText2: TextStyle(
                color: Color(0xffF5F5F5),
                fontWeight: FontWeight.w500,
              )
          ),

        snackBarTheme: SnackBarThemeData(
          actionTextColor: Color(0xff47C87A),
          backgroundColor: Color(0xff2E2D42),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)
          ),
          contentTextStyle: TextStyle(
            color: Color(0xff47C87A),
                fontWeight: FontWeight.w800
          )

        )

      ),
      //home: WorkoutPage(),
      home: HomePage(),
    )
  );
}


class HomePage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: SafeArea(
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget> [
                  Text("Welcome", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30
                  )),
                  SizedBox(height: 20,),
                  Text("Welcome to the Workout Planner app!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff7C8496),
                    fontSize: 15
                  ),)
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/home-illustration.png')
                  )
                ),
              ),
              Column(
                children: <Widget> [
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Theme.of(context).accentColor,
                      ),
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: Text("Login", style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18
                    )),
                  ),

                  SizedBox(height: 20,),

                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
                    },
                    color: Theme.of(context).accentColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)
                    ),
                    child: Text("Sign up", style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18
                    )),
                  )
                ],
              )
            ],
          )
        ),
      ),
    );

  }
}