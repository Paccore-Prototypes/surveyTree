import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infosurvey/tree_node.dart';
import 'package:infosurvey/info_survey.dart';
import '../enum.dart';
import '../utils/imageparser.dart';

class SearchItem extends StatefulWidget {
  SearchItem({Key? key, required this.questionData,
    required this.callBack,required this.isLast,
    this.description,this.searchItemQuestionStyle,
    this.imagePlaceHolder,
    this.questionContentAlignment,
    this.customButton,
    this.customLastButton,
    this.skipText,
    this.customSkipStyle,this.answerMap})
      : super(key: key);
  final TreeNode questionData;
  bool isLast = false;
  String? imagePlaceHolder;
  TextStyle? searchItemQuestionStyle;
  TextStyle? description;
  Widget? customButton;
  Widget? customLastButton;
  String? skipText;
  CrossAxisAlignment? questionContentAlignment;
  TextStyle? customSkipStyle;
  HashMap<String, dynamic>? answerMap;
  final Function(List<String>? dropDownData, TreeNode callBackData,bool? fromSkip)? callBack;

  @override
  State<SearchItem> createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {
  PageController pageController = PageController();
  TreeNode? data;
  late TextEditingController _searchController;
  String? dropdownValue;
  late FocusNode _focusNode;
  String currentItemReference = '';
  List<String> selectedItem = [];
  final TextEditingController _textEditingController = TextEditingController();

  bool _userHasTyped = false;

  @override
  void initState() {
    super.initState();
    data = widget.questionData;
    _searchController = TextEditingController();
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

print('-------------------having the answersmap data ${widget.answerMap}');


if(widget.answerMap!.containsKey(widget.questionData.question)){
  if(widget.answerMap?[widget.questionData.question]['answer']!=null && widget.answerMap?[widget.questionData.question]['answer']!=''){
    selectedItem = widget.answerMap?[widget.questionData.question]['answer'] ?? '';
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

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 12,right: 12),
          child: Column(
            crossAxisAlignment:   widget.questionContentAlignment ?? CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10,),
              imagePosition == ImagePosition.top &&
                  widget.questionData.image != null &&
                  widget.questionData.image!.isNotEmpty
                  ? ImageParser(data:widget.questionData,
                imagePaceHolder: widget.imagePlaceHolder,


              )
                  : Container(),
              imagePosition == ImagePosition.top &&
                  widget.questionData.image != null &&
                  widget.questionData.image!.isNotEmpty ? const SizedBox(height: 10,):const SizedBox(height: 0,),
              Text(
                widget.questionData.question ?? "",
                style: widget.searchItemQuestionStyle ??
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
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
                  widget.questionData.image!.isNotEmpty ? const SizedBox(height: 10,):const SizedBox(height: 0,),
              widget.questionData.description!.isNotEmpty
                  ? Text(
                widget.questionData.description.toString(),
                style:  widget.description ??
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
                  widget.questionData.image!.isNotEmpty ? const SizedBox(height: 10,):const SizedBox(height: 0,),
              const SizedBox(height: 10),

              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (!_userHasTyped && textEditingValue.text.isEmpty) {
                    return options.take(options.length);
                  } else if (textEditingValue.text.isEmpty) {
                    return const Iterable<String>.empty();
                  } else {
                    return options.where((String option) {
                      return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                    });
                  }
                },
                onSelected: (String selection) {
                  setState(() {
                    selectedItem.add(selection);
                  //  selectedItem = selection;
                    _userHasTyped = true;
                  });
                },
                fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController, FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
                  return TextField(
                    controller: fieldTextEditingController,
                    focusNode: fieldFocusNode,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blueGrey.shade50,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey.shade200),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      hintText: 'Search..',
                    ),
                  );
                },
                optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: MediaQuery.sizeOf(context).width/1.05,
                      height: options.length * 50.0,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(10.0),
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final String option = options.elementAt(index);
                          final bool isSelected = selectedItem.contains(option);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedItem.remove(option);
                                } else {
                                  selectedItem.add(option);
                                }
                              });
                            },

                            //  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                              child: Material(
                                child: ListTile(
                                  title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(option,),
                                        Icon(isSelected ? Icons.check_box : Icons.check_box_outline_blank)
                                      ],
                                    ),
                                ),
                              ),

                          );
                        },
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 10),
            //  IngredientChip(items: [selectedItem.toString()],),

              const SizedBox(height: 10),
              // ListView.builder(
              //   shrinkWrap: true,
              //   itemCount: selectedItem.length,
              //   itemBuilder: (BuildContext context, int index) {
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                child: Wrap(
                  spacing: 10, // Spacing between items
                  children: List.generate(
                    selectedItem.length,
                        (index) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.blueGrey.shade100,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Text(selectedItem[index]),
                    ),
                  ),
                ),
              ),

              //  },
              //),
              const SizedBox(height: 15),


              const SizedBox(height: 15,),
              if (answerDescription.isNotEmpty)
                Text(answerDescription),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (widget.questionData.isMandatory == false && widget.isLast == false)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            FocusScope.of(context).unfocus();
                          });
                          widget.callBack!([], widget.questionData,true);
                        },
                        child: Center(
                          child: Text(


                          widget.skipText ??  'Skip',

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
                        setState(() {
                          FocusScope.of(context).unfocus();
                        });
                        if (widget.questionData != null) {
                          widget.callBack!(selectedItem, widget.questionData,false);
                        }
                      },
          child:Container(
    constraints: BoxConstraints(
    maxWidth: MediaQuery.of(context).size.width*0.5,
    maxHeight: MediaQuery.of(context).size.height*0.1,
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
                                'Submit',
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
                          child:widget.customButton ?? Container(
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
                        child: Center(
                          child: Text(
                            widget.isLast ? 'Submit':'Next',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),

                    ))],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String answerDescription = '';

class IngredientChip extends StatelessWidget {
  final List<String> items;

  const IngredientChip({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: List.generate(
          items.length,
              (index) => Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: const Color(0xffC9DADC).withOpacity(0.35),
            ),
            padding: const EdgeInsets.all(8),
            child: Text(items[index]),
          ),
        ),
      ),
    );
  }
}
