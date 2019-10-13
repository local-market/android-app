import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import "package:flutter/gestures.dart";
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_market/components/circular_loading_button.dart';
import 'package:local_market/utils/utils.dart';
import "package:local_market/views/signup.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:local_market/views/home.dart";
import 'package:outline_material_icons/outline_material_icons.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}


class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _OldPasswordTextController = new TextEditingController();
  TextEditingController _passwordTextController = new TextEditingController();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final Utils _utils = new Utils();
  String error = "";
  bool hidePassword1 = true;
  bool hidePassword2 = true;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: _utils.colors['appBarIcons']
        ),
        backgroundColor: _utils.colors['appBar'],
        brightness: Brightness.light,
        elevation: 0,
      ),
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
                      padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        color: _utils.colors['textFieldBackground'].withOpacity(0.2),
                        // elevation: _utils.elevation,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: TextFormField(
                              controller: _OldPasswordTextController,
                              obscureText: hidePassword1,
                              autofocus: false,
                              decoration: InputDecoration(
                                  hintText: "Current Password",
                                  icon: Icon(OMIcons.lock),
                                    suffixIcon: IconButton(icon: Icon(OMIcons.removeRedEye), onPressed: (){
                                      setState(() {
                                        hidePassword1 = !hidePassword1;
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

                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        color: _utils.colors['textFieldBackground'].withOpacity(0.2),
                        // elevation: _utils.elevation,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: TextFormField(
                              controller: _passwordTextController,
                              obscureText: hidePassword2,
                              autofocus: false,
                              decoration: InputDecoration(
                                  hintText: "New Password",
                                  icon: Icon(OMIcons.lock),
                                    suffixIcon: IconButton(icon: Icon(OMIcons.removeRedEye), onPressed: (){
                                      setState(() {
                                        hidePassword2 = !hidePassword2;
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
                        color: _utils.colors['theme'],
                        // elevation: _utils.elevation,
                        child: _loading ? CircularLoadingButton() : MaterialButton(
                          onPressed: () {
                            validateForm();
                          },
                          
                          minWidth: MediaQuery.of(context).size.width,
                          child: Text(
                            "ChangePassword",
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
                                text:"Forgot password "
                              ),
                              TextSpan(
                                text: "-->",
                                recognizer: TapGestureRecognizer()..onTap = (){
                                  Navigator.push(context, CupertinoPageRoute(builder: (context) => Signup()));
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
          email: _OldPasswordTextController.text,
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
              Navigator.pop(context);
              Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => Home()));
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
        }else if(e.code == "ERROR_WRONG_PASSWORD"){
          setState(() {
            error = "Invalid email or password";
            Fluttertoast.showToast(msg: error);
          });
        }
        print("Error: ChangePassword page: " + e.toString());
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

    /// must be enabled
    // check();
  }

  void check() async {
    if((await _utils.isLoggedIn())){
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => Home()));
    }
  }
}
