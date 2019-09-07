import "package:flutter/material.dart";
import "package:flutter/gestures.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_market/components/circular_loading_button.dart';
import 'package:local_market/utils/utils.dart';
import "package:local_market/views/signup.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:local_market/views/home.dart";

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}


class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailTextController = new TextEditingController();
  TextEditingController _passwordTextController = new TextEditingController();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final Utils _utils = new Utils();
  String error = "";
  bool hidePassword = true;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: _utils.colors['pageBackground'],
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
                      padding: const EdgeInsets.fromLTRB(14, 8, 14, 30),
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: Image.asset(
                          'assets/illustrations/login.png',
                          width: 150,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        color: _utils.colors['textFieldBackground'].withOpacity(0.2),
                        elevation: _utils.elevation,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: TextFormField(
                              controller: _emailTextController,
                              autofocus: false,
                              decoration: InputDecoration(
                                  hintText: "Email",
                                  icon: Icon(Icons.alternate_email),
                                  // border: InputBorder.none
                                ),
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
                                }else{
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
                        color: _utils.colors['textFieldBackground'].withOpacity(0.2),
                        elevation: _utils.elevation,
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
                                    suffixIcon: IconButton(icon: Icon(Icons.remove_red_eye), onPressed: (){
                                      setState(() {
                                        hidePassword = !hidePassword;
                                      });
                                    }),
                                  // border: InputBorder.none
                                  ),
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
                            // trailing: 
                          ),
                        ),
                      ),
                    ),

                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Center(
                    //     child: Text(error, style: TextStyle(
                    //         color: _utils.colors['error'], fontWeight: FontWeight.w400, fontSize: 14
                    //     ),),
                    //   )
                    // ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 8, 33, 8),
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        color: _utils.colors['theme'].withOpacity(0.8),
                        elevation: _utils.elevation,
                        child: _loading ? CircularLoadingButton() : MaterialButton(
                          onPressed: () {
                            validateForm();
                          },
                          
                          minWidth: MediaQuery.of(context).size.width,
                          child: Text(
                            "Login",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _utils.colors['buttonText'],
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
                                text:"Don't have an account? click here to "
                              ),
                              TextSpan(
                                text: "sign up!",
                                recognizer: TapGestureRecognizer()..onTap = (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Signup()));
                                },
                                style: TextStyle(color: _utils.colors['theme']),
                              )
                            ]
                          ),
                        )
                      ),
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
    FormState _formState = _formKey.currentState;
    if(_formState.validate()){
      await firebaseAuth.signInWithEmailAndPassword(
          email: _emailTextController.text,
          password: _passwordTextController.text).then((user){
            if(user == null){
              // print("Hello World");
              setState(() {
                _loading = false;
                error = "Invalid email or password";
                Fluttertoast.showToast(msg: error);
              });
            }else{
              setState(() {
                _loading = false;
              });
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
            }
      }).catchError((e){
        setState(() {
          _loading = false;
        });
        if(e.code == "ERROR_USER_NOT_FOUND"){
          setState(() {
            error = "Invalid email or password";
            Fluttertoast.showToast(msg: error);
          });
        }
        print("Error: login page: " + e.toString());
      });
    }else{
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    check();
  }

  void check() async {
    if((await _utils.isLoggedIn())){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
    }
  }
}
