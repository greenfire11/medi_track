import 'package:flutter/material.dart';
import 'package:medi_track/screens/info_screen.dart';

class MedicineCard extends StatelessWidget {
  MedicineCard({this.image, this.name, this.time,this.doc});
  final image;
  final name;
  final time;
  final doc;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InfoScreen(doc: doc)),
        );
      },
      child: Container(
        padding: EdgeInsets.only(right: 10, left: 10),
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),


        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              child: Image.asset("images/$image"),
              height: 50,
            ),
            Text(
              name,
              style: TextStyle(fontSize: 20),
            ),
            Text(time),
          ],
        ),
      ),
    );
  }
}
