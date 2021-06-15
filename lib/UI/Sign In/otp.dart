import 'package:am_debug/UI/Dashboard/DashboardScreen.dart';
import 'package:am_debug/UI/Registration/UserInformation.dart';
import 'package:am_debug/helpers/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pin_put/pin_put.dart';

class OTPScreen extends StatefulWidget {
  final String phone;
  OTPScreen(this.phone);
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String _verificationCode = "";
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color(0xFFd8d8d8),
    borderRadius: BorderRadius.circular(10.0),
  );

  @override
  void initState() {
    super.initState();
    _verifyPhone();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
        body: SafeArea(
          child: Container(
            color: Colors.black,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Positioned(
                    width: MediaQuery.of(context).size.width,
                    child:
                        Container(child: Lottie.asset('Assets/BG (1).json'))),
                Positioned(
                  top: 50,
                  left: 30,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Verification",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w900),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text("Enter the code that we just sent to:",
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                        Text("${widget.phone}",
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  top: MediaQuery.of(context).size.height * 0.4,
                  child: Container(
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(20.0),
                          topRight: const Radius.circular(20.0),
                        )),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 40),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: PinPut(
                            fieldsCount: 6,
                            textStyle: const TextStyle(
                                fontSize: 25.0, color: Colors.black),
                            eachFieldWidth: 30.0,
                            eachFieldHeight: 50.0,
                            focusNode: _pinPutFocusNode,
                            controller: _pinPutController,
                            submittedFieldDecoration: pinPutDecoration,
                            selectedFieldDecoration: pinPutDecoration,
                            followingFieldDecoration: pinPutDecoration,
                            pinAnimationType: PinAnimationType.fade,
                            onSubmit: (pin) async {
                              try {
                                await FirebaseAuth.instance
                                    .signInWithCredential(
                                        PhoneAuthProvider.credential(
                                            verificationId: _verificationCode,
                                            smsCode: pin))
                                    .then((value) async {
                                  if (value.user != null) {
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(FirebaseAuth
                                            .instance.currentUser.uid)
                                        .get()
                                        .then((DocumentSnapshot
                                            documentSnapshot) {
                                      if (documentSnapshot.exists) {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DashboardScreen()),
                                            (route) => false);
                                        Constants.phoneno =
                                            widget.phone.toString();
                                      } else {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UserInformation(
                                                      phone: widget.phone,
                                                    )),
                                            (route) => false);
                                        Constants.phoneno =
                                            widget.phone.toString();
                                      }
                                    });
                                  }
                                });
                              } catch (e) {
                                FocusScope.of(context).unfocus();
                                _scaffoldkey.currentState.showSnackBar(
                                    SnackBar(content: Text('invalid OTP')));
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: [
                              TextSpan(
                                  text: "Didn't recieve the code? ",
                                  style: TextStyle(
                                    color: Colors.black54,
                                  )),
                              TextSpan(
                                  text: " Resend ",
                                  style: TextStyle(
                                      color: Colors.black54,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold)),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  // Column(
  //       children: [
  //         Container(
  //           margin: EdgeInsets.only(top: 40),
  //           child: Center(
  //             child: Text(
  //               'Verify +91-${widget.phone}',
  //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
  //             ),
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(30.0),
  //           child: PinPut(
  //             fieldsCount: 6,
  //             textStyle: const TextStyle(fontSize: 25.0, color: Colors.white),
  //             eachFieldWidth: 40.0,
  //             eachFieldHeight: 55.0,
  //             focusNode: _pinPutFocusNode,
  //             controller: _pinPutController,
  //             submittedFieldDecoration: pinPutDecoration,
  //             selectedFieldDecoration: pinPutDecoration,
  //             followingFieldDecoration: pinPutDecoration,
  //             pinAnimationType: PinAnimationType.fade,
  //             onSubmit: (pin) async {
  //               try {
  //                 await FirebaseAuth.instance
  //                     .signInWithCredential(PhoneAuthProvider.credential(
  //                         verificationId: _verificationCode, smsCode: pin))
  //                     .then((value) async {
  //                   if (value.user != null) {
  //                     FirebaseFirestore.instance
  //                         .collection('users')
  //                         .doc(FirebaseAuth.instance.currentUser.uid)
  //                         .get()
  //                         .then((DocumentSnapshot documentSnapshot) {
  //                       if (documentSnapshot.exists) {
  //                         Navigator.pushAndRemoveUntil(
  //                             context,
  //                             MaterialPageRoute(
  //                                 builder: (context) => DashboardScreen()),
  //                             (route) => false);
  //                       } else {
  //                         Navigator.pushAndRemoveUntil(
  //                             context,
  //                             MaterialPageRoute(
  //                                 builder: (context) => UserInformation()),
  //                             (route) => false);
  //                       }
  //                     });
  //                   }
  //                 });
  //               } catch (e) {
  //                 FocusScope.of(context).unfocus();
  //                 _scaffoldkey.currentState
  //                     .showSnackBar(SnackBar(content: Text('invalid OTP')));
  //               }
  //             },
  //           ),
  //         )
  //       ],
  //     ),

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser.uid)
                  .get()
                  .then((DocumentSnapshot documentSnapshot) {
                if (documentSnapshot.exists) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DashboardScreen()),
                      (route) => false);
                  Constants.phoneno = widget.phone.toString();
                } else {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserInformation(
                                phone: widget.phone,
                              )),
                      (route) => false);
                  Constants.phoneno = widget.phone.toString();
                }
              });
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verficationID, int resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          // setState(() {
          //   _verificationCode = verificationID;
          // });
        },
        timeout: Duration(seconds: 120));
  }
}
