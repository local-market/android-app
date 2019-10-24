import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_market/components/app_bar.dart';
import 'package:local_market/components/circular_loading_button.dart';
import 'package:local_market/components/page.dart';
import 'package:local_market/controller/user_controller.dart';
import 'package:local_market/utils/utils.dart';
import 'package:local_market/views/login.dart';
import 'package:local_market/views/phone_verification.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:local_market/utils/globals.dart' as globals;

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  TextEditingController _fullNameTextController = new TextEditingController();
  TextEditingController _phoneTextController = new TextEditingController();
  TextEditingController _emailTextController = new TextEditingController();
  TextEditingController _addressTextController = new TextEditingController();
  String _userId;
  final UserController _userController = new UserController();
  final Utils _utils = new Utils();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _pageLoading = true;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    // check();
    // _userController.getCurrentUserDetails().then((userDetails){
      setState(() {
        _pageLoading = false;
        this._userId = globals.currentUser.data['uid'];
        this._fullNameTextController.text = globals.currentUser.data['username'];
        this._emailTextController.text = globals.currentUser.data['email'];
        this._phoneTextController.text = globals.currentUser.data['phone'];
        this._addressTextController.text = globals.currentUser.data['address'];
      });
    // });
  }

  @override
  Widget build(BuildContext context) {
    

    return Page(
      appBar: RegularAppBar(
        iconTheme: IconThemeData(
          color: _utils.colors['appBarIcons']
        ),
        backgroundColor: _utils.colors['appBar'],
        brightness: Brightness.light,
        elevation: _utils.elevation,
        title: Text("My Account",
          style: TextStyle(
            color: _utils.colors['appBarText'],
          ),
        ),
      ),
      children: <Widget>[

         _pageLoading ? PageItem(child:SpinKitCircle(color: _utils.colors['loading'])) : Form(
          key: _formKey,
          child: PageList(
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
                        controller: _fullNameTextController,
                        autofocus: false,
                        decoration: InputDecoration(
                            hintText: "Full Name",
                            icon: Icon(OMIcons.person),
                            // border: InputBorder.none
                          ),
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
                  color: _utils.colors['textFieldBackground'].withOpacity(0.2),
                  // elevation: _utils.elevation,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: TextFormField(
                        controller: _emailTextController,
                        autofocus: false,
                        decoration: InputDecoration(
                            hintText: "Email",
                            icon: Icon(OMIcons.alternateEmail),
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
                  color: _utils.colors['textFieldBackground'],
                  // elevation: _utils.elevation,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: TextFormField(
                        controller: _phoneTextController,
                        autofocus: false,
                        // enabled: false,
                        decoration: InputDecoration(
                          hintText: "Phone Number",
                          icon: Icon(OMIcons.phone),
                          suffixIcon: Chip(
                            backgroundColor: _utils.colors['theme'],
                            label: InkWell(
                              onTap: (){
                                Navigator.push(context, CupertinoPageRoute(builder: (context) => PhoneVerification()));
                              },
                              child: Text(
                                "Change",
                                style: TextStyle(
                                  color: _utils.colors['buttonText'],
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          )
                        ),
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
                  // elevation: _utils.elevation,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: TextFormField(
                        controller: _addressTextController,
                        autofocus: false,
                        decoration: InputDecoration(
                            hintText: "Address",
                            icon: Icon(OMIcons.myLocation),
                            // border: InputBorder.none
                          ),
                        keyboardType: TextInputType.multiline,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 8, 33, 8),
                child: Material(
                  borderRadius: BorderRadius.circular(20.0),
                  color: _utils.colors['theme'],
                  // elevation: _utils.elevation,
                  child: _loading ? CircularLoadingButton() :  MaterialButton(
                    onPressed: () {
                      validateAndUpdate();
                    },
                    minWidth: MediaQuery.of(context).size.width,
                    child: Text(
                      "Update",
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
            ],
          ),
        )
      ],
    );
  }

  // void check() async {
  //   if(!(await _utils.isLoggedIn())){
  //     Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => Login()));
  //   }
  // }

  Future<void> update() async {
    await _userController.update(_userId, {
      "username" : _fullNameTextController.text,
      "email" : _emailTextController.text,
      "address" : _addressTextController.text
    }).then((value){
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => UserProfile()));
      Fluttertoast.showToast(msg: "Profile updated");
    }).catchError((e){
      setState(() {
        _loading = false;
      });
      print("User Profile1: " + e.toString());
    });
  }

  Future<void> validateAndUpdate() async {
    // check();
    FormState _formState = _formKey.currentState;
    if(_formState.validate()){
      setState(() {
        _loading = true;
      });
      FirebaseUser _currentUser = await _userController.getCurrentUser();
      if(_currentUser.email.toString() == _emailTextController.text){
        await update();
      }else{
        await _currentUser.updateEmail(_emailTextController.text).then((value){
          update();
        }).catchError((e){
          setState(() {
            _loading = false;
          });
          if(e.code == 'ERROR_EMAIL_ALREADY_IN_USE'){
            Fluttertoast.showToast(msg: "This email is already registered");
          }else if(e.code == 'ERROR_REQUIRES_RECENT_LOGIN'){
            Fluttertoast.showToast(msg: "Relogin and try again");
          }
          print("User Profile2: " + e.toString());
        });
      }
    }
  }
}