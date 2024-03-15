import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infosurvey/tree_node.dart';
import 'package:infosurvey/info_survey.dart';
import '../enum.dart';
import '../utils/imageparser.dart';

class SearchItem extends StatefulWidget {
  SearchItem({Key? key, required this.questionData, required this.callBack})
      : super(key: key);
  final TreeNode questionData;
  final Function(String? dropDownData, TreeNode callBackData,bool? fromSkip)? callBack;

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
  String selectedItem = '';
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
        child: Column(
          children: [
            const SizedBox(height: 10,),
            imagePosition == ImagePosition.top &&
                widget.questionData.image != null &&
                widget.questionData.image!.isNotEmpty
                ? ImageParser(data:widget.questionData,
            //  imagePaceHolder: widget.imagePlaceHolder,

            )
                : Container(),
            imagePosition == ImagePosition.top &&
                widget.questionData.image != null &&
                widget.questionData.image!.isNotEmpty ? const SizedBox(height: 10,):const SizedBox(height: 0,),
            Text(
              widget.questionData.question ?? "",
              style:// widget.listTileQuestionStyle ??
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            imagePosition == ImagePosition.middle &&
                widget.questionData.image != null &&
                widget.questionData.image!.isNotEmpty
                ? ImageParser(data:widget.questionData,
           //   imagePaceHolder: widget.imagePlaceHolder,

            )
                : Container(),
            imagePosition == ImagePosition.middle &&
                widget.questionData.image != null &&
                widget.questionData.image!.isNotEmpty ? const SizedBox(height: 10,):const SizedBox(height: 0,),
            widget.questionData.description!.isNotEmpty
                ? Text(
              widget.questionData.description.toString(),
              style: // widget.description ??
                  const TextStyle(fontSize: 12),
            )
                : const SizedBox(
              height: 0,
            ),
            imagePosition == ImagePosition.bottom &&
                widget.questionData.image != null &&
                widget.questionData.image!.isNotEmpty
                ? ImageParser(data:widget.questionData,
            //  imagePaceHolder: widget.imagePlaceHolder,

            )
                : Container(),
            imagePosition == ImagePosition.bottom &&
                widget.questionData.image != null &&
                widget.questionData.image!.isNotEmpty ? const SizedBox(height: 10,):const SizedBox(height: 0,),
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (!_userHasTyped && textEditingValue.text.isEmpty) {
                    return options.take(4);
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
                    selectedItem = selection;
                    _userHasTyped = true;
                  });
                },
                fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController, FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
                  return TextField(
                    controller: fieldTextEditingController,
                    focusNode: fieldFocusNode,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blueGrey.shade100,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      hintText: 'Search',
                    ),
                  );
                },
                optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      child: Container(
                        width: 330,
                        height: 210,
                        decoration: BoxDecoration(
                            color: Colors.blueGrey.shade50,
                            borderRadius: BorderRadius.circular(12)
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.all(10.0),
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final String option = options.elementAt(index);
                            return GestureDetector(
                              onTap: () {
                                onSelected(option);
                              },
                              child: ListTile(
                                title: Text(option),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            const SizedBox(height: 15,),
            if (answerDescription.isNotEmpty)
              Text(answerDescription),
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.questionData.isMandatory == false)
                    GestureDetector(
                      onTap: () {
                        widget.callBack!('', widget.questionData,true);
                      },
                      child: const Center(
                        child: Text(
                          'Skip',
                          style: TextStyle(
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
                        widget.callBack!(selectedItem, widget.questionData,false);
                      }
                    },
                    child: Container(
                      height: 40,
                      width: 120,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}

String answerDescription = '';