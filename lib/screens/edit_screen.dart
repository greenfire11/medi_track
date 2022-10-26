import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:medi_track/components/add_textfield.dart';
import 'package:medi_track/components/medicine_type.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:medi_track/screens/info_screen.dart';

import '../api/notification_api.dart';
import '../components/info_container.dart';
import '../med_data.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key, required this.doc}) : super(key: key);
  final doc;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  void getDoc() async {
    var collectionRef = FirebaseFirestore.instance.collection(userid);

    var doc = await collectionRef.doc(widget.doc).get();
    var data = doc.data()!;
    setState(() {
      nameController.text = data['name'];
      image = "${data['image']}";
      dosageController.text = data["dosage"];
      noteController.text = data["note"];

      int h = int.parse(data["time"].split(":")[0]);
      int m = int.parse(data["time"].split(":")[1]);
      time = TimeOfDay(hour: h, minute: m);
      dropdownvalue = data["frequency"];
      var inputFormat = DateFormat('dd.MM.yyyy');
      var date1 = inputFormat.parse(data['dates'][0]);
      var date2 = inputFormat.parse(data['dates'][data['dates'].length - 1]);
      startDate = date1;
      endDate = date2;
    });
  }

  @override
  void initState() {
    getDoc();
    super.initState();
  }

  FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  late String userid = auth.currentUser!.uid;
  TextEditingController nameController = TextEditingController();
  TextEditingController dosageController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  double space = 40;
  String image = '';
  late int idVal;
  late String dropdownvalue = AppLocalizations.of(context)!.weekly;
  late var items = [
    AppLocalizations.of(context)!.daily,
    AppLocalizations.of(context)!.weekly,
    AppLocalizations.of(context)!.monthly,
  ];
  TimeOfDay time = TimeOfDay(hour: 0, minute: 0);
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: time);
    if (picked != null && picked != time) {
      setState(() {
        time = picked;
      });
    }
  }

  Future<void> _selectDate(BuildContext context, bool start) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)));
    if (start == true) {
      if (picked != null && picked != startDate)
        setState(() {
          startDate = picked;
        });
    } else {
      if (picked != null && picked != endDate)
        setState(() {
          endDate = picked;
        });
    }
  }

  Future<bool> checkIfDocExists(String docId) async {
    try {
      // Get reference to Firestore collection
      var collectionRef = FirebaseFirestore.instance.collection(userid);

      var doc = await collectionRef.doc(docId).get();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection(userid).doc(widget.doc).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
                centerTitle: true,
                title: Text(AppLocalizations.of(context)!.addmedTitle),
              ),
              body: SafeArea(
                  child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 30, 15, 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context)!.addmedTitle),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 60,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Center(
                            child: TypeAheadFormField<String?>(
                              suggestionsCallback: MedData.getSuggestions,
                              itemBuilder: (context, String? suggestion) {
                                return ListTile(
                                  title: Text(suggestion!),
                                );
                              },
                              onSuggestionSelected: (String? suggestion) {
                                setState(() {
                                  nameController.text = suggestion!;
                                });
                              },
                              textFieldConfiguration: TextFieldConfiguration(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  ),
                                  cursorColor: Colors.black,
                                  controller: nameController),
                              suggestionsBoxDecoration:
                                  SuggestionsBoxDecoration(
                                      constraints:
                                          BoxConstraints(maxHeight: 170)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: space,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context)!.medType),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  image = "pills.png";
                                  print(image);
                                });
                              },
                              child: MedicineType(
                                image: "pills.png",
                                color: image == "pills.png"
                                    ? Colors.green
                                    : Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  image = "syrup.png";
                                });
                              },
                              child: MedicineType(
                                image: "syrup.png",
                                color: image == "syrup.png"
                                    ? Colors.green
                                    : Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  image = "syringe.png";
                                });
                              },
                              child: MedicineType(
                                image: "syringe.png",
                                color: image == "syringe.png"
                                    ? Colors.green
                                    : Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  image = "vitaminc.png";
                                });
                              },
                              child: MedicineType(
                                image: "vitaminc.png",
                                color: image == "vitaminc.png"
                                    ? Colors.green
                                    : Colors.white,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: space,
                    ),
                    AddTextField(
                      controller: dosageController,
                      title: AppLocalizations.of(context)!.dosage,
                      width: double.infinity,
                      height: 60.0,
                    ),
                    SizedBox(
                      height: space,
                    ),
                    Column(
                      children: [
                        AddTextField(
                          controller: noteController,
                          title: AppLocalizations.of(context)!.note,
                          width: double.infinity,
                          height: 60.0,
                        ),
                        SizedBox(height: 100,),
  
                        GestureDetector(
                          onTap: () async {
                            final data = {
                              'name': nameController.text,
                              'image': image,
                              'dosage': dosageController.text,
                              'note': noteController.text,
                            };
                            await db
                                .collection(userid)
                                .doc(widget.doc)
                                .update(data);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      InfoScreen(doc: widget.doc)),
                            );
                          },
                          child: Container(
                            width: 160.0,
                            height: 45.0,
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!.edit,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )),
            );
          }
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
                centerTitle: true,
                title: Text(AppLocalizations.of(context)!.addmedTitle),
              ),
              body: SafeArea(
                  child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 30, 15, 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context)!.addmedTitle),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 60,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Center(
                            child: TypeAheadFormField<String?>(
                              suggestionsCallback: MedData.getSuggestions,
                              itemBuilder: (context, String? suggestion) {
                                return ListTile(
                                  title: Text(suggestion!),
                                );
                              },
                              onSuggestionSelected: (String? suggestion) {
                                setState(() {
                                  nameController.text = suggestion!;
                                });
                              },
                              textFieldConfiguration: TextFieldConfiguration(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  ),
                                  cursorColor: Colors.black,
                                  controller: nameController),
                              suggestionsBoxDecoration:
                                  SuggestionsBoxDecoration(
                                      constraints:
                                          BoxConstraints(maxHeight: 170)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: space,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context)!.medType),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  image = "pills.png";
                                  print(image);
                                });
                              },
                              child: MedicineType(
                                image: "pills.png",
                                color: image == "pills.png"
                                    ? Colors.green
                                    : Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  image = "syrup.png";
                                });
                              },
                              child: MedicineType(
                                image: "syrup.png",
                                color: image == "syrup.png"
                                    ? Colors.green
                                    : Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  image = "syringe.png";
                                });
                              },
                              child: MedicineType(
                                image: "syringe.png",
                                color: image == "syringe.png"
                                    ? Colors.green
                                    : Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  image = "vitaminc.png";
                                });
                              },
                              child: MedicineType(
                                image: "vitaminc.png",
                                color: image == "vitaminc.png"
                                    ? Colors.green
                                    : Colors.white,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: space,
                    ),
                    AddTextField(
                      controller: dosageController,
                      title: AppLocalizations.of(context)!.dosage,
                      width: double.infinity,
                      height: 60.0,
                    ),
                    SizedBox(
                      height: space,
                    ),
                    Column(
                      children: [
                        AddTextField(
                          controller: noteController,
                          title: AppLocalizations.of(context)!.note,
                          width: double.infinity,
                          height: 60.0,
                        ),
                        SizedBox(height: 100,),
  
                        GestureDetector(
                          onTap: () async {
                            final data = {
                              'name': nameController.text,
                              'image': image,
                              'dosage': dosageController.text,
                              'note': noteController.text,
                            };
                            await db
                                .collection(userid)
                                .doc(widget.doc)
                                .update(data);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      InfoScreen(doc: widget.doc)),
                            );
                          },
                          child: Container(
                            width: 160.0,
                            height: 45.0,
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!.edit,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )),
            );
        });
  }
}
