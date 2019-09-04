import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter/gestures.dart';
import 'package:local_market/components/circular_loading_button.dart';
import "package:local_market/controller/user_controller.dart";

import 'home.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _fullNameTextController = new TextEditingController();
  TextEditingController _emailTextController = new TextEditingController();
  TextEditingController _passwordTextController = new TextEditingController();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final UserController userController = new UserController();
  bool hidePassword = true;
  bool _loading = false;
  String error = '';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(),
            child: new Center(
              child: Form(
                key: _formKey,
                child: ListView(
//                  mainAxisAlignment: MainAxisAlignment.center,
                  shrinkWrap: true,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: Image.asset(
                          'assets/img/logo.png',
                          width: 120,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.grey.withOpacity(0.2),
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: TextFormField(
                              controller: _fullNameTextController,
                              autofocus: false,
                              decoration: InputDecoration(
                                  hintText: "Full Name",
                                  icon: Icon(Icons.person_outline),
                                  border: InputBorder.none),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if(value.isEmpty){
                                  return "This field cannot be empty";
                                }else{
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.grey.withOpacity(0.2),
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: TextFormField(
                              controller: _emailTextController,
                              autofocus: false,
                              decoration: InputDecoration(
                                  hintText: "Email",
                                  icon: Icon(Icons.alternate_email),
                                  border: InputBorder.none),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (!value.isEmpty) {
                                  Pattern pattern =
                                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                  RegExp regex = new RegExp(pattern);
                                  if (!regex.hasMatch(value)) {
                                    return "Input valid email address";
                                  } else {
                                    return null;
                                  }
                                }else {
                                  return "This field cannot be empty";
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.grey.withOpacity(0.2),
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: TextFormField(
                              controller: _passwordTextController,
                              obscureText: hidePassword,
                              autofocus: false,
                              decoration: InputDecoration(
                                  hintText: "Password",
                                  icon: Icon(Icons.lock_outline),
                                  border: InputBorder.none),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "This field cannot be empty";
                                } else if (value.length < 6)
                                  return "Should be more than 6 length";
                                else
                                  return null;
                              },
                            ),
                            trailing: IconButton(icon: Icon(Icons.remove_red_eye), onPressed: (){
                              setState(() {
                                hidePassword = !hidePassword;
                              });
                            }),
                          ),
                        ),
                      ),
                    ),


                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(error, style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.w400, fontSize: 14
                          ),),
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.red.withOpacity(0.8),
                        elevation: 0.8,
                        child: _loading ? CircularLoadingButton() :  MaterialButton(
                          onPressed: () {
                            validateForm();
                          },
                          minWidth: MediaQuery.of(context).size.width,
                          child: Text(
                            "Signup",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                                color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 16
                            ),
                            children: [
                              TextSpan(
                                  text:"Already have an account? click here to "
                              ),
                              TextSpan(
                                text: "login!",
                                recognizer: TapGestureRecognizer()..onTap = (){
                                  Navigator.pop(context);
                                },
                                style: TextStyle(color: Colors.red),
                              )
                            ]
                          ),
                        )),
//                    Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: Material(
//                        borderRadius: BorderRadius.circular(20.0),
//                        color: Colors.red.withOpacity(0.8),
//                        elevation: 0.8,
//                        child: MaterialButton(onPressed: (){},
//                          minWidth: MediaQuery.of(context).size.width,
//                          child: Text("Google SignIn", textAlign: TextAlign.center,
//                            style: TextStyle(
//                                color: Colors.white,
//                                fontWeight: FontWeight.bold,
//                                fontSize: 22
//                            ),
//                          ),
//                        ),
//                      ),
//                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void validateForm() async {
    setState(() {
      _loading = true;
    });
    FormState formState = _formKey.currentState;
    if(formState.validate()){
      FirebaseUser user = await userController.getCurrentUser();
      if(user == null){
        firebaseAuth.createUserWithEmailAndPassword(email: _emailTextController.text, password: _passwordTextController.text).then((user){
          Map<String, String> values = {
            "username" : _fullNameTextController.text.toLowerCase(),
            "email" : _emailTextController.text,
            "uid" : user.uid.toString(),
            "vendor" : "false"
          };
          userController.createUser(values);
          formState.reset();
          setState(() {
            _loading = false;
          });
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
        }).catchError((e){
          if(e.code == "ERROR_EMAIL_ALREADY_IN_USE"){
            setState(() {
              _loading = false;
              error = "This email is already registered";
            });
          }
          print('signup page error : ' + e.toString());
        });
      }
    }else{
      setState(() {
        _loading = false;
      });
    }
  }
}
