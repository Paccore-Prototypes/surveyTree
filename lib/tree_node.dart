class TreeNode {
  int id;
  bool isMandatory;
  String question;
  String? description;
  String? image;
  String questionType;
  Map<String, dynamic> answerChoices;
  List<TreeNode> children;
  int? score;
  String? imagePosition;

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
    this.imagePosition
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
      questionType: data['questionType'] ?? '',
      answerChoices: data['answerChoices'] ?? {},
      score: data['score'] ?? 0,
      imagePosition: data['imagePosition'] ?? '',
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
          questionType: key, // Placeholder value for children without questionType

          imagePosition: key,
          answerChoices: {},
          children: childNodes,
        ),
      );
    });

    return children;
  }
}
