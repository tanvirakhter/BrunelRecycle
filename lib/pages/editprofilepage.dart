import 'dart:io';
import 'dart:math';

import 'package:brunelrecycleprototype/widgets/custombutton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../utlitis/constant.dart';
import '../widgets/custombottomnavigatiorbar.dart';
import '../widgets/customsnackbar.dart';

class EditProfilePage extends StatefulWidget {
  static String id = 'EditProfilePage';
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  Reference storageRef = FirebaseStorage.instance.ref();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController uniController = TextEditingController();
  TextEditingController deptController = TextEditingController();
  String tempName = '';
  String tempUni = '';
  String tempDept = '';
  String profileImage = '';
  PickedFile? itemPicturePicket;
  bool imgupdated = false;
  String uid = '';
  @override
  void initState() {
    // TODO: implement initState
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double hight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: CustomBottomNavigatiorBar(indexPage: 4),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Edit Profile', style: TextStyle(fontSize: 20, color: kBlackColor, fontWeight: FontWeight.w600)),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Image.asset('assets/icons/BackArrow.png')),
                ],
              ),
              SizedBox(height: hight * 0.02),
              Stack(
                alignment: Alignment.center,
                children: [
                  itemPicturePicket != null
                      ? CircleAvatar(
                          radius: width * 0.2,
                          backgroundColor: kSecondaryColor,
                          backgroundImage: FileImage(File(itemPicturePicket!.path)),
                        )
                      : profileImage != ''
                          ? CircleAvatar(
                              radius: width * 0.2,
                              backgroundColor: kSecondaryColor,
                              backgroundImage: NetworkImage(profileImage),
                            )
                          : CircleAvatar(
                              radius: width * 0.2,
                              backgroundColor: kSecondaryColor,
                              child: Text('Image Not Found'),
                            ),
                  Positioned(
                    bottom: 0,
                    left: width * 0.45,
                    child: GestureDetector(
                      onTap: () async {
                        itemPicturePicket = (await ImagePicker.platform.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 10,
                          maxHeight: 600,
                          maxWidth: 400,
                        ));
                        itemPicturePicket!.path != '' ? imgupdated = true : imgupdated = false;
                        setState(() {});
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: kGreyColor.withOpacity(0.4),
                        child: Image.asset('assets/icons/edit.png'),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: hight * 0.05),
              CustomProfileField(title: 'Full Name', numberTextEditingController: fullNameController),
              SizedBox(height: hight * 0.02),
              CustomProfileField(title: 'University Name', numberTextEditingController: uniController),
              SizedBox(height: hight * 0.02),
              CustomProfileField(title: 'Department Name', numberTextEditingController: deptController),
              SizedBox(height: hight * 0.05),
              CustomButton(
                  width: width,
                  text: 'UPDATE',
                  btnradius: 10,
                  onPress: () async {
                    try {
                      if (itemPicturePicket != null) {
                        await uploadPic().then((value) {
                          FirebaseFirestore.instance.collection('users').doc(uid).update({
                            'fullname': fullNameController.text.trim(),
                            'dept': deptController.text.trim(),
                            'uni': uniController.text.trim(),
                            'imagelocation': profileImage,
                            'datetime': DateTime.now(),
                          }).then((value) {
                            showSnackBar(context, 'Profile Updated');
                            Navigator.pop(context);
                          });
                        });
                      } else if (tempName != fullNameController.text.trim() ||
                          tempDept != deptController.text.trim() ||
                          tempUni != uniController.text.trim()) {
                        FirebaseFirestore.instance.collection('users').doc(uid).update({
                          'fullname': fullNameController.text.trim(),
                          'dept': deptController.text.trim(),
                          'uni': uniController.text.trim(),
                          'datetime': DateTime.now(),
                        }).then((value) {
                          showSnackBar(context, 'Profile Updated');
                          Navigator.pop(context);
                        });
                      } else {
                        showSnackBar(context, 'Please Update something');
                      }
                    } catch (e) {
                      showSnackBar(context, e.toString());
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> uploadPic() async {
    //Create a reference to the location you want to upload to in firebase
    final itemImageRef = storageRef.child("users/profile/${fullNameController.text.trim()}_${DateTime.now()}");

    //Upload the file to firebase
    final TaskSnapshot snapshot = await itemImageRef.putFile(File(itemPicturePicket!.path));

    // Waits till the file is uploaded then stores the download url
    profileImage = await snapshot.ref.getDownloadURL();

    return profileImage;
  }

  void loadData() async {
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
      fullNameController.text = value.get('fullname');
      uniController.text = value.get('uni');
      deptController.text = value.get('dept');
      profileImage = value.get('imagelocation');
      uid = value.id;
      tempName = value.get('fullname');
      tempUni = value.get('uni');
      tempDept = value.get('dept');
      setState(() {});
      return value;
    });
  }
}

class CustomProfileField extends StatelessWidget {
  const CustomProfileField({
    super.key,
    required this.numberTextEditingController,
    required this.title,
  });

  final TextEditingController numberTextEditingController;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(color: kOffWhite, border: Border.all(color: kGreyColor), borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(color: kGreyColor, fontSize: 10),
          ),
          SizedBox(
            height: 30,
            child: TextField(
              controller: numberTextEditingController,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          )
        ],
      ),
    );
  }
}
