import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:workout_tracker/main.dart';
import 'package:workout_tracker/signup.dart';
import 'package:workout_tracker/workout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

  class _LoginPageState extends State<LoginPage> {

      TextEditingController _emailController = TextEditingController();
      TextEditingController _passwordController = TextEditingController();

      bool _emailValidate = false;
      bool _passwordValidate = false;

      @override
      Widget build(BuildContext context){
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            leading: IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
              },
              icon: Icon(Icons.keyboard_arrow_left, color: Color(0xff7C8496))
            ),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget> [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: <Widget> [
                        Text("Sign in", style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold
                        ),),
                        SizedBox(height: 20,),
                        Text("Login to your account",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xff7C8496),
                              fontSize: 15
                          ),),
                        SizedBox(height: 70,)
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: <Widget> [
                          makeEmailInput(label: "Email", obscureText: false, TextEditingController: _emailController),
                          makePasswordInput(label: "Password", obscureText: true, TextEditingController: _passwordController),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () async {
                            final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

                            setState(() {
                              _emailController.text.isEmpty ? _emailValidate = true : _emailValidate = false;
                              _passwordController.text.isEmpty ? _passwordValidate = true : _passwordValidate = false;
                            });

                            String email = sharedPreferences.getString('email');
                            String password = sharedPreferences.getString('password');
                            if((_emailController.text == email) && (_passwordController.text == password)){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WorkoutPage()));
                            }


                          },
                          color: Theme.of(context).accentColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)
                          ),
                          child: Text("Login", style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18
                          )),
                        )
                      ),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RichText(
                            text: TextSpan(
                                text: "Don't have an account?",
                                children: <TextSpan>[
                                  TextSpan(
                                      text: " Sign up",
                                      style: TextStyle(fontWeight: FontWeight.w800, color: Theme.of(context).accentColor),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
                                        }
                                  ) // sign in TextSpan
                                ]
                            )
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 40),
                        RichText(
                            text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "Forgot your password?",
                                      style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xff47C87A)),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async{
                                          final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                          sharedPreferences.clear();

                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                                content: Text("Account info reset")
                                            ),
                                          );

                                        }
                                  ) // sign in TextSpan
                                ]
                            )
                        )
                      ],
                    )
                  ],
                ),

              ],
            ),
          )
        );
      }

      Widget makeEmailInput({label, obscureText = false, TextEditingController}) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
            Text(label, style: TextStyle(
                color: Color(0xff7C8496),
                fontSize: 15
            ),),

            SizedBox(height: 5,),

            TextField(
              keyboardType: TextInputType.emailAddress,
              obscureText: obscureText,
              controller: TextEditingController,
              decoration: InputDecoration(
                errorText: _emailValidate ? 'Email Can\'t Be Empty' : null,
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff47C87A))
                ),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff47C87A))
                ),
              ),
            ),
            SizedBox(height: 30,),
          ],
        );
      }

      Widget makePasswordInput({label, obscureText = false, TextEditingController}) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
            Text(label, style: TextStyle(
                color: Color(0xff7C8496),
                fontSize: 15
            ),),

            SizedBox(height: 5,),

            TextField(
              obscureText: obscureText,
              controller: TextEditingController,
              decoration: InputDecoration(
                errorText: _passwordValidate ? 'Password Can\'t Be Empty' : null,
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff47C87A))
                ),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff47C87A))
                ),
              ),
            ),
            SizedBox(height: 30,),
          ],
        );
      }

    }