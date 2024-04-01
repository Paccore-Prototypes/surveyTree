import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:infosurvey/info_survey.dart';
import 'package:infosurvey/tree_node.dart';

class ImportingProperties extends StatefulWidget {
  const ImportingProperties({super.key});

  @override
  State<ImportingProperties> createState() => _ImportingPropertiesState();
}

class _ImportingPropertiesState extends State<ImportingProperties>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  TreeModel? model;
  bool isLoad = false;
  String question = '';
  int questionId = 0;
  Map<String, dynamic> options = {};
  List<String> answers = [];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoad
          ? const CircularProgressIndicator()
          : model != null
          ? Center(
        child: InfoSurvey(

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

          customWidget: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.blueGrey.shade200,
            child: Column(children: [
              const SizedBox(height: 50,),
              Text(question,style: const TextStyle(
                  fontWeight: FontWeight.bold,fontSize: 16
              ),),
              Column(
                children: (options).keys
                    .map<Widget>((answer) {
                  return CheckboxListTile(
                      title: Text(
                        answer,
                        style:
                        const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16),
                      ),

                      activeColor: Colors.indigo,
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
              ),
              const SizedBox(height: 20,),
              InkWell(
                onTap: (){

                },
                child: Container(
                  height: 50,
                  width: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.teal,
                        Colors.teal.shade300,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(5, 5),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: const Text('Next'),
                ),
              )
            ],),

          ),

          customWidgetReturn: (questionId,question,answers){
            print('printing the questionid----------------$questionId');
            print('printing the question----------------$question');
            print('printing the question-answer----------------$answers');

          },

          onPageChanged: (answerMap, questionData, index){

            setState(() {
              question = questionData!.question;
              options = questionData.answerChoices;
              questionId = questionData.id;

            });
            print('on page change called answerMap--- $answerMap');
            print('on page change called question Id was---${questionData?.answerChoices}');
            print('on page change called index---$index');

          },
        ),
      )
          : Container(),
    );
  }
}
