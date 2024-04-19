import 'dart:collection';

import 'package:flutter/material.dart';

import '../enum.dart';
import '../tree_node.dart';
import '../utils/imageparser.dart';

class Listbutton extends StatefulWidget {
 Listbutton({
    Key? key,
    required this.questionData,
   this.onListTaleTapnavigation = false,
    required this.isLast,
    this.onSurveyEnd,

   this.tileListColor,
    required this.callBack,
    this.imagePlaceHolder,
    this.questionContentAlignment,
    this.descriptionStyle,

    this.customButton,
    this.customLastButton,
    this.skipText,
    this.description,
   this.listTileShape,
    this.customSkipStyle,
   this.listTileQuestionStyle,
    this.answersMap,
   this.answerDescriptionStyle,

  });

  TreeNode questionData;
  Color?tileListColor;
  TextStyle?listTileQuestionStyle;
  TextStyle?answerDescriptionStyle;
  bool isLast;
 bool onListTaleTapnavigation;
  TextStyle? description;

  Function(HashMap<String, dynamic>)? onSurveyEnd;
  String? imagePlaceHolder;

  CrossAxisAlignment? questionContentAlignment;
  TextStyle? descriptionStyle;
  Widget? customButton;
  Widget? customLastButton;
  String? skipText;
  TextStyle? customSkipStyle;
 RoundedRectangleBorder? listTileShape;
  HashMap<String, dynamic>? answersMap;

// Map<int, TextEditingController> textControllers = {};
  final Function(
      dynamic listtile, TreeNode callBackData, bool? fromSkip)? callBack;

  @override
  State<Listbutton> createState() => _ListState();
}

class _ListState extends State<Listbutton> {
  @override
  String answerdata = '';
  bool isLast = false;
  List<String> answers = [];
  String answerDescription = '';
  Widget buildAnswerWidget(String answer, TreeNode questionData) {
    bool isSelected = answerdata== answer;

    String imageOption =
        questionData.answerChoices[answer][0]["imageOption"] ?? '';
    if (questionData.isMultiListSelects == false) {
      return Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          ListTile(
            title: Center(
                child: questionData.listGridType == true
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    imageOption.isNotEmpty
                        ? Image.network(
                      imageOption,
                      width:
                      MediaQuery.of(context).size.width * 0.17,
                      height:
                      MediaQuery.of(context).size.width * 0.17,
                    )
                        : Container(),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1),
                    Center(child: Text(answer)),
                  ],
                )
                    : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    imageOption.isNotEmpty
                        ? Image.network(
                      imageOption,
                      width:
                      MediaQuery.of(context).size.width * 0.1,
                      height:
                      MediaQuery.of(context).size.width * 0.1,
                    )
                        : Container(),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1),
                    Center(child: Text(answer)),
                  ],
                )),
            // selectedTileColor: widget.tileListColor ?? Colors.green,
            tileColor: isSelected
                ? widget.tileListColor ?? Colors.blueGrey.shade300
                : Colors.blueGrey.shade50,
            selectedTileColor: widget.tileListColor ?? Colors.blueGrey.shade300,

            shape: isSelected
                ? widget.listTileShape ??
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Colors.black),
                )
                : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.blueGrey.shade200),
            ),
            selected: isSelected,
            onTap: () {
    setState(() {
    if (answerdata != answer) {
    answerdata = answer;
    if (questionData.answerChoices[answer][0]
    ['answerDescription'] !=
    null) {
    answerDescription = questionData.answerChoices[answer][0]
    ['answerDescription'];
    }
    } else {
    //    answerdata = '';
    //   answerDescription = '';
    }
    });

    // setState(() {
    //   if (!answers.contains(answer)) {
    //     answers.add(answer);
    //     answerDescription = answerDescription.isEmpty
    //         ? questionData
    //         .answerChoices[answer][0]['answerDescription'] ?? ''
    //         : '';
    //   } else {
    //     answers.remove(answer);
    //
    //     answerDescription = '';
    //   }
    // });

    if (widget.onListTaleTapnavigation) {
     widget.callBack!=null&& widget.callBack!(
          answers, widget.questionData, false);
    }
            },
          ),
        ],
      );
    } else {
      if (questionData.answerChoices[answer] == null) {
        return ListTile(
          shape: isSelected
              ? widget.listTileShape ??
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Colors.black),
              )
              : RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.blueGrey.shade200),
          ),
          title: Row(
            children: [
              imageOption.isNotEmpty ? Image.network(imageOption) : Container(),
              Text(answer),
            ],
          ),
          contentPadding: EdgeInsets.all(12),
          tileColor: isSelected
              ? widget.tileListColor ?? Colors.blueGrey.shade200
              : Colors.blueGrey.shade50,
          onTap: () {
    setState(() {
    if (answerdata == answer) {
    // answerDescription = answerDescription.isEmpty ? questionData
    //     .answerChoices[answer][0]['answerDescription'] : '';
    } else {
    answerDescription = questionData.answerChoices[answer][0]
    ['answerDescription'] ??
    '';
    answerdata = answer;

    }

    });
    if (widget.onListTaleTapnavigation) {
    widget.callBack!(
    answer, widget.questionData, false);
    }
    }
        );
      } else {
        return Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            SizedBox(
              height: questionData.listGridType == true ? 92 : 60,
              child: ListTile(
                title: Center(
                    child: questionData.listGridType == true
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        imageOption.isNotEmpty
                            ? Image.network(
                          imageOption,
                          width: MediaQuery.of(context).size.width *
                              0.16,
                          height:
                          MediaQuery.of(context).size.width *
                              0.16,
                        )
                            : Container(),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.01,
                        ),
                        Center(child: Text(answer)),
                      ],
                    )
                        : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        imageOption.isNotEmpty
                            ? Image.network(
                          imageOption,
                          width: MediaQuery.of(context).size.width *
                              0.16,
                          height:
                          MediaQuery.of(context).size.height *
                              0.16,
                        )
                            : Container(),
                        SizedBox(
                            width:
                            MediaQuery.of(context).size.width * 0.01),
                        Center(child: Text(answer)),
                      ],
                    )),
                // selectedTileColor: widget.tileListColor ?? Colors.green,
                tileColor: isSelected
                    ? widget.tileListColor ?? Colors.blueGrey.shade300
                    : Colors.blueGrey.shade50,
                selectedTileColor:
                widget.tileListColor ?? Colors.blueGrey.shade300,

                shape: isSelected
                    ? widget.listTileShape ??
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.black),
                    )
                    : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.blueGrey.shade200),
                ),
                selected: answers.contains(answer),
                onTap: () {
                  setState(() {
                    if (!answers.contains(answer)) {
                      answers.add(answer);
                      // answerDescription = answerDescription.isEmpty ? questionData.answerChoices[answer][0]['answerDescription'] ?? ''
                      //     : '';
                    } else {
                      answers.remove(answer);

                      answerDescription = '';
                    }

                  });

                  if (widget.onListTaleTapnavigation) {
                    widget.callBack!(
                        answers, widget.questionData, false);
                  }

                },

              ),
            ),
          ],
        );
      }
    }
  }
  Widget build(BuildContext context) {
    Set<String> selectedAnswers = {};

    if (widget.answersMap!.containsKey(widget.questionData.question)) {
      if (widget.answersMap![widget.questionData.question]['answer'] != null &&
          widget.answersMap![widget.questionData.question]['answer'].isNotEmpty) {
        if (widget.questionData.isMultiListSelects == true) {
          answers = widget.answersMap![widget.questionData.question]['answer'] ?? '';
        } else {
          if (answerdata == '') {
            answerdata = widget.answersMap![widget.questionData.question]['answer'] ?? '';
          }
        }
      }
    }

    if (widget.answersMap!=null&&widget.answersMap!.containsKey(widget.questionData.question)) {
      if (widget.answersMap![widget.questionData.question]['optionDescription'] != null &&
          widget.answersMap![widget.questionData.question]['optionDescription'] != '') {
        if (answerDescription == '') {
          answerDescription =
              widget.answersMap![widget.questionData.question]['optionDescription'] ?? '';
        }
      }
    }
    ImagePosition imagePosition = ImagePosition.top;
    if (widget.questionData.imagePosition != null) {
      imagePosition = ImagePosition.values.firstWhere(
        (e) => e.toString().split('.').last == widget.questionData.imagePosition!,
        orElse: () => ImagePosition.top,
      );
    }

    return Card(
        elevation: 0,
        color: Colors.transparent,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Column(
              crossAxisAlignment:
                  widget.questionContentAlignment ?? CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                imagePosition == ImagePosition.top &&
                    widget.questionData.image != null &&
                    widget.questionData.image!.isNotEmpty
                    ? ImageParser(
                        data: widget.questionData,
                        imagePaceHolder: widget.imagePlaceHolder,
                      )
                    : Container(),
                imagePosition == ImagePosition.top &&
                    widget.questionData.image != null &&
                    widget.questionData.image!.isNotEmpty
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01)
                    : SizedBox(
                        height: 0,
                      ),
                Text(
                  widget.questionData.question ?? "",
                  style: widget.listTileQuestionStyle ??
                      const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                imagePosition == ImagePosition.middle &&
                        widget.questionData.image != null &&
                    widget.questionData.image!.isNotEmpty
                    ? ImageParser(
                        data: widget.questionData,
                        imagePaceHolder: widget.imagePlaceHolder,
                      )
                    : Container(),
                imagePosition == ImagePosition.middle &&
                    widget.questionData.image != null &&
                    widget. questionData.image!.isNotEmpty
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01)
                    : const SizedBox(height: 0),
                widget.questionData.description!.isNotEmpty
                    ? Text(
                  widget.questionData.description.toString(),
                        style:
                            widget.description ?? const TextStyle(fontSize: 12),
                      )
                    : const SizedBox(
                        height: 0,
                      ),
                imagePosition == ImagePosition.bottom &&
                    widget.questionData.image != null &&
                    widget.questionData.image!.isNotEmpty
                    ? ImageParser(
                        data: widget.questionData,
                        imagePaceHolder: widget.imagePlaceHolder,
                      )
                    : Container(),
                imagePosition == ImagePosition.bottom &&
                    widget.questionData.image != null &&
                    widget.questionData.image!.isNotEmpty
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.001,
                      )
                    : const SizedBox(
                        height: 0,
                      ),
                //  SizedBox(height: MediaQuery.of(context).size.height*0.01),

                widget.questionData.listGridType == true
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 11,
                          childAspectRatio: 3 / 2.2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            for (var answer
                                in (widget.questionData.answerChoices).keys)
                              buildAnswerWidget(answer, widget.questionData)
                          ],
                        ),
                      )
                    : Column(
                        children: (widget.questionData.answerChoices)
                            .keys
                            .map<Widget>((answer) {
                          return buildAnswerWidget(answer, widget.questionData);
                        }).toList(),
                      ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),

                answerDescription.isNotEmpty
                    ? Text(
                        answerDescription,
                        style:
                            widget.answerDescriptionStyle ?? const TextStyle(),
                      )
                    : Container(),

                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                        widget.questionData.isMandatory == false && isLast == false
                            ?    GestureDetector(
                          onTap: () {
                            setState(() {
                              FocusScope.of(context).unfocus();
                            });
                            widget.callBack!('', widget.questionData,true);
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
                              widget.callBack!(
                                widget.questionData.isMultiListSelects == true ? answers : answerdata,
                                   widget.questionData, false);
                            }
                          },
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.5,
                              maxHeight: MediaQuery.of(context).size.height * 0.1,
                            ),
                            child: widget.isLast
                                ? widget.customLastButton ??
                                Container(
                                  width:
                                  MediaQuery.of(context).size.width * 0.32,
                                  height:
                                  MediaQuery.of(context).size.height * 0.05,
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
                                : Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                MediaQuery.of(context).size.width * 0.5,
                                maxHeight:
                                MediaQuery.of(context).size.height * 0.1,
                              ),
                              child: widget.customButton ??
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
                                  ),
                            ),
                          ),
                        ),
                      ]),
                )
              ]
            ),
          ),
        ));
  }
}
