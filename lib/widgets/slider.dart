import 'dart:collection';

import 'package:flutter/material.dart';
import '../enum.dart';
import '../tree_node.dart';
import '../utils/imageparser.dart';

class CustomSlider extends StatefulWidget {
  TreeNode questionData;
  bool isLast;
  Color? inactiveColorSlider;
  Color? activeColorSlider;
  Function(HashMap<String, dynamic>)? onSurveyEnd;
  String? imagePlaceHolder;
  CrossAxisAlignment? questionContentAlignment;
  TextStyle? sliderQuestionStyle;
  TextStyle? descriptionStyle;
  Widget? customButton;
  Widget? customLastButton;
  String? skipText;
  TextStyle? customSkipStyle;
  TextStyle? description;
  HashMap<String, dynamic>? answersMap;
  final Function(String? sliderValue, TreeNode callBackData,bool? fromSkip)? callBack;
  CustomSlider({
    Key? key,
    required this.questionData,
    required this.isLast,
    this.onSurveyEnd,
    required this.callBack,
    this.imagePlaceHolder,
    this.questionContentAlignment,
    this.sliderQuestionStyle,
    this.descriptionStyle,
    this.customButton,
    this.customLastButton,
    this.skipText,
    this.customSkipStyle,
    this.answersMap,
  }) : super(key: key);

  @override
  _CustomSliderState createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  late PageController pageController;
  late ValueNotifier<double> sliderValue;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    sliderValue = ValueNotifier<double>(
        double.parse(widget.answersMap?[widget.questionData.question]['answer'] ?? '25'));
  }

  @override
  Widget build(BuildContext context) {
    ImagePosition imagePosition = ImagePosition.top;
    if (widget.questionData.imagePosition != null) {
      imagePosition = ImagePosition.values.firstWhere(
            (e) => e.toString().split('.').last == widget.questionData.imagePosition!,
        orElse: () => ImagePosition.top,
      );
    }
    double sliderScore = 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(

        crossAxisAlignment: widget.questionContentAlignment ?? CrossAxisAlignment.end,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.01,
          ),
          imagePosition == ImagePosition.top &&
              widget. questionData.image != null &&
              widget.questionData.image!.isNotEmpty
              ? ImageParser(data:widget.questionData,
            imagePaceHolder: widget.imagePlaceHolder,

          )
              : Container(),
          imagePosition == ImagePosition.top &&
              widget. questionData.image != null &&
              widget.  questionData.image!.isNotEmpty ?  SizedBox(height: MediaQuery.of(context).size.height*0.01):const SizedBox(height: 0,),
          Text(
            widget.questionData.question ?? "",
            style: widget.sliderQuestionStyle ??
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height*0.01,
          ),
          imagePosition == ImagePosition.middle &&
              widget.questionData.image != null &&
              widget. questionData.image!.isNotEmpty
              ? ImageParser(data:widget.questionData,
            imagePaceHolder: widget.imagePlaceHolder,

          )
              : Container(),
          imagePosition == ImagePosition.middle &&
              widget.questionData.image != null &&
              widget.  questionData.image!.isNotEmpty ?  SizedBox(height: MediaQuery.of(context).size.height*0.01):const SizedBox(height: 0),

          widget. questionData.description!.isNotEmpty
              ? Text(
            widget. questionData.description.toString(),
            style: widget.description ?? const TextStyle(fontSize: 12),
          )
              : const SizedBox(
            height: 0,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height*0.01,
          ),
          imagePosition == ImagePosition.bottom &&
              widget.questionData.image != null &&
              widget.questionData.image!.isNotEmpty
              ? ImageParser(data:widget.questionData,
            imagePaceHolder: widget.imagePlaceHolder,

          )
              : Container(),
          imagePosition == ImagePosition.bottom &&
              widget.questionData.image != null &&
              widget.questionData.image!.isNotEmpty ? SizedBox(height: MediaQuery.of(context).size.height*0.01,):const SizedBox(height: 0,),
          ValueListenableBuilder<double>(
            valueListenable: sliderValue,
            builder: (context, value, child) {
              return Column(
                children: [
                  SliderTheme(
                      data: const SliderThemeData(
                          showValueIndicator: ShowValueIndicator.always),
                      child:
                      Slider(
                        value: sliderValue.value,
                        divisions: 100,
                        onChanged: (double newValue) {
                          sliderValue.value = newValue;
                        },
                        max: 100,
                        inactiveColor:
                        widget.inactiveColorSlider ?? Colors.blueGrey.shade300,
                        activeColor: widget.activeColorSlider ?? Colors.blueGrey,
                        label: sliderValue.value.toStringAsFixed(0),
                      )),
                  // Text(
                  //   "Saved Value: ${sliderValue.value.toStringAsFixed(0)}",
                  //   style: TextStyle(
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.bold,
                  //       color: Colors.deepPurple.shade400),
                  // ),
                ],
              );
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height*0.01,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.questionData.isMandatory == false && widget.isLast == false
                    ? GestureDetector(
                  onTap: () {

                    widget.callBack!('', widget.questionData,true);

                  },

                  /* child:
                    Container(
                      width: 120,
                      height:  40,
                      decoration: BoxDecoration(ms
                        gradient: LinearGradient(
                          colors: [
                             Colors.blueGrey,
                             Colors.blueGrey.shade200,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueGrey.shade50,
                            offset: const Offset(5, 5),
                            blurRadius:  10,
                          )
                        ],
                      ),*/
                  child: Center(
                    child: Text(
                      widget.skipText ?? 'Skip',
                      style: widget.customSkipStyle ?? const  TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.blue,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                )

    : const SizedBox(),
    GestureDetector(
    onTap: () {

    if (widget.questionData != null) {
    widget.callBack!( sliderValue.value.toStringAsFixed(0),  widget.questionData,false);
    }
    },
    //                 : const SizedBox(),
    //             GestureDetector(
    //                 onTap: () {
    // String? ageGroup;
    // double valueSlider = sliderValue.value;
    // if (valueSlider < 10) {
    // ageGroup = 'under_10';
    // } else if (valueSlider >= 10 && valueSlider <= 20) {
    // ageGroup = '10_to_20';
    // } else if (valueSlider > 20 && valueSlider <= 30) {
    // ageGroup = '20_to_30';
    // } else if (valueSlider >= 10 && valueSlider <= 20) {
    // ageGroup = '30_to_40';
    // } else if (valueSlider > 20 && valueSlider <= 30) {
    // ageGroup = '40_to_50';
    // } else if (valueSlider >= 10 && valueSlider <= 20) {
    // ageGroup = '50_to_60';
    // } else if (valueSlider > 20 && valueSlider <= 30) {
    // ageGroup = '60_to_70';
    // } else if (valueSlider >= 10 && valueSlider <= 20) {
    // ageGroup = '70_to_80';
    // } else if (valueSlider > 20 && valueSlider <= 30) {
    // ageGroup = '80_to_90';
    // } else if (valueSlider >= 10 && valueSlider <= 20) {
    // ageGroup = '90_to_100';
    // } else {}
    //
    // switch (ageGroup) {
    // case 'under_10':
    // sliderScore = 1;
    // break;
    // case '10_to_20':
    // sliderScore = 2;
    // break;
    // case '20_to_30':
    // sliderScore = 3;
    // break;
    // case '30_to_40':
    // sliderScore = 4;
    // break;
    // case '40_to_50':
    // sliderScore = 5;
    // break;
    // case '50_to_60':
    // sliderScore = 6;
    // break;
    // case '60_to_70':
    // sliderScore = 7;
    // break;
    // case '70_to_80':
    // sliderScore = 8;
    // break;
    // case '80_to_90':
    // sliderScore = 9;
    // break;
    // case '90_to_100':
    // sliderScore = 10;
    // break;
    // default:
    // sliderScore = widget.questionData.score!.toDouble();
    // break;
    // }
    // },

                      //   if (isLast) {
                      //     answersMap[questionData.question!] = {
                      //       'id': questionData.id,
                      //       'score': questionData.answerChoices == null
                      //           ? 0
                      //           : questionData.score,
                      //       //  'score': sliderScore,
                      //       'question-type': questionData.questionType,
                      //       'answer': sliderValue.value.toStringAsFixed(0)
                      //     };
                      //     if(widget.onSurveyEnd!=null){
                      //       widget.onSurveyEnd!(sumOfScores, answersMap);
                      //     }else{
                      //       _showSubmitDialog();
                      //
                      //     }
                      //   } else {
                      //     addTheFollowUpQuestion('',
                      //         isNestedchoice: true,
                      //         question: questionData.question,
                      //         answeValue: {
                      //           'id': questionData.id,
                      //           'question-type': questionData.questionType,
                      //           //  'score': sliderScore,
                      //           'score': questionData.answerChoices == null
                      //               ? 0
                      //               : questionData.score,
                      //           'answer': sliderValue.value.toStringAsFixed(0)
                      //         });
                      //     pageController.nextPage(
                      //       duration: const Duration(milliseconds: 500),
                      //       curve: Curves.easeInOut,
                      //     );
                      //   }
                      // },

                      child:Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width*0.5,
                          maxHeight: MediaQuery.of(context).size.height*0.1,
                        ),
                        child:widget.isLast ? widget.customLastButton ?? Container(
                          width: MediaQuery.of(context).size.width*0.32,
                          height: MediaQuery.of(context).size.height*0.05,
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
                          child: const Center(
                            child: Text(
                              'Submit Survey',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                            :Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width*0.5,
                            maxHeight: MediaQuery.of(context).size.height*0.1,
                          ),
                          child: widget.customButton ?? Container(
                            width: MediaQuery.of(context).size.width*0.32,
                            height: MediaQuery.of(context).size.height*0.05,
                            decoration:
                            BoxDecoration(
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
                            child: const Center(
                              child: Text(
                                'Next',
                                style:
                                TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

