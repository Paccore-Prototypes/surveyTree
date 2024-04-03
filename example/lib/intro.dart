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
           height: 510,
           alignment: Alignment.center,
           color: Colors.teal.shade300,
           child: Column(
             children: [
               const SizedBox(height: 60,),
               const Text('Aquesty',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
               Image.asset('assets/images/doctorimage.png',
                 height: 350,
                 width: 300,
               ),
             ],
           ),
         ),
         const SizedBox(height: 40),
         const Padding(
           padding: EdgeInsets.only(left: 20),
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


         const SizedBox(height: 40),
         ElevatedButton(
           style: ElevatedButton.styleFrom(
             backgroundColor: Colors.pinkAccent,
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(12),
             ),
             minimumSize: const Size(340, 56),
           ),
           onPressed: () {
Navigator.push(context,
  MaterialPageRoute(builder: (context) => ImportingProperties())
);
           },
           child: const Text('Start',style: TextStyle(color: Colors.white,fontSize: 18)),
         ),
          const SizedBox(height: 30,),

       ],
     ),
    );

  }
}
