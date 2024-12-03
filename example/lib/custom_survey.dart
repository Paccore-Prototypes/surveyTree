import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class TreeNode {
  int id;
  bool isMandatory;
  String question;
  String questionType;
  Map<String, dynamic> answerChoices;
  List<TreeNode> children;
  String? placeholder;

  TreeNode({
    required this.id,
    required this.isMandatory,
    required this.question,
    required this.questionType,
    required this.answerChoices,
    this.placeholder,
    this.children = const [],
  });

  factory TreeNode.fromJson(Map<String, dynamic> json) {
    return TreeNode(
      id: json['id'] ?? 0,
      isMandatory: json['isMandatory'] ?? false,
      question: json['question'] ?? '',
      questionType: json['questionType'] ?? '',
      answerChoices: json['answerChoices'] ?? {},
      placeholder: json['placeholder'],
      children: json['children'] != null
          ? (json['children'] as List)
          .map((e) => TreeNode.fromJson(e))
          .toList()
          : [],
    );
  }
}

class TreeModel {
  final List<TreeNode> nodes;

  TreeModel(this.nodes);

  factory TreeModel.fromJson(List<dynamic> data) {
    return TreeModel(data.map((e) => TreeNode.fromJson(e)).toList());
  }
}

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  late Future<TreeModel> treeModelFuture;
  List<TreeNode> shownQuestions = [];
  int currentBaseQuestionIndex = 0;
  Map<int, String> selectedAnswers = {};
  Map<int, List<TreeNode>> subQuestions = {};
  final Map<int, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    treeModelFuture = _loadTreeModel();
  }

  Future<TreeModel> _loadTreeModel() async {
    String jsonString = await rootBundle.loadString('assets/json/tree_model.json');
    List<dynamic> jsonData = json.decode(jsonString);
    return TreeModel.fromJson(jsonData);
  }

  void _onOptionSelected(TreeNode node, String selectedOption) {
    setState(() {
      selectedAnswers[node.id] = selectedOption;
      subQuestions[node.id] = node.answerChoices[selectedOption]
          ?.map<TreeNode>((e) => TreeNode.fromJson(e))
          .toList() ??
          [];

      if (subQuestions[node.id]!.isEmpty) {
        _showNextBaseQuestion();
      }
    });
  }



  void _showNextBaseQuestion() {
    if (currentBaseQuestionIndex < shownQuestions.length - 1) {
      currentBaseQuestionIndex++;
    } else {
      currentBaseQuestionIndex++;
      treeModelFuture.then((treeModel) {
        if (currentBaseQuestionIndex < treeModel.nodes.length) {
          setState(() {
            shownQuestions.add(treeModel.nodes[currentBaseQuestionIndex]);
          });
        }
      });
    }
  }



  Widget _buildQuestionTile(TreeNode node) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            node.question,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (node.questionType == "radio")
            Column(
              children: node.answerChoices.keys.map((option) {
                return RadioListTile<String>(
                  title: Text(option),
                  value: option,
                  groupValue: selectedAnswers[node.id],
                  onChanged: (value) {
                    if (value != null) {
                      _onOptionSelected(node, value);
                    }
                  },
                );
              }).toList(),
            ),
          if (node.questionType == "text")
            TextFormField(
              controller: _controllers.putIfAbsent(
                  node.id, () => TextEditingController()),
              decoration: InputDecoration(
                labelText: node.placeholder ?? 'Enter your response',
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  selectedAnswers[node.id] = value;
                });
              },
              onFieldSubmitted: (_) => _showNextBaseQuestion(),
            ),
          const SizedBox(height: 8),
          if (subQuestions[node.id] != null)
            Column(
              children: subQuestions[node.id]!
                  .map((subNode) => _buildQuestionTile(subNode))
                  .toList(),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Survey Questions')),
      body: FutureBuilder<TreeModel>(
        future: treeModelFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading questions'));
          } else {
            if (shownQuestions.isEmpty) {
              shownQuestions.add(snapshot.data!.nodes.first);
            }
            return ListView(
              children: shownQuestions
                  .map((node) => _buildQuestionTile(node))
                  .toList(),
            );
          }
        },
      ),
    );
  }
}


// void _onOptionSelected2(TreeNode node, String selectedOption) {
//   setState(() {
//     selectedAnswers[node.id] = selectedOption;
//     subQuestions[node.id] = node.answerChoices[selectedOption]
//         ?.map<TreeNode>((e) => TreeNode.fromJson(e))
//         .toList() ?? [];
//
//     // Restrict loading next base question if this sub-question already has a base question answered
//     if (subQuestions[node.id]!.isEmpty) {
//       // Check if the current node is a sub-node under another answered base node
//       bool shouldLoadNextBaseQuestion = true;
//
//       // Check if any previous sub-node (from selectedAnswers) has the same parent base node
//       for (var entry in selectedAnswers.entries) {
//         if (entry.key != node.id && selectedAnswers.containsKey(node.id)) {
//           print('having the selected answers values-----------------$selectedAnswers');
//           shouldLoadNextBaseQuestion = false;
//           break;
//         }
//       }
//
//       // If no such previous sub-node exists, load the next base question
//       if (shouldLoadNextBaseQuestion) {
//         _showNextBaseQuestion();
//       }
//     }
//   });
// }
