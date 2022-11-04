import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medi_track/components/add_textfield.dart';
import 'package:medi_track/components/medicine_type.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../api/notification_api.dart';
import '../components/info_container.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:medi_track/med_data.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:beautiful_soup_dart/beautiful_soup.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  List units = ["mg", "kg", "g", "l", "ml"];
  FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  late String userid = auth.currentUser!.uid;
  late String dropdownvalue = AppLocalizations.of(context)!.weekly;
  late var items = [
    AppLocalizations.of(context)!.daily,
    AppLocalizations.of(context)!.weekly,
    AppLocalizations.of(context)!.monthly,
  ];
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  String image = '';
  TextEditingController nameController = TextEditingController();
  TextEditingController dosageController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  TimeOfDay time = TimeOfDay(hour: 0, minute: 0);
  void getData(String tag) async {
    final resonse = await http.post(
        Uri.parse(
            "https://refdatabase.refdata.ch/Viewer/SearchArticle?Lang=fr"),
        body: {
          "SearchTerm": tag,
          "Sort": "ArticleDescriptionFrench"
        },
        headers: {
          "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
          "Referer": "https://refdatabase.refdata.ch/Viewer/Article/?Lang=FR"
        });

    BeautifulSoup bs = BeautifulSoup(resonse.body.toString());
    var table = bs.find("table", attrs: {'id': 'GVResultb'});
    print(table);
    if (table==null) {
      
    }
    var rows = table!.findAll('tr');
    var cells = rows[0].findAll('td');
    var text = cells[2].toString().replaceAll(RegExp('<[^>]+>'), '');
    List<String> li = text.split(" ");
    setState(() {
      nameController.text = li[0];
    });
    if (li[0].isEmpty) {
      
    }
    print(li);
    OUTER:
    for (int i = 0; i < li.length; i++) {
      for (int n = 0; n < units.length; n++) {
        if (li[i].toLowerCase() == units[n]) {
          setState(() {
            dosageController.text = "${li[i - 1] + li[i]}";
          });
          print(li[i - 1] + li[i]);
          break OUTER;
        }
      }
    }
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    getData(barcodeScanRes);
  }

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

  late int idVal;

  /// Check If Document Exists
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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.qr_code_scanner),
        onPressed: () {
          scanBarcodeNormal();
        },
      ),
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
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
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
                              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            ),
                            cursorColor: Colors.black,
                            controller: nameController),
                        suggestionsBoxDecoration: SuggestionsBoxDecoration(
                            constraints: BoxConstraints(maxHeight: 170)),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppLocalizations.of(context)!.freq),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
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
                            height: 38,
                            width: 100,
                            child: Center(
                              child: DropdownButton(
                                value: dropdownvalue,
                                iconSize: 0.0,
                                underline: SizedBox(),
                                items: items.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownvalue = newValue!;
                                  });
                                },
                              ),
                            ),
                          )
                        ],
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
                      List dateListTime = [];
                      while (endDate.difference(s).inDays >= 0) {
                        setState(() {
                          dateList.add(dateFormat.format(s));
                          dateListTime.add(s.add(Duration(
                              hours: time.hour, minutes: time.minute)));
                          if (dropdownvalue ==
                              AppLocalizations.of(context)!.weekly) {
                            s = s.add(Duration(days: 7));
                          } else if (dropdownvalue ==
                              AppLocalizations.of(context)!.daily) {
                            s = s.add(Duration(days: 1));
                          } else {
                            s = DateTime(s.year, s.month + 1, s.day);
                          }
                        });
                      }
                      print(dateListTime[0].toString());
                      if (checkIfDocExists('idValue') == true) {
                        var document = await FirebaseFirestore.instance
                            .collection(userid)
                            .doc('idValue')
                            .get();
                        setState(() {
                          idVal = document.data()?['id'];
                        });
                      } else {
                        await FirebaseFirestore.instance
                            .collection(userid)
                            .doc('idValue')
                            .set({'id': 0});
                        setState(() {
                          idVal = 0;
                        });
                      }

                      List boolList = [];
                      for (var i = 0; i < dateList.length; i++) {
                        boolList.add(false);
                      }
                      List id = [];
                      for (var i = 0; i < dateList.length; i++) {
                        id.add(idVal + i);
                      }
                      final data = {
                        'name': nameController.text,
                        'image': image,
                        'dosage': dosageController.text,
                        'time': time.minute < 10
                            ? '${time.hour}:0${time.minute}'
                            : '${time.hour}:${time.minute}',
                        'note': noteController.text,
                        'dates': dateList,
                        'completed': boolList,
                        'frequency': dropdownvalue,
                        'id': id
                      };
                      await db.collection(userid).doc().set(data);

                      for (int i = 0; i < dateListTime.length; i++) {
                        await NotificationApi.showScheduledNotification(
                          id: idVal + i,
                          title: nameController.text,
                          body: AppLocalizations.of(context)!.notificationText,
                          scheduledDate: DateTime.parse(
                            dateListTime[i]
                                .toString()
                                .replaceAll(":00.000Z", ""),
                          ),
                        );
                        await FirebaseFirestore.instance
                            .collection(userid)
                            .doc('idValue')
                            .set({'id': idVal + 1 + i});

                        print("done ${dateListTime[i]}");
                      }

                      Navigator.pop(context);
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
