import 'package:brunelrecycleprototype/pages/loginpage.dart';
import 'package:brunelrecycleprototype/pages/profilepage.dart';
import 'package:brunelrecycleprototype/utlitis/constant.dart';
import 'package:brunelrecycleprototype/widgets/custombutton.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/customsnackbar.dart';
import '../widgets/customtextbutton.dart';
import '../widgets/customtextfield.dart';

class SignUpPage extends StatefulWidget {
  static String id = 'SignUp';
  SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double hight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ProfilePage();
              } else {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                  child: Center(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Center(child: Text('Sign Up', style: TextStyle(fontSize: width * 0.1))),
                        SizedBox(height: hight * 0.02),
                        CustomTextField(title: 'Full Name', controller: fullNameController, obscureText: false),
                        SizedBox(height: hight * 0.02),
                        CustomTextField(title: 'Email Address', controller: emailController, obscureText: false),
                        SizedBox(height: hight * 0.02),
                        CustomTextField(title: 'Password', controller: passwordController, obscureText: true),
                        SizedBox(height: hight * 0.02),
                        CustomTextField(title: 'ConFirm Password', controller: passwordConfirmController, obscureText: true),
                        SizedBox(height: hight * 0.02),
                        CustomButton(
                            width: width,
                            text: 'Signup',
                            onPress: () async {
                              if (emailController.text.trim() == '' || passwordController.text.trim() == '') {
                                showSnackBar(context, 'Please Enter Correct Email/Password');
                              } else if (!EmailValidator.validate(emailController.text)) {
                                showSnackBar(context, 'Email Format is not correct.');
                              } else if (passwordController.text.trim() != passwordConfirmController.text.trim()) {
                                showSnackBar(context, 'Pass doesn\'t matched');
                              } else if (passwordController.text.length < 6) {
                                showSnackBar(context, 'Password must have 6 characters.');
                              } else {
                                try {
                                  UserCredential user = await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim());

                                  if (user.user!.email!.isNotEmpty) {
                                    await FirebaseFirestore.instance.collection('users').doc(user.user?.uid).set({
                                      'fullname': fullNameController.text.trim(),
                                      'email': emailController.text.trim(),
                                      'points': 0,
                                      'imagelocation': '',
                                      'dept': '',
                                      'uni': '',
                                      'materials': {},
                                      'lastPoints': 0,
                                      'lastRecyclingNumber': 0,
                                      'currentPoints': 0,
                                      'currentRecyclingNumber': 0,
                                      'recyclingNumber': 0,
                                      'datetime': DateTime.now(),
                                    }).then((value) {
                                      showSnackBar(context, 'Account Creation Successful');
                                      Navigator.pushNamed(context, LoginPage.id);
                                    });
                                  }
                                } catch (e) {
                                  showSnackBar(context, e.toString());
                                }
                              }
                            }),
                        SizedBox(height: hight * 0.005),
                        Center(
                            child: CustomTextButton(
                                text: 'Already have an account?',
                                onTap: () {
                                  Navigator.pushNamed(context, LoginPage.id);
                                })),
                      ],
                    ),
                  ),
                );
              }
            }));
  }
}
