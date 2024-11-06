class Question {
  final int? id;
  final bool? isMandatory;
  final String? question;
  final String? description;
  final String? questionType;
  final String? image;
  final int? score;
  final Map<String, List<Question>>? answerChoices;


  Question({
    this.id,
    this.isMandatory,
    this.question,
    this.description,
    this.questionType,
    this.image,
    this.score,
    this.answerChoices,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    Map<String, List<Question>>? parsedAnswerChoices;

    if (json['answerChoices'] != null) {
      parsedAnswerChoices = {};
      (json['answerChoices'] as Map<String, dynamic>).forEach((key, value) {
        if (value != null && value is List) {
          parsedAnswerChoices![key] = value.map((q) => Question.fromJson(q)).toList();
        }
      });
    }

    return Question(
      id: json['id'],
      isMandatory: json['isMandatory'] ?? false,
      question: json['question'],
      description: json['description'],
      questionType: json['questionType'],
      image: json['image'],
      score: json['score'],
      answerChoices: parsedAnswerChoices,
    );
  }
}
