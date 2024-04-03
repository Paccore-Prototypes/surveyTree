import 'package:flutter/material.dart';

import 'callingFile.dart';
class Introduction extends StatefulWidget {
  const Introduction({super.key});

  @override
  State<Introduction> createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      body: Column(
       children: [

         Container(
           height: 490,
           alignment: Alignment.center,
           color: Colors.white24,

           child: Image.asset('assets/images/doctorimage.png',
             height: 350,
             width: 300,
           ),

         ),
         SizedBox(height: 40),
         Padding(
           padding: const EdgeInsets.only(left: 20),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text(
                 "Fill Out The Pre-Anesthesia Questionnaire",
                 style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
               ),
               SizedBox(height: 20),
               Text(
                 "Get Ready for survey in advance",
                 style: TextStyle(fontSize: 10, fontWeight: FontWeight.normal),
               ),
             ],
           ),
         ),


         SizedBox(height: 40),
         ElevatedButton(
           style: ElevatedButton.styleFrom(
             primary: Colors.pinkAccent,
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(12),
             ),
             minimumSize: Size(290, 56),
           ),
           onPressed: () {
Navigator.push(context,
  MaterialPageRoute(builder: (context) => ImportingProperties())
);
           },
           child: Text('Start',style: TextStyle(color: Colors.white)),
         ),
          SizedBox(height: 30,),

       ],
     ),
    );

  }
}
