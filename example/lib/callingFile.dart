import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:infosurvey/info_survey.dart';
import 'package:infosurvey/tree_node.dart';

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
  List<String> answers = [];
  String answerdata = '';
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







  @override
  void dispose() {
    _controller.dispose();
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

            customWidget: Column(
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
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20),
                  child: Column(
                     children: (options).keys
                           .map<Widget>((answer) {
                       bool isSelected = answerdata == answer;

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
                      // infoSurveyKey.currentState?.addTheFollowUpQuestion(answerdata,
                      // isScrollTonextPage: true,
                      
                      //         question:question,
                      //                                   isNestedchoice: true,

                      //         answeValue: {
                      //           'id': questionId,
                      //           'question-type': questionType,
                      //           'score': score??0,
                                    
                                    
                      //           'answer': answerdata
                      //         });
                      

                     // onTap(answerdata);
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
                      child: Text('Next Question',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
                    ),
                  ),
                )
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
