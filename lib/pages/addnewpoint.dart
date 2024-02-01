import 'package:brunelrecycleprototype/utlitis/constant.dart';
import 'package:brunelrecycleprototype/widgets/custombutton.dart';
import 'package:brunelrecycleprototype/widgets/customsnackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../widgets/custombottomnavigatiorbar.dart';

class AddNewPoint extends StatefulWidget {
  static String id = 'AddNewPoint';

  const AddNewPoint({Key? key}) : super(key: key);

  @override
  State<AddNewPoint> createState() => _AddNewPointState();
}

class _AddNewPointState extends State<AddNewPoint> {
  List<String> materialItems = [];
  List<int> materialPointsList = [];
  RegExp numericRegex = RegExp(r'^-?[0-9]+$');
  String materialSelectedValue = '';
  String? typeSelectedValue;
  int materialPoints = 0;
  Map userMaterials = {};
  int currentRecyclingNumber = 0;
  int currentPoints = 0;
  int lastRecyclingNumber = 0;
  int lastPoints = 0;
  int recyclingNumber = 0;
  int userPoints = 0;
  String uid = '';
  final TextEditingController materialTextEditingController = TextEditingController();
  final TextEditingController typeTextEditingController = TextEditingController();
  final TextEditingController numberTextEditingController = TextEditingController();
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
        bottomNavigationBar: CustomBottomNavigatiorBar(indexPage: 3),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Add Points', style: TextStyle(fontSize: 20, color: kBlackColor, fontWeight: FontWeight.w600)),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Image.asset('assets/icons/BackArrow.png')),
                ],
              ),
              SizedBox(height: hight * 0.03),
              materialItems.length > 0
                  ? Column(
                      children: [
                        CustomDropDown(
                          title: 'Material Name',
                          items: materialItems,
                          selectedValue: materialSelectedValue ?? '',
                          textEditingController: materialTextEditingController,
                          onChange: (value) {
                            setState(() {
                              materialSelectedValue = value as String;
                              materialPoints = materialPointsList[materialItems.indexOf(materialSelectedValue ?? materialItems[0])];
                            });
                          },
                        ),
                        SizedBox(height: hight * 0.03),
                        CustomPointsField(
                          title: 'Material Point',
                          point: materialPoints,
                        ),
                        SizedBox(height: hight * 0.03),
                        CustomNumberField(title: 'Number', numberTextEditingController: numberTextEditingController),
                        SizedBox(height: hight * 0.05),
                        CustomButton(
                          width: width,
                          text: 'SUBMIT',
                          onPress: () async {
                            if (numberTextEditingController.text.trim() != '') {
                              if (numericRegex.hasMatch(numberTextEditingController.text.trim())) {
                                showSnackBar(context, 'Saving Data Please wait');
                                try {
                                  int totalpoint = materialPoints * int.parse(numberTextEditingController.text.trim());
                                  userPoints = userPoints + totalpoint;
                                  recyclingNumber = recyclingNumber + int.parse(numberTextEditingController.text.trim());
                                  lastPoints = currentPoints;
                                  lastRecyclingNumber = currentRecyclingNumber;
                                  currentPoints = totalpoint;
                                  currentRecyclingNumber = int.parse(numberTextEditingController.text.trim());
                                  userMaterials[DateTime.now().toString()] = <String, dynamic>{
                                    'name': materialSelectedValue,
                                    'points': totalpoint,
                                    'recyclingNumber': int.parse(numberTextEditingController.text.trim()),
                                  };

                                  await FirebaseFirestore.instance.collection('users').doc(uid).update({
                                    'materials': userMaterials,
                                    'points': userPoints,
                                    'lastPoints': lastPoints,
                                    'lastRecyclingNumber': lastRecyclingNumber,
                                    'recyclingNumber': recyclingNumber,
                                    'currentRecyclingNumber': currentRecyclingNumber,
                                    'currentPoints': currentPoints,
                                  }).then((value) {
                                    showSnackBar(context, 'Point Added');
                                    Navigator.pop(context);
                                  });
                                } catch (e) {
                                  print(e);
                                  showSnackBar(context, 'Error: ${e.toString()}');
                                }
                              } else {
                                showSnackBar(context, 'Numbers can only be digits');
                              }
                            } else {
                              showSnackBar(context, 'Please Enter Numbers');
                            }
                          },
                          btnradius: 10,
                        ),
                      ],
                    )
                  : Text('Loading Data', style: TextStyle(fontSize: 20, color: kBlackColor, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  void loadData() async {
    await FirebaseFirestore.instance.collection('materials').get().then((value) async {
      for (int i = 0; i < value.docs.length; i++) {
        materialItems.add(value.docs[i].get('name'));
        materialPointsList.add(value.docs[i].get('points'));
      }
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).get().then((value) {
        userMaterials = value.get('materials');
        userPoints = value.get('points');
        lastPoints = value.get('lastPoints');
        lastRecyclingNumber = value.get('lastRecyclingNumber');
        recyclingNumber = value.get('recyclingNumber');
        currentPoints = value.get('currentPoints');
        currentRecyclingNumber = value.get('currentRecyclingNumber');
        uid = value.id;
      });
      materialSelectedValue = materialItems[0];
      materialPoints = materialPointsList[0];
      setState(() {});
    });
  }
}

class CustomNumberField extends StatelessWidget {
  const CustomNumberField({
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
              keyboardType: TextInputType.number,
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

class CustomPointsField extends StatelessWidget {
  const CustomPointsField({
    super.key,
    required this.point,
    required this.title,
  });

  final int point;
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
            child: Text(point.toString()),
          )
        ],
      ),
    );
  }
}

class CustomDropDown extends StatefulWidget {
  CustomDropDown({
    Key? key,
    required this.items,
    required this.selectedValue,
    required this.textEditingController,
    required this.title,
    required this.onChange,
  }) : super(key: key);
  final List<String> items;
  String? selectedValue;
  final TextEditingController textEditingController;
  final String title;
  final Function(String?) onChange;
  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: kOffWhite, border: Border.all(color: kGreyColor), borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5),
          Text(
            widget.title,
            style: TextStyle(color: kGreyColor, fontSize: 10),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              hint: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).hintColor,
                ),
              ),

              items: widget.items
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ))
                  .toList(),
              value: widget.selectedValue,
              onChanged: widget.onChange,
              buttonStyleData: const ButtonStyleData(
                height: 40,
                width: double.infinity,
              ),
              dropdownStyleData: const DropdownStyleData(
                maxHeight: 200,
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
              ),
              dropdownSearchData: DropdownSearchData(
                searchController: widget.textEditingController,
                searchInnerWidgetHeight: 50,
                searchInnerWidget: Container(
                  height: 50,
                  padding: const EdgeInsets.only(
                    top: 8,
                    bottom: 4,
                    right: 8,
                    left: 8,
                  ),
                  child: TextFormField(
                    expands: true,
                    maxLines: null,
                    controller: widget.textEditingController,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      hintText: 'Search for an ${widget.title}...',
                      hintStyle: const TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                searchMatchFn: (item, searchValue) {
                  return (item.value.toString().contains(searchValue));
                },
              ),
              //This to clear the search value when you close the menu
              onMenuStateChange: (isOpen) {
                if (!isOpen) {
                  widget.textEditingController.clear();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
