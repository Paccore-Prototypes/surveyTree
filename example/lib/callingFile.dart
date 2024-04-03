import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scalable_ocr/flutter_scalable_ocr.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infosurvey/info_survey.dart';
import 'package:infosurvey/tree_node.dart';
import 'package:permission_handler/permission_handler.dart';


class ImportingProperties extends StatefulWidget {

  const ImportingProperties({super.key,});

  @override
  State<ImportingProperties> createState() => _ImportingPropertiesState();
}

class _ImportingPropertiesState extends State<ImportingProperties>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  TreeModel? model;
  bool isLoad = false;
  String? questionType;
  int? score;
  String question = '';
  String description = '';
  int questionId = 0;
  Map<String, dynamic> options = {};
  List<String> scannedTextList = [];

  List<String> answers = [];
  String answerdata = '';
  String scannedText = '';


  @override
  void initState() {
    super.initState();
    modelJson().then((treeModel) {
      setState(() {
        model = treeModel;
        isLoad = false;
      });
    });
    _controller = AnimationController(vsync: this);
  }


void switching (){
    if(questionId == 402){

    }

}



  static Future<bool> getCameraPermission(BuildContext context) async {
    bool isPermissionGranted = false;
    if (await Permission.camera.request().isGranted) {
      isPermissionGranted = true;
      return isPermissionGranted;
    } else if (await Permission.camera.request().isPermanentlyDenied) {
      isPermissionGranted = false;
      // isPermissionGranted = await openAppSettings();
      if (Platform.isAndroid) {

      } else {

      }
      return isPermissionGranted;
    } else if (await Permission.camera.request().isDenied) {
      isPermissionGranted = false;
      // Utils.getCameraPermission(context);
      if (Platform.isIOS) {

      }else{

      }
      return isPermissionGranted;
    }
    return isPermissionGranted;
  }

  @override
  void dispose() {
    _controller.dispose();
    controller.close();
    super.dispose();
  }

  Future<TreeModel> modelJson() async {
    setState(() {
      isLoad = true;
    });
    String data = await DefaultAssetBundle.of(context).loadString("assets/survey.json");
    List<Map<String, dynamic>> dataList = List<Map<String, dynamic>>.from(jsonDecode(data));
    TreeModel treeModel = TreeModel.fromJson(dataList);
    return treeModel;
  }
      final GlobalKey<InfoSurveyState> infoSurveyKey = GlobalKey<InfoSurveyState>();
  String text = "";
  StreamController<String> controller = StreamController<String>();

  String savingValue = '';

  void setText(value) {
    controller.close();
    controller = StreamController<String>();
    controller.add(value);
    print('Saving the taken text from camera --$value');
    savingValue = value;
    print('Saving the taken text from camera with saving value------$savingValue');
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: isLoad
            ? const CircularProgressIndicator()
            : model != null
            ? Center(
          child: InfoSurvey(
key: infoSurveyKey,
        treeModel: model!,
        tileListColor: Colors.blueGrey.shade200,
        showScoreWidget: true,
        questionContentAlignment: CrossAxisAlignment.center,
        onListTaleTapnavigation: false,
        imagePlaceHolder: 'assets/images/placeholder1.png',
//         onSurveyEnd: (score,answermap){
// print('the survey score was----- '+score.toString());
//         },
            surveyResult: (score, answersMap) {
              print('Health Score: $score');
              print('Answers Map: $answersMap');
            },
            customWidget: questionId == 404 ?
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.white60,
              child: Column(
                children: [
                  ScalableOCR(
                      paintboxCustom: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 4.0
                        ..color = const Color.fromARGB(153, 102, 160, 241),
                      boxLeftOff: 5,
                      boxBottomOff: 2.5,
                      boxRightOff: 5,
                      boxTopOff: 2.5,
                      boxHeight: MediaQuery.of(context).size.height / 3,
                      getRawData: (value) {
                        inspect(value);
                      },
                      getScannedText: (value) {
                        setText(value);
                      }),
                  StreamBuilder<String>(
                    stream: controller.stream,
                    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                      return Result(text: scannedText);
                      //  return Result(text: snapshot.data != null ? snapshot.data! : "");
                    },
                  ),

                  Container(

                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.9,

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],// Adjust border radius as needed
                    ),

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/notebook.png',
                          height: 100,
                          width: 100,
                        ),
                        const SizedBox(height: 20),
                        const Align(alignment: Alignment.center,),
                        const Text(
                          'Scan ',

                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const Text(
                          'Your Prescription',

                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),

                      ],
                    ),
                  ),
                  const SizedBox(height: 15,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.teal.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: Size(MediaQuery.of(context).size.width * 0.9, 56),
                    ),
                    onPressed: () {
                      setState(() {
                        scannedText = savingValue;
                      });
                    },
                    child: const Text('Save', style: TextStyle(color: Colors.white)),
                  ),

                  const SizedBox(height: 30,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.pinkAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: Size(MediaQuery.of(context).size.width * 0.9, 56),
                    ),
                    onPressed: ()async{
                      infoSurveyKey.currentState!.onCustomWidgetNextTapped(questionId, scannedText, question, score??0);
                      /*   bool isPermissionGranted =
                      await getCameraPermission(
                          context);
                      if (isPermissionGranted) {
                        final XFile? image =
                        await ImagePicker().pickImage(
                            source: ImageSource.camera);
                        // You can handle the captured image here, such as displaying it or processing it further
                        if (image != null) {
                          // Do something with the captured image
                        }
                      }*/
                    },

                    child: const Text('Next'),
                  ),
                ],
              ),
            ) :
            questionId == 402 ?
            Column(
              children: [
               // const SizedBox(height: 40,),
                Container(
                  height: 250,
                  alignment: Alignment.center,
                  color: Colors.teal.shade200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 90,),
                          Text(question,style: const TextStyle(fontSize: 25,fontWeight : FontWeight.bold,color: Colors.black),),
                          Text(description),
                        ],
                      ),
                      Image.asset('assets/images/notebook.png',height: 100,width: 100,)
                    ],
                  ),
                ),
                const SizedBox(height: 30,),
              /*  Column(

                  children: (options)
                      .keys
                      .map<Widget>((answer) {
                    return CheckboxListTile(
                        title: Text(
                          answer,
                          style:
                              const TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 16),
                        ),

                        activeColor:  Colors.indigo,
                        value: answers.contains(answer),
                        onChanged: (bool? selected) {
                          setState(() {
                            if (selected ?? false) {
                              if (!answers.contains(answer)) {
                                answers.add(answer);
                              }
                            } else {
                              answers.remove(answer);
                            }
                          });
                        } );
                  }).toList(),
                ),*/
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20),
                  child: Column(
                     children: (options).keys
                           .map<Widget>((answer) {
                       bool isSelected = answerdata == answer;

                       if(infoSurveyKey.currentState!.answersMap.containsKey(question)) {
                         if(infoSurveyKey.currentState?.answersMap[question]['answer']!=null && infoSurveyKey.currentState?.answersMap[question]['answer']!=''){
                           if(answerdata==''){
                             answerdata = infoSurveyKey.currentState?.answersMap[question]['answer'] ?? '';
                           }
                         }
                       }

                       return Column(
                         children: [
                           const SizedBox(height: 10,),
                           ListTile(
                               title: Center(child:
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Text(answer,style: TextStyle(
                                     color: isSelected ? Colors.teal : Colors.black54,fontWeight: FontWeight.w500
                                   ),),
                                   Container(
                                     height: 20,
                                     width: 20,
                                     decoration: BoxDecoration(
                                    //   borderRadius: const BorderRadius.all(Radius.circular(12)),
                                       border: Border.all(
                                         color: isSelected ? Colors.teal : Colors.black12,width: 5
                                       ),
                                       shape: BoxShape.circle
                                     ),
                                   )
                                   // ClipOval(
                                   //     child: Container(height: 30, width: 30, color: Colors.orange)),
                                 ],
                               )),
                             contentPadding: EdgeInsets.symmetric(vertical: 7, horizontal: 16.0),
                             dense:true,
                             shape: isSelected ?
                                 RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(10),
                                   side: const BorderSide(color: Colors.teal,width: 2),
                                 ) : RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(10),
                               side: BorderSide(color: Colors.blueGrey.shade100),
                             ),
                               selected: isSelected,
                               onTap: () {


                                 setState(() {
                                   if (answerdata != answer) {
                                     answerdata = answer;



                                     print('-------------------------------------checking the answerdata value--$answerdata');
                                   } else {
                                         answerdata = '';
                                   }
                                 });
                               },
                             ),
                         ],
                       );
                     }).toList()
                  ),
                ),
                const SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20),
                  child: InkWell(
                    onTap: (){

                      infoSurveyKey.currentState!.onCustomWidgetNextTapped(questionId, answerdata, question, score??0);
                      Future.delayed(const Duration(milliseconds: 800)).then((value){
                        answerdata = '';
                        setState(() {

                        });
                      });


                    },
                    child: Container(
                      height: 62,
                    //  width: 300,
                      decoration: BoxDecoration(
                        color: Colors.pink.shade200,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: Offset(1,1), // changes position of shadow
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Text('Next Question',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
                    ),
                  ),
                )
              ],
            )
                : Column(crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 400,
                  width: 300,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      image: const DecorationImage(
                        image:AssetImage("assets/images/something1.jpg"),
                        fit: BoxFit.fill,
                      ),
                    color: Colors.blueGrey.shade200,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(width: 1,color: Colors.blueGrey)
                  ),
                ),
                const SizedBox(height: 20,),
                const Text('No custom widget found!',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
              ],
            ),

            // customWidgetReturn: (questionId,question,answers){
            //   print('printing the questionid----------------$questionId');
            //   print('printing the question----------------$question');
            //   print('printing the question-answer----------------$answers');
            //
            // },

            onPageChanged: (answerMap, questionData, index){

              setState(() {
                question = questionData!.question;
                options = questionData.answerChoices;
                questionId = questionData.id;
                description = questionData.description!;
                score=questionData.score??0;
                questionType=questionData.questionType;



              });

              print('on page change called answerMap--- $answerMap');
              print('on page change called question Id was---${questionData?.answerChoices}');
              print('on page change called index---$index');

        },
      ),
          )
          : Container(),
    ));
  }
}

class Result extends StatelessWidget {
  const Result({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text("Readed text: $text");
  }
}
