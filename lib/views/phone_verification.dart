import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_market/components/circular_loading_button.dart';
import 'package:local_market/controller/user_controller.dart';
import 'package:local_market/utils/utils.dart';
import 'package:local_market/views/home.dart';
import 'package:local_market/views/otp.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class PhoneVerification extends StatefulWidget {
  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {

  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _phoneTextController = new TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserController _userController = new UserController();
  final Utils _utils = new Utils();
  String verificationId, smsCode;
  String error = '';
  bool _loading = false;

  @override
  void initState(){
    super.initState();
    setState(() {
      _phoneTextController.text = '91';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _utils.colors['pageBackground'],
      body: Stack(
        children: <Widget>[
          Center(
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.fromLTRB(14, 8, 14, 30),
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: SvgPicture.asset(
                          'assets/svg/phone_verification.svg',
                          color: _utils.colors['theme'],
                          width: 150,
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                    child: Center(
                      child: Text("Verify Your Number",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 35,
                          fontWeight: FontWeight.w900
                        ),
                      )
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 8, 25, 50),
                    child: Center(
                      child: Text("Please enter your phone number to verify your account",
                      textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 20,
                          // fontWeight: FontWeight.w900
                        ),
                      )
                    )
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
                            decoration: InputDecoration(
                                hintText: "Phone Number",
                                icon: Icon(OMIcons.phone),
                                // border: InputBorder.none
                              ),
                            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "This field cannot be empty";
                              } else if (value.length != 12)
                                return "Please enter a valid phone number";
                              else
                                return null;
                            },
                          ),
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
                      child: _loading ? CircularLoadingButton() :  MaterialButton(
                        onPressed: () {
                          validateAndVerify();
                        },
                        minWidth: MediaQuery.of(context).size.width,
                        child: Text(
                          "Send",
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
            ),
          )
        ],
      ),
    );
  }

  Future<void> verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String verId) async {
      this.verificationId = verId;
      dynamic res = await Navigator.push(context, CupertinoPageRoute(builder: (context) => OTP(this.verificationId, "+${_phoneTextController.text}")));

      if(res['error']){
        setState(() {
          _loading = false;
        });
        if(res['data'].code == "ERROR_CREDENTIAL_ALREADY_IN_USE"){
          setState(() {
            error = "This phone is already registered";
            Fluttertoast.showToast(msg: error);
          });
        }
        print("Phone Verification Page1: " + res['data'].toString());
      }else{
        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => Home()));
      }
    };

    final PhoneCodeSent phoneCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
    };

    final PhoneVerificationCompleted phoneVerificationCompleted = (AuthCredential credential) async {
      try{
        FirebaseUser currentUser = await _userController.getCurrentUser();
        await _userController.linkWithCredential(currentUser, credential).then((value){
          _userController.update(currentUser.uid.toString(),{
            "phone" : _phoneTextController.text
          }).then((value){
            Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => Home()));
          }).catchError((e){
            throw e;
          });
        }).catchError((e){
          throw e;
        });
        print("Success");
      }catch(e){
        setState(() {
          _loading = false;
        });
        print("Phone Verification Page2: " + e.toString());
      }
    };

    final PhoneVerificationFailed phoneVerificationFailed = (
        AuthException exception) {
      setState(() {
        _loading = false;
      });
      if(exception.code == "invalidCredential"){
        setState(() {
          error = "Please enter a valid phone number";
          Fluttertoast.showToast(msg: error);
        });
      }
      print("Phone Verification Page3: " + exception.code + " : " + exception.message);
    };

    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: '+'+_phoneTextController.text,
        timeout: const Duration(seconds: 0),
        verificationCompleted: phoneVerificationCompleted,
        verificationFailed: phoneVerificationFailed,
        codeSent: phoneCodeSent,
        codeAutoRetrievalTimeout: autoRetrievalTimeout
    );
  }

  void validateAndVerify() async {
    setState(() {
      _loading = true;
    });
    FormState _formState = _formKey.currentState;
    if(_formState.validate()){
      await verifyPhone().catchError((e){
        setState(() {
          _loading = false;
        });
        print("Phone Verification Page4: " + e.toString());
      });
    }else{
      setState(() {
        _loading = false;
      });
    }
  }

}