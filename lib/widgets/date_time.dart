import 'dart:collection';

import 'package:flutter/material.dart';

import '../enum.dart';
import '../tree_node.dart';
import '../utils/imageparser.dart';
class Datetime extends StatefulWidget {
 Datetime({Key? key, required this.questionData,
    required this.callBack,
 this.imagePlaceHolder,
   this.dateTimeButton,
this.dateTimeQuestionStyle,
    required this.isLast,
    this.questionContentAlignment,
this.description,
    this.descriptionStyle,
    this.customButton,
    this.customLastButton,
    this.skipText,
    this.customSkipStyle,this.answerMap})
      : super(key: key);
  final TreeNode questionData;
  bool isLast = false;
 Widget? dateTimeButton;
 TextStyle? description;
  String? imagePlaceHolder;
 TextStyle?dateTimeQuestionStyle;
  TextStyle? descriptionStyle;
  Widget? customButton;
  Widget? customLastButton;
  String? skipText;
  CrossAxisAlignment? questionContentAlignment;
  TextStyle? customSkipStyle;
  HashMap<String, dynamic>? answerMap;
  final Function(String? selectedDate, TreeNode callBackData,bool? fromSkip)? callBack;

  @override
  State<Datetime> createState() => _DatetimeState();
}
DateTime selectedDate = DateTime.now();


class _DatetimeState extends State<Datetime> {
  @override
  Widget build(BuildContext context) {
    ImagePosition imagePosition = ImagePosition.top;
    if (widget.questionData.imagePosition != null) {
      imagePosition = ImagePosition.values.firstWhere(
            (e) => e.toString().split('.').last == widget.questionData.imagePosition!,
        orElse: () => ImagePosition.top,
      );
    }
    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2015, 8),
          lastDate: DateTime(2101));
      if (picked != null && picked != selectedDate) {
        setState(() {
          selectedDate = picked;
        });
      }
    }
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: Column(
        crossAxisAlignment:
        widget.questionContentAlignment ?? CrossAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          imagePosition == ImagePosition.top &&
              widget.questionData.image != null &&
             widget. questionData.image!.isNotEmpty
              ? ImageParser(
            data: widget.questionData,
            imagePaceHolder: widget.imagePlaceHolder,
          )
              : Container(),
          imagePosition == ImagePosition.top &&
              widget.questionData.image != null &&
             widget. questionData.image!.isNotEmpty
              ? SizedBox(height: MediaQuery.of(context).size.height * 0.01)
              : const SizedBox(
            height: 0,
          ),
          Text(
            widget.questionData.question ?? "",
            style: widget.dateTimeQuestionStyle ??
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          imagePosition == ImagePosition.middle &&
              widget.questionData.image != null &&
             widget. questionData.image!.isNotEmpty
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

          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          imagePosition == ImagePosition.bottom &&
              widget.questionData.image != null &&
             widget. questionData.image!.isNotEmpty
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
          const SizedBox(height: 10),

          GestureDetector(
            onTap: () => _selectDate(context),
            child: widget.dateTimeButton ??
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.05,
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
                      'Select Date/Time',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Text(
            '$selectedDate',
            //  '00:00:00',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple.shade400),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          //   widget.isLastButton ??
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.questionData.isMandatory == false && widget.isLast == false)
                  GestureDetector(
                    onTap: () {

                      widget.callBack!('', widget.questionData,true);

                    },
                    child: Center(
                      child: Text(
                        widget.skipText ?? 'Skip',
                        style: widget.customSkipStyle ?? const TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.blue,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox(),
                GestureDetector(
                  onTap: () {

                    if (widget.questionData != null) {
                      widget.callBack!(selectedDate.toString(), widget.questionData,false);
                    }
                  },
                  child: Container(
                    constraints: widget.isLast
                        ? BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.5,
                      maxHeight: MediaQuery.of(context).size.height * 0.1,
                    )
                        : BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.5,
                      maxHeight: MediaQuery.of(context).size.height * 0.1,
                    ),
                    child: widget.isLast
                        ? widget.customLastButton ??
                        Container(
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
                        :widget.customButton ?? Container(
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
                )],
            ),
          ),
        ],
      ),



    );
  }
}
