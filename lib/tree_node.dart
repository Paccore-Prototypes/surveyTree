import 'package:infosurvey/enum.dart';

class TreeNode {
  int id;
  bool isMandatory;
  String question;
  String? description;
  String? image;
  WidgetType questionType; // Changed type to WidgetType
  Map<String, dynamic> answerChoices;
  List<TreeNode> children;
  int? score;
  String? imagePosition;
  String? imagePlace;
  int? imageHeight;
  int? imageWidth;
  String? answerDescription;
  String? inputType;

  TreeNode({
    required this.id,
    required this.isMandatory,
    required this.question,
    required this.description,
    this.image,
    required this.questionType,
    required this.answerChoices,
    this.children = const [],
    this.score,
    this.imagePosition,
    this.imagePlace,
    this.imageHeight,

    this.imageWidth,
    this.answerDescription,

    this.inputType,
  
  });
}

class TreeModel {
  List<TreeNode> nodes;

  TreeModel(this.nodes);

  factory TreeModel.fromJson(dynamic data) {
    List<TreeNode> nodes = [];

    for (var item in data) {
      nodes.add(_parseNode(item));
    }

    return TreeModel(nodes);
  }

  static TreeNode _parseNode(Map<dynamic, dynamic> data) {
    return TreeNode(
      id: data['id'] ?? 0,
      isMandatory: data['isMandatory'] ?? false,
      question: data['question'] ?? '',
      description: data['description'] ?? '',
      image: data['image'] ?? '',
      questionType: _getWidgetType(data['questionType'] ?? ''),
      answerChoices: data['answerChoices'] ?? {},
      score: data['score'] ?? 0,
      imagePosition: data['imagePosition'] ?? 'top',
      imagePlace: data['imagePlace'] ?? 'center',
      imageHeight: data['imageHeight'] ?? 100,
      imageWidth: data['imageWidth'] ?? 100,

      answerDescription: data['answerDescription'] ?? '',

      inputType: data['inputType']??'text',

      children: _parseChildren(data['answerChoices']),
    );
  }

  static List<TreeNode> _parseChildren(Map<String, dynamic>? answerChoices) {
    if (answerChoices == null) {
      return [];
    }

    List<TreeNode> children = [];

    answerChoices.forEach((key, value) {
      List<TreeNode> childNodes = [];

      if (value is List) {
        for (var item in value) {
          childNodes.add(_parseNode(item));
        }
      }

      children.add(
        TreeNode(
          id: -1, // Placeholder value for children without a specific ID
          isMandatory: false, // Placeholder value for children without isMandatory
          question: key,
          description: key,
          image: '',
          questionType: _getWidgetType(key), // Placeholder value for children without questionType
          imagePosition: key,
          imagePlace: key,
          imageHeight: 100,
          imageWidth: 150,
          answerDescription: '',
          answerChoices: {},
          children: childNodes,
        ),
      );
    });

    return children;
  }


    static WidgetType _getWidgetType(String questionType) {
    switch (questionType) {
      case "radio":
        return WidgetType.radio;
      case "slider":
        return WidgetType.slider;
      case "multipleChoices":
        return WidgetType.multipleChoices;
      case "datetime":
        return WidgetType.datetime;
      case "list":
        return WidgetType.list;
      case "text":
        return WidgetType.text;
      default:
        return WidgetType.none;
    }
  }

}
