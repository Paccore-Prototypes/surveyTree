
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:infosurvey/tree_node.dart';
import 'package:infosurvey/info_survey.dart';
import '../enum.dart';
import '../utils/imageparser.dart';

class DropDown extends StatefulWidget {
  DropDown({Key? key, required this.questionData,
    required this.callBack,
    this.dropDownHeight,
    this.dropDownColor,
    this.dropDownDecoration,
    this.dropDownWidth,
    required this.isLast,
    this.imagePlaceHolder,
    this.questionContentAlignment,
    this.dropDownQuestionStyle,
    this.descriptionStyle,
    this.customButton,
    this.customLastButton,
    this.skipText,
    this.customSkipStyle,this.answerMap})
      : super(key: key);
  final TreeNode questionData;
  bool isLast = false;
 double?dropDownHeight;
  double?dropDownWidth;
  BoxDecoration?dropDownDecoration;
  String? imagePlaceHolder;
  Color? dropDownColor;
  TextStyle? dropDownQuestionStyle;
  TextStyle? descriptionStyle;
  Widget? customButton;
  Widget? customLastButton;
  String? skipText;
  CrossAxisAlignment? questionContentAlignment;
  TextStyle? customSkipStyle;
  HashMap<String, dynamic>? answerMap;
  final Function(String? dropDownData, TreeNode callBackData,bool? fromSkip)? callBack;

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  PageController pageController = PageController();
  TreeNode? data;
  late TextEditingController _searchController;
  late List<String> _filteredItems;
  String? dropdownValue;
  late FocusNode _focusNode;
  String currentItemReference = '';
  final TextEditingController _textEditingController = TextEditingController();

  bool _userHasTyped = false;

  @override
  void initState() {
    super.initState();
    data = widget.questionData;
    _searchController = TextEditingController();
    _filteredItems = widget.questionData.answerChoices.keys.toList();
    dropdownValue = _filteredItems.isNotEmpty ? _filteredItems.first : null;
    _textEditingController.addListener(() {
      setState(() {
        _userHasTyped = _textEditingController.text.isNotEmpty;
      });
    });
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {


    if(widget.answerMap!.containsKey(widget.questionData.question)){
      if(widget.answerMap?[widget.questionData.question]['answer']!=null && widget.answerMap?[widget.questionData.question]['answer']!=''){
        if(widget.questionData.isMandatory==true || widget.questionData.isMandatory == false){
          dropdownValue = widget.answerMap?[widget.questionData.question]['answer'] ?? '';
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
    final List<String> options = widget.questionData.answerChoices.keys.toList();

    return Theme(
      data: ThemeData(
        primaryColor: Colors.white
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment:   widget.questionContentAlignment ?? CrossAxisAlignment.end,
              children: [
                 SizedBox(height: MediaQuery.of(context).size.height*0.01),
                imagePosition == ImagePosition.top &&
                    widget.questionData.image != null &&
                    widget.questionData.image!.isNotEmpty
                    ? ImageParser(data:widget.questionData,
                  imagePaceHolder: widget.imagePlaceHolder,

                )
                    : Container(),
                imagePosition == ImagePosition.top &&
                    widget.questionData.image != null &&
                    widget.questionData.image!.isNotEmpty ? SizedBox(height: MediaQuery.of(context).size.height*0.01,):const SizedBox(height: 0,),
                Text(
                  widget.questionData.question ?? "",
                  style: widget.dropDownQuestionStyle ??
                      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                 SizedBox(
                  height: MediaQuery.of(context).size.height*0.01,
                ),
                imagePosition == ImagePosition.middle &&
                    widget.questionData.image != null &&
                    widget.questionData.image!.isNotEmpty
                    ? ImageParser(data:widget.questionData,
                  imagePaceHolder: widget.imagePlaceHolder,

                )
                    : Container(),
                imagePosition == ImagePosition.middle &&
                    widget.questionData.image != null &&
                    widget.questionData.image!.isNotEmpty ?  SizedBox(height:MediaQuery.of(context).size.height*0.01,):const SizedBox(height: 0,),
                widget.questionData.description!.isNotEmpty
                    ? Text(
                  widget.questionData.description.toString(),
                  style: widget.descriptionStyle ??
                      const TextStyle(fontSize: 12),
                )
                    : const SizedBox(
                  height: 0,
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
                 SizedBox(height: MediaQuery.of(context).size.height*0.01,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    height: widget.dropDownHeight ?? MediaQuery.of(context).size.height * 0.06,
                    width: widget.dropDownWidth ?? MediaQuery.of(context).size.width * 0.64,
                    decoration: widget.dropDownDecoration ?? BoxDecoration(
                        border: Border.all(color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: DropdownButtonFormField<String>(borderRadius: BorderRadius.circular(12),
                          value: dropdownValue,dropdownColor: widget.dropDownColor ?? Colors.white,
                          iconSize: 30,
                          onChanged: (String? value) {
                            setState(() {
                              dropdownValue = value;
                            });
                          },
                          items: _filteredItems.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: const InputDecoration.collapsed(
                              hintText: ''
                          ),
                        ),
                      ),
                    ),
                  ),
                ),





                 SizedBox(height:MediaQuery.of(context).size.height*0.03,),
                if (answerDescription.isNotEmpty)
                  Text(answerDescription),
                 SizedBox(height: MediaQuery.of(context).size.height*0.03),
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
                            widget.callBack!(dropdownValue, widget.questionData,false);
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
          ),
        ),
      ),
    );
  }
}

String answerDescription = '';
