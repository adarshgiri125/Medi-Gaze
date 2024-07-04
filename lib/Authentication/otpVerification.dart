

import 'package:medigaze/Authentication/login.dart';
import 'package:medigaze/HomePage/home.dart';
import 'package:medigaze/core/utils/image_constant.dart';
import 'package:medigaze/core/utils/size_utils.dart';
import 'package:medigaze/theme/custom_text_style.dart';
import 'package:medigaze/theme/theme_helper.dart';
import 'package:medigaze/widgets/custom_elevated_button.dart';
import 'package:medigaze/widgets/custom_image_view.dart';
import 'package:medigaze/widgets/custom_pin_code_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class OtpOneScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  OtpOneScreen(
      {Key? key, required this.verificationId, required this.phoneNumber})
      : super(key: key);

  @override
  _OtpOneScreenState createState() => _OtpOneScreenState();
}

class _OtpOneScreenState extends State<OtpOneScreen> {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  final TextEditingController otpController = TextEditingController();
  bool flag = false;
  String otp = '';
  String? deviceToken = '';
  bool isLoading = false;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    setupDeviceToken();
    // auth.authStateChanges().listen((User? user) {
    //   if (user != null) {
    //     // saveLoginInfo(user as String);
    //     _addUserToFirestore();
    //     navigateToHomeScreen();
    //   }
    // });
  }

  // void navigateToHomeScreen() {
  //   Navigator.pushAndRemoveUntil(
  //     context,
  //     MaterialPageRoute(builder: (context) => HomePageScreen()),
  //     (route) => false,
  //   );
  // }

  Future<void> setupDeviceToken() async {
    try {
      deviceToken = await _messaging.getToken();
    } catch (e) {
      print('Firebase initialization error: $e');
    }
  }

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
                appTheme.gray5001,
              ],
            ),
          ),
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.only(
              left: 24.h,
              top: 61.v,
              right: 24.h,
            ),
            child: Column(
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgImage69,
                  height: 172.adaptSize,
                  width: 172.adaptSize,
                ),
                SizedBox(height: 24.v),
                Text(
                  "OTP Verification",
                  style: theme.textTheme.headlineSmall,
                ),
                SizedBox(height: 10.v),
                SizedBox(
                  width: 226.h,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "We sent a verification ",
                          style: CustomTextStyles.bodyLargeInterBluegray700,
                        ),
                        TextSpan(
                          text: "code",
                          style: CustomTextStyles.bodyLargeInterBluegray700,
                        ),
                        TextSpan(
                          text: " to ",
                          style: CustomTextStyles.bodyLargeInterBluegray700,
                        ),
                        TextSpan(
                          text: widget.phoneNumber,
                          style: CustomTextStyles.titleMediumInterBluegray700,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 30.v),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 51.h),
                  child: CustomPinCodeTextField(
                    context: context,
                    onChanged: (value) {
                      setState(() {
                        // Enable the button only when the PIN is 6 digits long
                        if (value.length == 6) {
                          flag = true;
                        } else {
                          flag = false;
                        }
                      });
                    },
                    controller: otpController,
                  ),
                ),
                SizedBox(height: 24.v),
                isLoading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ) // Show circular progress bar when loading
                    : CustomElevatedButton(
                        text: "Verify",
                        buttonStyle: flag == true
                            ? ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.black),
                              )
                            : ButtonStyle(),
                        onPressed: otpController.text.length == 6 && !isLoading
                            ? () {
                                _verifyOtp(context, otpController.text);
                              }
                            : null,
                      ),
                SizedBox(height: 33.v),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn’t receive the code?",
                      style: CustomTextStyles.bodyMediumInterBluegray700,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 4.h),
                      child: TextButton(
                        onPressed: () {
                          _resend();
                        },
                        child: Text(
                          "Click to resend",
                          style: theme.textTheme.titleSmall,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 33.v),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.imgArrowLeft,
                      height: 20.adaptSize,
                      width: 20.adaptSize,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 8.0,
                        top: 2.0,
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LogInOneScreen()),
                            (route) =>
                                false, // Removes all routes from the stack
                          );
                        },
                        child: Text(
                          "Back to log in",
                          style: CustomTextStyles.titleMediumBlack900,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.v),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _verifyOtp(BuildContext context, String enteredOtp) async {
    setState(() {
      isLoading = true; // Set loading to true when OTP verification starts
    });
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: enteredOtp,
      );

      UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Obtain the user token
      String? userToken = await authResult.user?.getIdToken();

      if (userToken != null) {
        // Save login information
        saveLoginInfo(userToken);

        // Add user details to Firestore
        await _addUserToFirestore();

        // Navigate to the home page or any other screen upon successful verification
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (route) => false, // Removes all routes from the stack
        );
      } else {
        // Handle the case where userToken is null
        print('User token is null');
      }
    } catch (e) {
      // Handle verification failure
      print('Verification failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Incorrect OTP'),
      ));
      // You can show an error message to the user if needed
    } finally {
      setState(() {
        isLoading =
            false; // Set loading to false when OTP verification is complete
      });
    }
  }

  void saveLoginInfo(String userToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Replace these lines with the actual token and expiration date from your server
    DateTime expirationDate = DateTime.now().add(Duration(days: 30));

    // Save token and expiration date
    await prefs.setString('user_token', userToken);
    await prefs.setString('expiration_date', expirationDate.toIso8601String());
  }

  bool isResending = false; // Track whether the code is currently being resent

  void _resend() async {
    if (isResending) {
      // Avoid multiple resend requests
      return;
    }

    setState(() {
      isResending = true;
    });

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-retrieve the SMS code on Android
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          // Handle verification failed
          print('Verification Failed: ${e.message}');
          // Display an error message to the user
        },
        codeSent: (String verificationId, int? resendToken) {
          // Navigate to OTP screen with verificationId
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OtpOneScreen(
                  verificationId: verificationId,
                  phoneNumber: widget.phoneNumber),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Handle code auto-retrieval timeout
          setState(() {
            isResending = false;
          });
        },
      );
    } catch (e) {
      print('Error during resending: $e');
      // Display an error message to the user
      setState(() {
        isResending = false;
      });
    }
  }

  Future<void> _addUserToFirestore() async {
    // Get a reference to the "customers" collection in Firestore
    CollectionReference customers =
        FirebaseFirestore.instance.collection('customers');

    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Add user details to Firestore
      await customers.doc(user.uid).set({
        'phone_number': widget.phoneNumber,
        'user_id': user.uid,
        'device_token': deviceToken, // Replace with the actual device token
      });
    }
  }
}
