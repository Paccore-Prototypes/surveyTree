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
  String? imagePlace;
  int? imageHeight;
  int? imageWidth;
  String? answerDescription;
  String? inputType;
  bool? listGridType;
  String? imageOption;
  bool? isMultiListSelects;

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
    this.listGridType,
    this.imageOption,this.isMultiListSelects

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
      score: data['score'] ?? 1,
      imagePosition: data['imagePosition'] ?? 'top',
      imagePlace: data['imagePlace'] ?? 'center',
      imageHeight: data['imageHeight'] ?? 1,
      imageWidth: data['imageWidth'] ?? 1,
      imageOption: data['imageOption'] ?? '',
      answerDescription: data['answerDescription'] ?? '',
      isMultiListSelects: data['isMultiListSelects'] ?? false,
      inputType: data['inputType']??'text',
      listGridType: data['listGridType'] ?? false,

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
          score: 1,
          image: '',
          questionType: key,
          imagePosition: key,
          imagePlace: key,
          imageHeight: 100,
          imageWidth: 150,
          answerDescription: key,
          answerChoices: {},
          children: childNodes,
        ),
      );
    });

    return children;
  }
}
