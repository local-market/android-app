import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_market/components/app_bar.dart';
import 'package:local_market/components/circular_loading_button.dart';
import 'package:local_market/components/page.dart';
import 'package:local_market/controller/user_controller.dart';
import 'package:local_market/utils/utils.dart';
import 'package:local_market/views/Payment.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class CustomerDetails extends StatefulWidget {
  @override
  _CustomerDetailsState createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {

  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final Utils _utils = new Utils();
  final UserController _userController = new UserController();
  bool _loading = false;
  TextEditingController _fullNameTextController = new TextEditingController();
  TextEditingController _phoneTextController = new TextEditingController();
  TextEditingController _addressTextController = new TextEditingController();
  TextEditingController _landmarkTextController = new TextEditingController();
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
        title: Text("Fill Address",
          style: TextStyle(
            color: _utils.colors['appBarText'],
          ),
        ),
      ),
      children: <Widget>[

        Form(
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
                        ),
                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                        validator: (value){
                          if (value.isEmpty) {
                            return "This field cannot be empty";
                          } else if (value.length != 10)
                            return "Please enter a valid phone number";
                          else
                            return null;
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
                        controller: _addressTextController,
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: "Address",
                          icon: Icon(OMIcons.myLocation),
                          // border: InputBorder.none
                        ),
                        keyboardType: TextInputType.multiline,
                        validator: (value){
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
                        controller: _landmarkTextController,
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: "Land Mark",
                          icon: Icon(OMIcons.myLocation),
                          // border: InputBorder.none
                        ),
                        keyboardType: TextInputType.multiline,
                        validator: (value){
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
                      "Proceed",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _utils.colors['buttonText'],
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
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

  Future<void> validateAndUpdate() async {
    // check();
    FormState _formState = _formKey.currentState;
    if(_formState.validate()){
      setState(() {
        _loading = true;
      });
      // FirebaseUser _currentUser = await _userController.getCurrentUser();
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => Payment(_fullNameTextController.text, _phoneTextController.text, _addressTextController.text, _landmarkTextController.text)));
    }
  }
}
