

import 'package:flutter/material.dart';
import 'package:infosurvey_example/tree_model.dart';


class SurveyPage extends StatefulWidget {
  final List<Question> questions;
  Widget? customWidget;

  SurveyPage({required this.questions,this.customWidget});

  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  List<Question> _questionStack = [];
  Map<int, List<String>> _selectedAnswers = {};
  int _currentIndexInJson = 0;
  List<String> selectedItem = [];
  int? _lastMainQuestionIndex;
  List<Question> _lastSubQuestions = [];

  final TextEditingController _textEditingController = TextEditingController();

  bool _userHasTyped = false;

  @override
  void initState() {
    super.initState();
    _loadNextBaseQuestion();
    _textEditingController.addListener(() {
      setState(() {
        _userHasTyped = _textEditingController.text.isNotEmpty;
      });
    });
  }

  void _loadNextBaseQuestion() {
    // Check if the current index has reached the length of the questions
    if (_currentIndexInJson < widget.questions.length) {
      setState(() {
        // Only add the question if it's not already in the stack
        if (!_questionStack.contains(widget.questions[_currentIndexInJson])) {
          _questionStack.add(widget.questions[_currentIndexInJson]);
        }
        _currentIndexInJson++;
        print('printing the current index----base-----------------$_currentIndexInJson');
      });
    }
  }

  void _onAnswerSubmitted(String answer) {
    _loadNextBaseQuestion();
  }

  void _addNodes(int questionIndex, String selectedAnswer, List<Question> nextQuestions) {
    setState(() {
      _selectedAnswers[questionIndex] = [selectedAnswer];
      _lastMainQuestionIndex = questionIndex;
      _lastSubQuestions = nextQuestions;

      // Check if there are sub-questions
      if (nextQuestions.isNotEmpty) {
        // Add sub-questions to the stack
        _questionStack.addAll(nextQuestions);
      } else {
        // No sub-questions, so load the next base question
        _loadNextBaseQuestion();
      }
    });
  }

  void _removeNodes(int questionIndex) {
    setState(() {
      // Remove any questions after the current question index
      if (questionIndex < _questionStack.length - 1) {
        _questionStack.removeRange(questionIndex + 1, _questionStack.length);
        _selectedAnswers.removeWhere((key, _) => key > questionIndex);

        // Ensure that _currentIndexInJson is updated properly
        if (_questionStack.isNotEmpty) {
          // Find the index of the last valid base question
          final lastBaseQuestion = _questionStack.lastWhere(
                (question) => widget.questions.contains(question),
            //orElse: () => null,
          );
          if (lastBaseQuestion != null) {
            _currentIndexInJson = widget.questions.indexOf(lastBaseQuestion) + 1;
          }
        } else {
          _currentIndexInJson = 0; // Reset to start if no valid questions are left
        }

        // Print for debugging to verify correct index
        print('Updated current index-----------------------: $_currentIndexInJson');
      }
    });
  }



  void _onAnswerSelected(int questionIndex, String selectedAnswer, List<Question> nextQuestions) {
    setState(() {
      // Remove nodes only for sub-questions, not the main sequence
      if (nextQuestions.isNotEmpty || questionIndex == _lastMainQuestionIndex) {
        _removeNodes(questionIndex);
      }
      _addNodes(questionIndex, selectedAnswer, nextQuestions);
    });
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Survey")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            for (int i = 0; i < _questionStack.length; i++)
              buildQuestionWidget(_questionStack[i], i),
          ],
        ),
      ),
    );
  }

  Widget buildQuestionWidget(Question question, int questionIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question.question.toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        if (question.image != null) Image.network(question.image!),
        const SizedBox(height: 10),
        buildInputWidget(question, questionIndex),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget buildSearchBar(Question question){
    final List<String> options = question.answerChoices!.keys.toList();

    return Column(
      children: [
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

            return SizedBox(
              width: 330,
              child: TextFormField(
                style: const TextStyle(height: 2,),
                controller: fieldTextEditingController,
                focusNode: fieldFocusNode,
                onFieldSubmitted: (value) {
                  _onAnswerSubmitted(value);
                },
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
              ),
            );
          },
          optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: MediaQuery.sizeOf(context).width/1.15,
                height: options.length * 70.0,
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
                      child: Material(color: Colors.blueGrey.shade100,
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
        const SizedBox(height: 20,),
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
      ],
    );

  }

  Widget buildTextField(int questionIndex) {
    // Use the stored value from _selectedAnswers for the corresponding question index
    String savedAnswer = _selectedAnswers[questionIndex]?.first ?? '';

    // Initialize the TextEditingController with the saved value
    TextEditingController _controller = TextEditingController(text: savedAnswer);

    return TextFormField(
      controller: _controller,
      decoration: const InputDecoration(
        hintText: 'Enter value',
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        // Save the answer whenever the text changes
        setState(() {
          _selectedAnswers[questionIndex] = [value];
        });
      },
      onFieldSubmitted: (value) {
        _onAnswerSubmitted(value);
      },
    );
  }


  Widget buildListTile(Question question, int questionIndex){
    return Column(
      children: question.answerChoices!.entries.map((entry) {
        bool isSelected = _selectedAnswers[questionIndex]?.contains(entry.key) ?? false;
        return ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: isSelected ? Colors.green.shade300:Colors.transparent),
          ),
          title: Text(entry.key,style: TextStyle(color: isSelected ? Colors.green.shade800 : Colors.black),),
          trailing: isSelected ? Image.asset('assets/images/clipart342615.png',scale: 15,):null,
          onTap: () {
            _onAnswerSelected(questionIndex, entry.key, entry.value);
          },
        );
      }).toList(),
    );
  }

  Widget buildDropDown(Question question, int questionIndex){
    return Container(
      height: 60,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: InputDecorator(
          decoration: const InputDecoration(
            hintText: 'Select a value',
            border: OutlineInputBorder(),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedAnswers[questionIndex]?.first ?? 'Select a value',
              isExpanded: true,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  _onAnswerSelected(questionIndex, newValue, []);
                }
              },
              items: [
                const DropdownMenuItem<String>(
                  value: 'Select a value',
                  child: Text('Select a value'),
                ),
                ...question.answerChoices!.entries.map<DropdownMenuItem<String>>((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.key,
                    child: Text(entry.key),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRadioButton(Question question, int questionIndex){
    return Column(
      children: question.answerChoices!.entries.map((entry) {
        return RadioListTile<String>(
          title: Text(entry.key),
          value: entry.key,
          groupValue: _selectedAnswers[questionIndex]?.first,
          onChanged: (value) {
            if (value != null) {
              _onAnswerSelected(questionIndex, value, entry.value);
            }
          },
        );
      }).toList(),
    );
  }

  Widget buildMultiChoices(Question question, int questionIndex){
    return Column(
      children: question.answerChoices!.entries.map((entry) {
        bool isSelected = _selectedAnswers[questionIndex]?.contains(entry.key) ?? false;
        return CheckboxListTile(
          title: Text(entry.key),
          value: isSelected,
          onChanged: (value) {
            if (value != null) {
              _onAnswerSelected(questionIndex, entry.key, entry.value);
            }
          },
        );
      }).toList(),
    );
  }

  Widget buildInputWidget(Question question, int questionIndex) {

    switch (question.questionType) {
      case 'text':
        return buildTextField(questionIndex);

      case 'list':
        return buildListTile(question,questionIndex);

      case 'dropdown':
        return buildDropDown(question,questionIndex);

      case 'search':
        return buildSearchBar(question);

      case 'radio':
        return buildRadioButton(question, questionIndex);

      case 'multipleChoices':
        return buildMultiChoices(question, questionIndex);

      case 'slider':
        return Slider(
          value: 0,
          min: 0,
          max: 100,
          divisions: 10,
          label: "Select a value",
          onChanged: (value) {
            setState(() {

            });
          },
        );

      case 'datetime':
        return ElevatedButton(
          onPressed: () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (selectedDate != null) {
              _onAnswerSubmitted(selectedDate.toString());
            }
          },
          child: const Text('Select Date'),
        );

      default:
        return const Text("Unsupported question type");
    }
  }

}



