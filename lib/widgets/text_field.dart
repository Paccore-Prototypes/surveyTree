import 'dart:collection';

import 'package:flutter/material.dart';

import '../enum.dart';
import '../tree_node.dart';
import '../utils/imageparser.dart';

class Textfield extends StatefulWidget {
  Textfield({
    Key? key,
    required this.questionData,
    required this.isLast,
    this.onSurveyEnd,
    required this.callBack,
    this.imagePlaceHolder,
    this.questionContentAlignment,
    this.textFieldQuestionStyle,
    this.descriptionStyle,
    this.textFieldDecoration,
    this.customButton,
    this.customLastButton,
    this.skipText,
    this.description,
    this.customSkipStyle,
    this.answersMap,
    this.pageIndex
  });

  TreeNode questionData;
  InputDecoration? textFieldDecoration;
  bool isLast;
  TextStyle? description;
  Function(HashMap<String, dynamic>)? onSurveyEnd;
  String? imagePlaceHolder;
  CrossAxisAlignment? questionContentAlignment;
  TextStyle? descriptionStyle;
  Widget? customButton;
  Widget? customLastButton;
  String? skipText;
  TextStyle? customSkipStyle;

  TextStyle? textFieldQuestionStyle;
  HashMap<String, dynamic>? answersMap;
  // Map<int, TextEditingController> textControllers = {};
  final Function(
      String? textanswer, TreeNode callBackData, bool? fromSkip)? callBack;
  int? pageIndex;

  @override
  State<Textfield> createState() => _TextfieldState();
}

TextEditingController nameController = TextEditingController();

class _TextfieldState extends State<Textfield> {
   TextEditingController textController = TextEditingController();
   Map<int, TextEditingController> textControllers = {};


   @override
  Widget build(BuildContext context) {
    //  textControllers.putIfAbsent(index, () => TextEditingController(text: ''));
    // bool isLast = false;
    // ImagePosition imagePosition = ImagePosition.top;
    // if (widget.questionData.imagePosition != null) {
    //   imagePosition = ImagePosition.values.firstWhere(
    //     (e) =>
    //         e.toString().split('.').last == widget.questionData.imagePosition!,
    //     orElse: () => ImagePosition.top,
    //   );
    // }

    return buildTextField(widget.pageIndex!.toInt());

  }

  Widget buildTextField(int index){
    textControllers.putIfAbsent(index, () => TextEditingController(text: ''));
    if(widget.answersMap==null){

    }else{

      if(widget.answersMap!.containsKey(widget.questionData.question)){
        textController.text = widget.answersMap?[widget.questionData.question]['answer']??'';
      }}
    bool isLast = false;
    ImagePosition imagePosition = ImagePosition.top;
    if (widget.questionData.imagePosition != null) {
      imagePosition = ImagePosition.values.firstWhere(
            (e) =>
        e.toString().split('.').last == widget.questionData.imagePosition!,
        orElse: () => ImagePosition.top,
      );
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12),
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
                ? SizedBox(height: MediaQuery.of(context).size.height * 0.01)
                : const SizedBox(
              height: 0,
            ),

            Text(
              widget.questionData.question ?? "",
              style: widget.textFieldQuestionStyle ??
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                widget.questionData.image!.isNotEmpty
                ? SizedBox(height: MediaQuery.of(context).size.height * 0.01)
                : const SizedBox(
              height: 0,
            ),

            widget.questionData.description!.isNotEmpty
                ? Text(
              widget.questionData.description.toString(),
              style: widget.description ?? const TextStyle(fontSize: 12),
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
                ? SizedBox(height: MediaQuery.of(context).size.height * 0.01)
                : const SizedBox(
              height: 0,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            TextField(
              keyboardType: widget.questionData.inputType == 'number'
                  ? TextInputType.number
                  : TextInputType.text,
              decoration: widget.textFieldDecoration ??
                  const InputDecoration(
                    labelText: 'Your Answer',
                  ),
              controller: textController,
              onChanged: (text) {
                text = nameController.text;
                //int score = int.parse(text);
                //radioSelectedValues?.add(score);
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            // currentQuestionIndex == surveyData.length-1
            //    widget.isLastButton ??
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.questionData.isMandatory == false && isLast == false
                        ? GestureDetector(
                      onTap: () {
                        if (widget.questionData != null) {
                          widget.callBack!(
                              '', widget.questionData, false);
                        }
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
                              textController.text, widget.questionData, false);
                        }
                        print('------------------printing the values is ${textController.text}');
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
                                  'submit survey',
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
          ],
        ),
      ),
    );  }

}
