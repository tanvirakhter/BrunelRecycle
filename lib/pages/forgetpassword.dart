import 'package:brunelrecycleprototype/pages/loginpage.dart';
import 'package:brunelrecycleprototype/pages/signup.dart';
import 'package:brunelrecycleprototype/utlitis/constant.dart';
import 'package:brunelrecycleprototype/widgets/custombutton.dart';
import 'package:brunelrecycleprototype/widgets/customsnackbar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/customtextbutton.dart';
import '../widgets/customtextfield.dart';

class ForgetPasswordPage extends StatefulWidget {
  static String id = 'ForgotPassword';
  ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double hight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: width * 0.1),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Center(child: Text('Login', style: TextStyle(fontSize: width * 0.1))),
              SizedBox(height: hight * 0.08),
              CustomTextField(title: 'Email Address', controller: emailController, obscureText: false),
              SizedBox(height: hight * 0.02),
              CustomButton(
                  width: width,
                  text: 'Reset',
                  onPress: () async {
                    if (emailController.text.trim() != '') {
                      if (EmailValidator.validate(emailController.text.trim())) {
                        try {
                          await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim()).then((value) {
                            showSnackBar(context, 'Reset Email Sent');
                            Navigator.pushNamed(context, LoginPage.id);
                          });
                        } catch (e) {
                          showSnackBar(context, e.toString());
                        }
                      } else {
                        showSnackBar(context, 'Please Enter Correct Email');
                      }
                    } else {
                      showSnackBar(context, 'Please Enter Email');
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
      ),
    );
  }
}
