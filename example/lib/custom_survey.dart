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
    });
  }

  Widget _buildSubQuestions(TreeNode node) {
    if (!subQuestions.containsKey(node.id) || subQuestions[node.id]!.isEmpty) {
      return Container();
    }
    return Column(
      children: subQuestions[node.id]!.map((subNode) {
        return _buildQuestionTile(subNode);
      }).toList(),
    );
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
            ),
          const SizedBox(height: 8),
          _buildSubQuestions(node),
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
            return ListView(
              children: snapshot.data!.nodes.map((node) {
                return _buildQuestionTile(node);
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
