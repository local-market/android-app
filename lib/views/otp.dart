import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:local_market/controller/user_controller.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

class OTP extends StatefulWidget {

  var _verificationCode;
  String _phoneNumber;

  OTP(verificationCode, phoneNumber){
    this._verificationCode = verificationCode;
    this._phoneNumber = phoneNumber;
  }

  @override
  _OTPState createState() => _OTPState(this._verificationCode, this._phoneNumber);
}

class _OTPState extends State<OTP> {
  String _phoneNumber = '123456789';
  var _verificationCode;
  TextEditingController _pinEditingController = new TextEditingController();
  UserController _userController = new UserController();
  bool _loading = false;
  String _error = '';


  PinDecoration _pinDecoration = UnderlineDecoration(
    textStyle: TextStyle(
      color: Colors.black,
      fontSize: 24
    ),
    enteredColor: Colors.red,
  );


  _OTPState(verificationCode, phoneNumber){
    this._verificationCode = verificationCode;
    this._phoneNumber = phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: _loading ? SpinKitCircle(color: Colors.red) : ListView(
              shrinkWrap: true,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: Text('Verification Code',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w900
                        // color: Colors.  
                      ),
                    )
                  )
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: Text('Please type the verification code sent to ${_phoneNumber}',
                    textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey.shade700  
                      ),
                    )
                  )
                ),
                
                Padding(
                  padding: const EdgeInsets.all(50),
                  child: PinInputTextField(
                    pinLength: 6,
                    decoration: _pinDecoration,
                    controller: _pinEditingController,
                    autoFocus: true,
                    textInputAction: TextInputAction.go,
                    onSubmit: (pin) {
                      if(pin.length == 6) verify(pin);
                      print(pin);
                      // verify(pin);
                    },
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(_error, style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.w400, fontSize: 14
                      ),),
                    )
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> verify(String pin) async {
    setState(() {
      _loading = true;
    });
    // print('verify');
    try{
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: _verificationCode,
        smsCode: pin
      );
      FirebaseUser currentUser = await _userController.getCurrentUser();
      await _userController.linkWithCredential(currentUser, credential).then((value){
        _userController.update(currentUser.uid.toString(),{
          "phone" : _phoneNumber
        }).then((value){
          Navigator.pop(context, {"error": false});
        }).catchError((e){
          throw e;
        });
      }).catchError((e){
        throw e;
      });
    }catch(e){
      setState(() {
        _loading = false;
      });
      print("OTP Page: " + e.toString());
      if(e.code == "ERROR_INVALID_VERIFICATION_CODE"){
        setState(() {
          _error = "Verification code is invalid";
        });
      }else{
        Navigator.pop(context, {"error": true, "data" : e});
      }
    }
  }
}