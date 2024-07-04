import 'package:medigaze/Authentication/otpVerification.dart';
import 'package:medigaze/core/app_export.dart';
import 'package:medigaze/widgets/custom_elevated_button.dart';
import 'package:medigaze/widgets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogInOneScreen extends StatefulWidget {
  LogInOneScreen({Key? key}) : super(key: key);

  @override
  _LogInOneScreenState createState() => _LogInOneScreenState();
}

class _LogInOneScreenState extends State<LogInOneScreen> {
  TextEditingController phoneNumberController = TextEditingController();
  bool rememberForDays = false;
  String phoneNumber = '';
  bool flag = false;
  bool isLoading = false;
  FocusNode _focusNode = FocusNode();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: Container(
          width: mediaQueryData.size.width,
          height: mediaQueryData.size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.5, 0),
              end: Alignment(0.5, 1),
              colors: [
                theme.colorScheme.onError,
                appTheme.gray50,
              ],
            ),
          ),
          child: Form(
            key: _formKey,
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.only(
                left: 23.h,
                top: 72.v,
                right: 23.h,
              ),
              child: Column(
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgEllipse12,
                    height: 65.adaptSize,
                    width: 65.adaptSize,
                    radius: BorderRadius.circular(
                      32.h,
                    ),
                  ),
                  SizedBox(height: 27.v),
                  Text(
                    "Log in to your account",
                    style: theme.textTheme.headlineSmall,
                  ),
                  SizedBox(height: 10.v),
                  Text(
                    "Welcome back! Please enter your details.",
                    style: CustomTextStyles.bodyLargeBluegray700,
                  ),
                  SizedBox(height: 33.v),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 3.h),
                      child: Text(
                        "Phone number",
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                  ),
                  SizedBox(height: 7.v),
                  CustomTextFormField(
                    onChanged: (value) {
                      setState(() {
                        phoneNumber = value;
                        if (phoneNumber.length == 10) {
                          flag = true;
                        } else {
                          flag = false;
                        }
                      });
                    },
                    controller: phoneNumberController,
                    focusNode: _focusNode,
                    hintText: "Enter your phone number",
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.phone,
                    readOnly: false,
                  ),
                  SizedBox(height: 24.v),
                  CustomElevatedButton(
                    text: "Log in",
                    buttonStyle: flag == true
                        ? const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.black))
                        : const ButtonStyle(),
                    onPressed: () {
                      _verifyPhoneNumber();
                    },
                  ),
                  if (isLoading) SizedBox(height: 20),
                  if (isLoading)
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  SizedBox(height: 33.v),
                  SizedBox(height: 5.v),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _verifyPhoneNumber() async {
    setState(() {
      isLoading = true; // Set isLoading to true when the button is pressed
    });
    String phoneNumber = '+91' + phoneNumberController.text.trim();

    // Perform phone number validation if needed
    if (phoneNumber.length != 13) {
      // Show an error message or handle the invalid phone number
      print('Invalid phone number. Please enter a 10-digit number.');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid phone number'),
        ),
      );
      return;
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieve the SMS code on Android
        // await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        // Handle verification failed
        print('Verification Failed: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        // Navigate to OTP screen with verificationId
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpOneScreen(
                verificationId: verificationId, phoneNumber: phoneNumber),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle code auto-retrieval timeout
        setState(() {
          isLoading =
              false; // Set isLoading to false when the process is complete
        });
      },
    );
  }
}