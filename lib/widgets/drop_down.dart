import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infosurvey/tree_node.dart';
import 'package:infosurvey/info_survey.dart';
import '../enum.dart';
import '../utils/imageparser.dart';

class DropDown extends StatefulWidget {
  DropDown({Key? key, required this.questionData, required this.callBack})
      : super(key: key);
  final TreeNode questionData;
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

  @override
  void initState() {
    super.initState();
    data = widget.questionData;
    _searchController = TextEditingController();
    _filteredItems = widget.questionData.answerChoices.keys.toList();
    dropdownValue = _filteredItems.isNotEmpty ? null : null;
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10,),
            if (imagePosition == ImagePosition.top &&
                widget.questionData.image != null &&
                widget.questionData.image!.isNotEmpty)
              ImageParser(data: widget.questionData),
            if (imagePosition == ImagePosition.top &&
                widget.questionData.image != null &&
                widget.questionData.image!.isNotEmpty)
              const SizedBox(height: 10,),
            Text(
              widget.questionData.question ?? "",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10,),
            if (widget.questionData.description!.isNotEmpty)
              Text(
                widget.questionData.description.toString(),
                style: const TextStyle(fontSize: 12),
              )
            else
              const SizedBox(height: 0,),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: 100,
                      child: TextField(cursorOpacityAnimates: true,
                        controller: _searchController,
                        focusNode: _focusNode,
                        onChanged: _filterItems,
                        onTap: () {
                          _focusNode.requestFocus();
                          if (_filteredItems.isNotEmpty) {
                            _openDropdown();
                          }
                        },                          decoration: const InputDecoration.collapsed(
                            hintText: '  Search'
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: DropdownButtonFormField<String>(
                        value: dropdownValue,
                        iconSize: 25,
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
                  ],
                ),
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

                          widget.callBack!(dropdownValue, data!,true);

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
                      if (data != null) {
                        widget.callBack!(dropdownValue, data!,false);
                      }
                    },
                    child: Container(
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


  void _openDropdown() {
    setState(() {
      if (_filteredItems.isNotEmpty) {
        dropdownValue = _filteredItems.first;
      }
    });
  }

  void _filterItems(String keyword) {
    setState(() {
      _filteredItems = widget.questionData.answerChoices.keys
          .where((item) => item.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
      dropdownValue = _filteredItems.isNotEmpty ? _filteredItems.first : null;
      if (_filteredItems.isNotEmpty) {
        _openDropdown();
      }
    });
  }
}

String answerDescription = '';
