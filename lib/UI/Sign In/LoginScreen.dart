import 'package:am_debug/UI/AppStartAnimation.dart';
import 'package:am_debug/helpers/constants.dart';
import 'package:am_debug/helpers/utils.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'otp.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String countryCode = "+91";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.5,
                        color: Colors.white,
                        child: Image.asset(
                          'Assets/onboarding.gif',
                          fit: BoxFit.cover,
                        )),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      child: Center(
                        child: Column(
                          children: [
                            largeText('Airmatch connects you with other',
                                Constants.blueClr),
                            largeText('passengers travelling with you',
                                Constants.blueClr),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 45,
                    ),
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 30 / 100,
                          padding: EdgeInsets.only(bottom: 10),
                          child: CountryCodePicker(
                            onChanged: (value) {
                              countryCode = value.toString();
                              print(countryCode);
                            },
                            initialSelection: '+91',
                            favorite: ['+91'],
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: false,
                            alignLeft: true,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 60 / 100,
                          child: TextFormField(
                            textInputAction: TextInputAction.go,
                            validator: (String value) {
                              if (value.length < 10)
                                return 'Enter valid No.';
                              else
                                return null;
                            },
                            onFieldSubmitted: (value) {
                              if (_formKey.currentState.validate()) {
                                String phno =
                                    countryCode + _controller.text.toString();
                                print(phno);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => OTPScreen(phno),
                                    settings:
                                        RouteSettings(name: 'OTP Screen')));
                              }
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10)),
                              filled: true,
                              hintText: 'Enter Phone Number',
                            ),
                            maxLength: 10,
                            keyboardType: TextInputType.number,
                            controller: _controller,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Text(
                          "By entering your phone number, you agree with our ",
                          style: TextStyle(color: Colors.black54)),
                    ),
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: "Terms of service",
                              style: TextStyle(
                                  color: Colors.black54,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: " and ",
                              style: TextStyle(color: Colors.black54)),
                          TextSpan(
                              text: "Privacy policy",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold)),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
