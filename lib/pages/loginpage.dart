import 'package:brunelrecycleprototype/pages/forgetpassword.dart';
import 'package:brunelrecycleprototype/pages/leaderboardpage.dart';
import 'package:brunelrecycleprototype/pages/profilepage.dart';
import 'package:brunelrecycleprototype/pages/signup.dart';
import 'package:brunelrecycleprototype/utlitis/constant.dart';
import 'package:brunelrecycleprototype/widgets/custombutton.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/customsnackbar.dart';
import '../widgets/customtextbutton.dart';
import '../widgets/customtextfield.dart';

class LoginPage extends StatefulWidget {
  static String id = 'Login';
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double hight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return LeaderBoardPage();
            } else {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                child: Center(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Center(child: Text('Login', style: TextStyle(fontSize: width * 0.1))),
                      SizedBox(height: hight * 0.08),
                      CustomTextField(title: 'Email Address', controller: emailController, obscureText: false),
                      SizedBox(height: hight * 0.02),
                      CustomTextField(title: 'Password', controller: passwordController, obscureText: true),
                      SizedBox(height: hight * 0.005),
                      CustomTextButton(
                          text: 'Forget Password?',
                          onTap: () {
                            Navigator.pushNamed(context, ForgetPasswordPage.id);
                          }),
                      SizedBox(height: hight * 0.02),
                      CustomButton(
                          width: width,
                          text: 'Login',
                          onPress: () async {
                            if (emailController.text.trim() == '' || passwordController.text.trim() == '') {
                              showSnackBar(context, 'Please Enter Correct Email/Password');
                            } else if (!EmailValidator.validate(emailController.text)) {
                              showSnackBar(context, 'Email Format is not correct.');
                            } else if (passwordController.text.length < 6) {
                              showSnackBar(context, 'Password must have 6 characters.');
                            } else {
                              try {
                                UserCredential user = await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim());
                                if (user.user!.email!.isNotEmpty) {
                                  showSnackBar(context, 'Login Successful');
                                  Navigator.pushNamed(context, LeaderBoardPage.id);
                                }
                              } catch (e) {
                                showSnackBar(context, e.toString());
                              }
                            }
                          }),
                      SizedBox(height: hight * 0.005),
                      Center(
                          child: CustomTextButton(
                              text: 'Don\'t have on account?',
                              onTap: () {
                                Navigator.pushNamed(context, SignUpPage.id);
                              })),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}
