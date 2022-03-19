import 'package:flutter/material.dart';
import 'package:medi_track/components/add_textfield.dart';
import 'package:medi_track/components/medicine_type.dart';
import 'package:intl/intl.dart';

import '../components/info_container.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  DateTime startDate = DateTime.now();
  DateTime endDate=DateTime.now();
  TimeOfDay time=TimeOfDay(hour: 0, minute: 0);
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked=await showTimePicker(context: context, initialTime: time);
    if (picked!=null && picked!=time){
      setState(() {
        time = picked;
      });
    }
  }
  Future<void> _selectDate(BuildContext context, bool start) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: startDate,
        lastDate: DateTime(2023));
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
    
      print(startDate);
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
                      MedicineType(
                        image: "pills.png",
                      ),
                      MedicineType(
                        image: "syrup.png",
                      ),
                      MedicineType(
                        image: "syringe.png",
                      ),
                      MedicineType(
                        image: "vitaminc.png",
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: space,
              ),
              AddTextField(
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
                          _selectDate(context,true);
                        },
                        child: InfoContainer(
                          title: AppLocalizations.of(context)!.start,
                          info: "${DateFormat('dd MMM yyyy').format(startDate)}",
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _selectDate(context,false);
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
                    title: AppLocalizations.of(context)!.note,
                    width: double.infinity,
                    height: 60.0,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
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
