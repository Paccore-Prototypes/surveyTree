import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:infosurvey/widgets/multiplechoice.dart';

import '../enum.dart';
import '../tree_node.dart';
import '../utils/imageparser.dart';

class Radiobutton extends StatefulWidget {
  Radiobutton({
    Key? key,
    required this.data,
    required this.isLast,
    this.onSurveyEnd,
    required this.callBack,
    this.imagePlaceHolder,
    this.questionContentAlignment,
    this.descriptionStyle,
    this.customButton,
    this.customLastButton,
    this.skipText,
    this.radioQuestion,
    this.optionRadioStyle,
    this.activeRadioColor,
    this.description,
    this.customSkipStyle,
    this.answersMap,
    this.radioTextColor,
  });

  TreeNode data;

  Color? radioTextColor;
  TextStyle? radioQuestion;

  InputDecoration? textFieldDecoration;
  TextStyle? checkBoxQuestionStyle;
  Color? activeRadioColor;
  bool isLast;
  TextStyle? description;
  Function(HashMap<String, dynamic>)? onSurveyEnd;
  String? imagePlaceHolder;
  TextStyle? optionRadioStyle;
  CrossAxisAlignment? questionContentAlignment;
  TextStyle? descriptionStyle;
  Widget? customButton;
  Widget? customLastButton;
  String? skipText;
  TextStyle? customSkipStyle;
  HashMap<String, dynamic>? answersMap;
  final Function(String? radioanswer, TreeNode callBackData, bool? fromSkip)?
      callBack;
  @override
  State<Radiobutton> createState() => _RadiobuttonState();
}

String answerdata = '';
bool isLast = false;

class _RadiobuttonState extends State<Radiobutton> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    ImagePosition imagePosition = ImagePosition.top;
    if (widget.data.imagePosition != null) {
      imagePosition = ImagePosition.values.firstWhere(
        (e) => e.toString().split('.').last == widget.data.imagePosition!,
        orElse: () => ImagePosition.top,
      );
    }

    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Column(
                crossAxisAlignment: widget.questionContentAlignment ??
                    CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  imagePosition == ImagePosition.top &&
                          widget.data.image != null &&
                          widget.data.image!.isNotEmpty
                      ? ImageParser(
                          data: widget.data,
                          imagePaceHolder: widget.imagePlaceHolder,
                        )
                      // SizedBox(
                      //   width: MediaQuery.of(context).size.width,
                      //       child:
                      //       Image.network(data.image!,
                      //           height: data.imageHeight?.toDouble(),
                      //           alignment: imagePlace == ImagePlace.left
                      //               ? Alignment.topLeft
                      //               : imagePlace == ImagePlace.right
                      //                   ? Alignment.topRight
                      //                   : Alignment.topCenter),
                      //     )
                      : Container(),

                  // imagePosition == ImagePosition.top &&
                  //         data.image != null &&
                  //         data.image!.isNotEmpty
                  //     ? widget.customSizedBox ??
                  //         const SizedBox(
                  //           height: 10,
                  //         )
                  //     : const SizedBox(),
                  imagePosition == ImagePosition.top &&
                          widget.data.image != null &&
                          widget.data.image!.isNotEmpty
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01)
                      : const SizedBox(height: 0),
                  Text(
                    widget.data.question ?? "",
                    style: widget.radioQuestion ??
                        const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  imagePosition == ImagePosition.middle &&
                          widget.data.image != null &&
                          widget.data.image!.isNotEmpty
                      ? ImageParser(
                          data: widget.data,
                          imagePaceHolder: widget.imagePlaceHolder,
                        )
                      : Container(),
                  imagePosition == ImagePosition.middle &&
                          widget.data.image != null &&
                          widget.data.image!.isNotEmpty
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        )
                      : const SizedBox(
                          height: 0,
                        ),

                  // imagePosition == ImagePosition.middle &&
                  //         data.image != null &&
                  //         data.image!.isNotEmpty
                  //     ? widget.customSizedBox ??
                  //         const SizedBox(
                  //           height: 10,
                  //         )
                  //     : const SizedBox(),
                  widget.data.description!.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.data.description.toString(),
                            style: widget.description ??
                                const TextStyle(fontSize: 12),
                          ),
                        )
                      : const SizedBox(
                          height: 0,
                        ),
                  // widget.customSizedBox ??
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  imagePosition == ImagePosition.bottom &&
                          widget.data.image != null &&
                          widget.data.image!.isNotEmpty
                      ? ImageParser(
                          data: widget.data,
                          imagePaceHolder: widget.imagePlaceHolder,
                        )
                      : Container(),
                  imagePosition == ImagePosition.bottom &&
                          widget.data.image != null &&
                          widget.data.image!.isNotEmpty
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        )
                      : const SizedBox(
                          height: 0,
                        ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Column(
                    children:
                        (widget.data.answerChoices).keys.map<Widget>((answer) {
                      // if (widget.answersMap != null && widget.answersMap!.containsKey(widget.data.question)) {
                      //   if (widget.answersMap![widget.data.question]['answer'] != null &&
                      //       widget.answersMap![widget.data.question]['answer'].isNotEmpty!='') {
                      //     selectedValue= widget.answersMap![widget.data.question]['answer'] ?? '';
                      //   }
                      // }
                      if (widget.data.answerChoices[answer] != null &&
                          widget.data.answerChoices[answer] != '') {
                        if ( widget.answersMap!
                            .containsKey(widget.data.question)) {
                          selectedValue =
                              widget.answersMap![widget.data.question]
                                      ['answer'] ??
                                  '';
                        }
                      }

                      return RadioListTile(
                          title: Text(
                            answer,
                            style: widget.optionRadioStyle ??
                                TextStyle(
                                    color: selectedValue == answer
                                        ? widget.radioTextColor ??
                                            Colors.deepPurple
                                        : Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16),
                          ),
                          value: answer,
                          activeColor:
                              widget.activeRadioColor ?? Colors.deepPurple,
                          groupValue: selectedValue?.isNotEmpty ?? false
                              ? selectedValue
                              : null,
                          // groupValue: selectedValue,
                          // groupValue: (answersMap.containsKey(data.question) && answersMap.containsKey(data.answerChoices)) ? null : selectedValue,
                          onChanged: (selectedAnswer) {
                            setState(() {
                              selectedValue = selectedAnswer;
                              answer = selectedAnswer!;
                            });
                            widget.answersMap![widget.data.question] = {
                              'answer': selectedAnswer,
                            };
                          });
                    }).toList(),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.data.isMandatory == false && isLast == false
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    FocusScope.of(context).unfocus();
                                  });
                                  widget.callBack!('', widget.data, true);
                                },
                                /* child:
                    Container(
                      width: 120,
                      height:  40,
                      decoration: BoxDecoration(
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
                                    style: widget.customSkipStyle ??
                                        const TextStyle(
                                            color: Colors.blue,
                                            fontSize: 16,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: Colors.blue,
                                            fontStyle: FontStyle.italic),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        GestureDetector(
                          onTap: () {
                            if (widget.data != null) {
                              widget.callBack!(

                                  selectedValue, widget.data, false);
                            }
                          },
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.5,
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.1,
                            ),
                            child: widget.isLast
                                ? widget.customLastButton ??
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.32,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
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
                                          'Next',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    )
                                : Container(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.5,
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                    ),
                                    child: widget.customButton ??
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.32,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.05,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.teal,
                                                Colors.teal.shade300,
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20),
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
                                              style: TextStyle(
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
                ])));
  }
}
