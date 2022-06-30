import 'package:flutter/material.dart';
import 'package:medi_track/components/add_textfield.dart';
import 'package:medi_track/components/medicine_type.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/info_container.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  String image='';
  TextEditingController nameController = TextEditingController();
  TextEditingController dosageController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  TimeOfDay time = TimeOfDay(hour: 0, minute: 0);
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

  double space = 40;
  @override
  Widget build(BuildContext context) {
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
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 30, 15, 15),
          child: Column(
            children: [
              AddTextField(
                controller: nameController,
                title: AppLocalizations.of(context)!.medName,
                width: double.infinity,
                height: 60.0,
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
                          color: image == "pills.png" ? Colors.green:Colors.white,
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
                          color: image == "syrup.png" ? Colors.green:Colors.white,
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
                          color: image == "syringe.png" ? Colors.green:Colors.white,
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
                          color: image == "vitaminc.png" ? Colors.green:Colors.white,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _selectDate(context, true);
                        },
                        child: InfoContainer(
                          title: AppLocalizations.of(context)!.start,
                          info:
                              "${DateFormat('dd MMM yyyy').format(startDate)}",
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _selectDate(context, false);
                        },
                        child: InfoContainer(
                          title: AppLocalizations.of(context)!.end,
                          info: "${DateFormat('dd MMM yyyy').format(endDate)}",
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: space,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _selectTime(context);
                        },
                        child: InfoContainer(
                          title: AppLocalizations.of(context)!.time,
                          info: "${time.format(context)}",
                        ),
                      ),
                      InfoContainer(
                        title: AppLocalizations.of(context)!.freq,
                        info: "weekly",
                      )
                    ],
                  ),
                  SizedBox(
                    height: space,
                  ),
                  AddTextField(
                    controller: noteController,
                    title: AppLocalizations.of(context)!.note,
                    width: double.infinity,
                    height: 60.0,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () async {
                      DateFormat dateFormat = DateFormat('dd.MM.yyyy');
                      DateTime s = DateTime.utc(
                          startDate.year, startDate.month, startDate.day);
                      List dateList = [];
                      while (endDate.difference(s).inDays >= 0) {
                        setState(() {
                          dateList.add(dateFormat.format(s));
                          s = s.add(Duration(days: 7));
                        });
                      }
                      List boolList = [];
                      for (var i = 0; i < dateList.length; i++) {
                        boolList.add(false);
                      }
                      final data = {
                        'name':nameController.text,
                        'image':image,
                        'dosage':dosageController.text,
                        'time':'${time.hour}:${time.minute}',
                        'note':noteController.text,
                        'dates':dateList,
                        'completed':boolList
                      };
                      if (data[0]==null || data[1]=='') {
                        
                      } else {
                        await db.collection('YN0Y8HQaIGVyzgZ1I9IGSw2E4PB2').doc(nameController.text).set(data);
                        Navigator.pop(context);
                      }

                     
                     
                    },
                    child: Container(
                      width: 160.0,
                      height: 45.0,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.addmed,
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
