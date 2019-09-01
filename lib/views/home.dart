import "package:flutter/material.dart";
import "package:local_market/controller/user_controller.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:local_market/views/login.dart";

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  UserController userController = new UserController();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Material(
          color: Colors.red,
          child: MaterialButton(onPressed: (){
            userController.logout();
          }, child: Text("Logout", style: TextStyle(
            color:Colors.white,
          ),)),
        ),
      ),
    );
  }

  @override
  void initState(){
    ifNotLoggedIn();
  }

  void ifNotLoggedIn() async{
    FirebaseUser user = await firebaseAuth.currentUser();
    if(user == null){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
    }
  }
}
