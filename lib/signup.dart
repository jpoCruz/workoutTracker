import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:workout_tracker/main.dart';
import 'package:workout_tracker/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'animation/FadeAnimation.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() {
    return _SignupPageState();
  }
}

class _SignupPageState extends State<SignupPage> {

    TextEditingController _nameController = TextEditingController();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    bool _nameValidate = false;
    bool _emailValidate = false;
    bool _passwordValidate = false;


  @override
  Widget build(BuildContext context){
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
                      FadeAnimation(1,
                        Text("Sign up", style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold
                        ),),
                      ),
                      SizedBox(height: 20,),
                      FadeAnimation(1.1,
                        Text("Make a new account",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xff7C8496),
                              fontSize: 15
                          ),),
                      ),
                      SizedBox(height: 70,)
                    ],
                  ),
                  FadeAnimation(1.4,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: <Widget> [
                          makeNameInput(label: "Name", obscureText: false, TextEditingController: _nameController),
                          makeEmailInput(label: "Email", obscureText: false, TextEditingController: _emailController),
                          makePasswordInput(label: "Password", obscureText: true, TextEditingController: _passwordController),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                        child: FadeAnimation(1.6,
                          MaterialButton(
                            minWidth: double.infinity,
                            height: 60,
                            onPressed: () async {
                              final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

                              setState(() {
                                _nameController.text.isEmpty ? _nameValidate = true : _nameValidate = false;
                                _emailController.text.isEmpty ? _emailValidate = true : _emailValidate = false;
                                _passwordController.text.isEmpty ? _passwordValidate = true : _passwordValidate = false;
                              });

                              if(!_nameValidate && !_emailValidate && !_passwordValidate){
                                sharedPreferences.setString('name', _nameController.text);
                                sharedPreferences.setString('email', _emailController.text);
                                sharedPreferences.setString('password', _passwordController.text);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));

                                await Future.delayed(Duration(milliseconds: 500));

                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text("Account created")
                                    ),
                                );

                              }


                            },
                            color: Theme.of(context).accentColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)
                            ),
                            child: Text("Sign up", style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18
                              )),

                          ),
                        )
                    ),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FadeAnimation(1.8,
                        RichText(
                            text: TextSpan(
                              text: "Already have an account?",
                              children: <TextSpan>[
                                TextSpan(
                                  text: " Sign in",
                                  style: TextStyle(fontWeight: FontWeight.w800, color: Theme.of(context).accentColor),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                                    }
                                ) // sign in TextSpan
                              ]
                            )
                        ),
                      )
                    ],
                  ),
                  Row(children: <Widget> [

                  ],)
                ],
              ),

            ],
          ),
        )
    );
  }

  Widget makeNameInput({label, obscureText = false, TextEditingController}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget> [
        Text(label, style: TextStyle(
            color: Color(0xff7C8496),
            fontSize: 15
        ),),
        SizedBox(height: 5,),
        TextField(
          keyboardType: TextInputType.name,
          obscureText: obscureText,
          controller: TextEditingController,
          decoration: InputDecoration(
            errorText: _nameValidate ? 'Name Can\'t Be Empty' : null,
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