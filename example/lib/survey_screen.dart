/*
import 'package:flutter/material.dart';
import 'package:survey_module_plugin/model/tree_node_model.dart';

class SurveyPage extends StatefulWidget {
  final List<Question> questions;

  SurveyPage({required this.questions});

  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  List<Question> _questionStack = [];
  Map<int, List<String>> _selectedAnswers = {}; // Track selected answers by question index
  int _currentIndexInJson = 0; // Track the current position in the JSON data

  @override
  void initState() {
    super.initState();
    _loadNextBaseQuestion();
  }

  void _loadNextBaseQuestion() {
    if (_currentIndexInJson < widget.questions.length) {
      setState(() {
        _questionStack.add(widget.questions[_currentIndexInJson]);
        _currentIndexInJson++; // Move to the next question in JSON for future calls
      });
    }
  }

  void _onAnswerSubmitted(String answer) {
    _loadNextBaseQuestion();
  }

  void _onAnswerSelected(int questionIndex, String selectedAnswer, List<Question> nextQuestions) {
    setState(() {
      // Add or remove the selected answer from the list
      if (_selectedAnswers[questionIndex] == null) {
        _selectedAnswers[questionIndex] = [];
      }

      if (_selectedAnswers[questionIndex]!.contains(selectedAnswer)) {
        _selectedAnswers[questionIndex]!.remove(selectedAnswer);
      } else {
        _selectedAnswers[questionIndex]!.add(selectedAnswer);
      }

      if (nextQuestions.isNotEmpty) {
        // Add sub-questions to the stack if they exist
        _questionStack.addAll(nextQuestions);
      } else {
        // No sub-questions, load the next base question from JSON
        _loadNextBaseQuestion();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Survey")),
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
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        if (question.image != null) Image.network(question.image!),
        SizedBox(height: 10),
        buildInputWidget(question, questionIndex),
        SizedBox(height: 20),
      ],
    );
  }

  Widget buildInputWidget(Question question, int questionIndex) {
    bool isAnswered = _selectedAnswers.containsKey(questionIndex);

    switch (question.questionType) {
      case 'text':
        return TextFormField(
          decoration: const InputDecoration(
            labelText: 'Your answer',
            border: OutlineInputBorder(),
          ),
          onFieldSubmitted: (value) {
            _onAnswerSubmitted(value);
          },
        );

      case 'list':
        return Column(
          children: question.answerChoices!.entries.map((entry) {
            return ListTile(
              title: Text(entry.key),
              onTap: isAnswered ? null : () {
                _onAnswerSelected(questionIndex, entry.key, entry.value);
              },
              enabled: !isAnswered,
            );
          }).toList(),
        );

      case 'radio':
        return Column(
          children: question.answerChoices!.entries.map((entry) {
            return RadioListTile<String>(
              title: Text(entry.key),
              value: entry.key,
              groupValue: _selectedAnswers[questionIndex]?.first, // Set the selected value
              onChanged: isAnswered ? null : (value) {
                _onAnswerSelected(questionIndex, value!, entry.value);
              },
            );
          }).toList(),
        );

      case 'multipleChoices':
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

      case 'slider':
        return Slider(
          value: 0,
          min: 0,
          max: 100,
          divisions: 10,
          label: "Select a value",
          onChanged: isAnswered
              ? null
              : (value) {
            setState(() {

             });
          },
        );

      case 'datetime':
        return ElevatedButton(
          onPressed: isAnswered ? null : () async {
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
          child: Text('Select Date'),
        );

      default:
        return Text("Unsupported question type");
    }
  }
}
*/


import 'package:flutter/material.dart';

import 'tree_model.dart';

class SurveyPage extends StatefulWidget {
  final List<Question> questions;

  SurveyPage({required this.questions});

  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  List<Question> _questionStack = [];
  Map<int, List<String>> _selectedAnswers = {}; // Track selected answers by question index
  int _currentIndexInJson = 0; // Track the current position in the JSON data

  // Track the last selected question and its sub-questions
  int? _lastMainQuestionIndex;
  List<Question> _lastSubQuestions = [];


  @override
  void initState() {
    super.initState();
    _loadNextBaseQuestion();
  }

  void _loadNextBaseQuestion() {
    if (_currentIndexInJson < widget.questions.length) {
      setState(() {
        _questionStack.add(widget.questions[_currentIndexInJson]);
        _currentIndexInJson++;
      });
    }
  }

  void _onAnswerSubmitted(String answer) {
    _loadNextBaseQuestion();
  }

  void _onAnswerSelected(int questionIndex, String selectedAnswer, List<Question> nextQuestions) {
    setState(() {
      // If selected question index is less than the length, remove all questions after it
      if (questionIndex < _questionStack.length - 1) {
        _questionStack.removeRange(questionIndex + 1, _questionStack.length);
        _selectedAnswers.removeWhere((key, _) => key > questionIndex);

        // Reset currentIndexInJson to the selected question index
        _currentIndexInJson = questionIndex + 1;
      }

      // Update the selected answer for the current question
      _selectedAnswers[questionIndex] = [selectedAnswer];

      // Set the current main question index and update sub-questions
      _lastMainQuestionIndex = questionIndex;
      _lastSubQuestions = nextQuestions;

      // Add new sub-questions if they exist
      if (nextQuestions.isNotEmpty) {
        _questionStack.addAll(nextQuestions);
      } else {
        // Load the next base question if no sub-questions exist
        _loadNextBaseQuestion();
      }
    });
  }


  void _onAnswerSelected1(int questionIndex, String selectedAnswer, List<Question> nextQuestions) {
    setState(() {
      // Check if the selected question index is less than the current question stack length
      if (questionIndex < _questionStack.length - 1) {
        // Remove all questions after the selected question index
        _questionStack.removeRange(questionIndex + 1, _questionStack.length);

        // Remove answers associated with questions after the selected index
        _selectedAnswers.removeWhere((key, _) => key > questionIndex);
      }

      // Update the selected answer for the current question
      _selectedAnswers[questionIndex] = [selectedAnswer];

      // Set the current main question index and update sub-questions
      _lastMainQuestionIndex = questionIndex;
      _lastSubQuestions = nextQuestions;

      // Add new sub-questions if they exist
      if (nextQuestions.isNotEmpty) {
        _questionStack.addAll(nextQuestions);
      } else {
        // Load the next base question if no sub-questions exist
        _loadNextBaseQuestion();
      }
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

  Widget buildInputWidget(Question question, int questionIndex) {
    // bool isAnswered = _selectedAnswers.containsKey(questionIndex);

    switch (question.questionType) {
      case 'text':
        return TextFormField(
          decoration: const InputDecoration(
            labelText: 'Your answer',
            border: OutlineInputBorder(),
          ),
          onFieldSubmitted: (value) {
            _onAnswerSubmitted(value);
          },
        );

      case 'list':
        return Column(
          children: question.answerChoices!.entries.map((entry) {
            return ListTile(
              title: Text(entry.key),
              onTap: () {
                _onAnswerSelected(questionIndex, entry.key, entry.value);
              },
            );
          }).toList(),
        );

      case 'radio':
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

      case 'multipleChoices':
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

      case 'slider':
        return Slider(
          value: 0,
          min: 0,
          max: 100,
          divisions: 10,
          label: "Select a value",
          onChanged: (value) {
            setState(() {
              // Handle slider value update if needed
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

